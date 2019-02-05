function [filtered,img,res,background] = bgSubtraction(threshold)
  %% COMPUTE BACKGROUND FROM -+ 10 IMAGES
  % parts = split(imgpath,'/');
  % idx = str2num(parts{end-2});
  % low = max(idx-10,1);
  % high = idx+10;
  % for i=low:high
  %   parts{end-2} = sprintf('%08d', i);
  %   path = join(parts,'/');
  %   imgs(i-low+1,:,:,:) = imread(path{1});
  % end
  % means = squeeze(mean(imgs, 1));
  % 
  % img = squeeze(imgs(idx-low+1,:,:,:));
  % res = double(img) - means;
  % % threshold = 0;
  % % mask = res > threshold;
  % % foreground = uint8(double(img) .* mask);
  % % imshow(foreground);
  % 
  % H = size(img,1);
  % W = size(img,2);
  % m = mean(res, 3);
  % [~,I] = max(reshape(m, [], 1));
  % [h,r] = ind2sub([H,W], I);
  % patch = img(max(1,h-50):min(h+50,H), max(1,r-50):min(W,r+50), :);
  % % imshow(patch);
  % try
  %   imwrite(patch, sprintf('test/image%07d.jpg', idx));
  % catch
  %   keyboard();
  % end


  %% ALTERNATE
  %  Background consists of mean of some images with no monkey in them

  % cams = [ 2 4 6 18 20 22 ]';
  cams = [2 4 6 10 12 14 15 18 20 22 23 25 27 29 30 33]';
  [Rs, Cs] = readPoses();
  Rs = Rs(cams,:,:);
  Cs = Cs(cams,:,:);

  backgrounds_file = 'background/results/experiment_1_4/sequence_1/sequence1_backgrounds.mat';
  if exist(backgrounds_file,'file') == 2
   load(backgrounds_file); 
  else
    for c=1:size(cams,1)
      backgrounds(c,:,:,:) = get_background(cams(c));
    end
    save(backgrounds_file, 'backgrounds');
  end
  % keyboard();

  frames = [301:856];
  data = containers.Map();
  for f=frames
    if mod(f,100) == 0
      disp(f);
    end

    for c=1:size(cams,1)
      [patch, obj] = estimate_body_center(f,cams(c),squeeze(backgrounds(c,:,:,:)),threshold);
      scores(c) = obj.score;
      patches{c} = patch;
      objs(c) = obj;
    end
    [~,I] = sort(scores,'descend');
    top_k = 8;
    fprintf('-----------------Frame %d-----------------\n',f);
    for i=1:top_k
      cam_idx = I(i);
      fprintf(1, 'Cam %d: %d\n', cams(cam_idx), scores(cam_idx));
      obj = objs(cam_idx);
      obj.rank = i;
      filename = sprintf('frame%d_rank%d_cam%d_span:%d:%d:%d:%d_center:%d:%d.jpg', f, i, cams(cam_idx), obj.bbox(1), obj.bbox(2), obj.bbox(3), obj.bbox(4), obj.body_center(1), obj.body_center(2));
      filepath = sprintf('background/results/experiment_1_4/sequence_2/%s', filename);
      imwrite(patches{cam_idx}, filepath);
      data(filename) = obj;
      % imshow(squeeze(patches{I(i)}));
      % waitforbuttonpress();
    end
    % keyboard();

    % disp(body_centers);
    % body_center = triangulate(body_centers, Rs, Cs);
    % body_centers = reprojected(body_center, Rs, Cs, cams, f);
    % disp(body_centers);
  end
  save('background/results/experiment_1_4/sequence_2/data.mat', 'data');
end

function background = get_background(cam)
  k = 1;
  for vnum=1:5
    data_dir = sprintf('background/cam%d/vid%d/empty*', cam, vnum);
    fprintf(1, 'Reading from %s\n', data_dir);
    bg_files = dir(data_dir);
    fprintf(1, 'Total: %d\n', size(bg_files,1));
    for i=1:size(bg_files,1)
      background(k,:,:,:) = imread(sprintf('%s/%s', bg_files(i).folder, bg_files(i).name));
      k = k+1;
      if mod(k,10) == 0,
        disp(k);
      end
    end
  end
  % keyboard();
  background = squeeze(mean(background, 1));
end

function [patch, obj] = estimate_body_center(f,c,background,threshold)
  imgpath = sprintf('background/cam%d/vid1/monkey_%07d.jpg', c, f);
  img = imread(imgpath);
  res = abs(double(img) - background);

  mask = res > threshold;
  % % disp(sum(reshape(mask,[],1)));
  score = sum(reshape(mask,[],1));
  filtered = uint8(double(img) .* mask);
  filtered = medfilt2(rgb2gray(filtered));

  % imwrite(filtered, sprintf('background/cam%d/vid1/filtered_%07d.jpg', c, f));

  H = size(img,1);
  W = size(img,2);

  % res = res .* mask;
  % m = rgb2gray(res);

  %% MEAN/MEDIAN based
  [hs,rs] = ind2sub([H,W], find(filtered));
  h = int16(median(hs,1)); r = int16(median(rs,1));
  body_center = [r h]';

  span = 300;
  lh = max(1,h-span);
  hh = min(H,h+span-1);
  lw = max(1,r-span);
  hw = min(W,r+span-1);
  patch = img(lh:hh, lw:hw, :);
  % patch = imresize(patch, 3);   % scaled to 3 times the size
  obj = struct('frame',f, 'cam',c, 'bbox',[lh hh lw hw], 'body_center',[h r], 'score',score);
  % imwrite(patch, sprintf('background/cam%d/vid1/patch_%07d.jpg', c, f));
end

% Undistort, then triangulate
function body_center = triangulate(body_centers, Rs, Cs)
  [K,fx,fy,px,py,omega] = getIntrinsicParams();
  num_cams = size(body_centers,1);
  A = [];
  b = [];
  for i=1:num_cams
    u = undistort_point(body_centers(i,:), fx, fy, px, py, omega);
    % fprintf(1, 'Undistortion: (%d, %d) -> (%f, %f)\n', body_centers(i,1), body_centers(i,2), u(1), u(2));
    ux = Vec2Skew([u; 1]);

    R = squeeze(Rs(i,:,:)); C = Cs(i,:)';
    P = K * R * [eye(3) -C];

    A = [ A; ux * P(:,1:3) ];
    b = [ b; -ux * P(:,4) ];
  end

  body_center = A \ b;

  % w1 = P1 * [pt; 1];  w1 = w1 / w1(3);   disp(sprintf('Reprojection error on I1: %f', norm(w1-u1)));
  % w2 = P2 * [pt; 1];  w2 = w2 / w2(3);   disp(sprintf('Reprojection error on I2: %f', norm(w2-u2)));
  % disp('Origin projection: ');  disp(P1 * [pt; ones(1,1)]);
end

function body_centers = reprojected(body_center, Rs, Cs, cams, f)
  [K,fx,fy,px,py,omega] = getIntrinsicParams();
  num_cams = size(Rs,1);
  for i=1:num_cams
    R = squeeze(Rs(i,:,:)); C = Cs(i,:)';
    P = K * R * [eye(3) -C];
    pt = P * [body_center; 1];
    pt = pt(1:2) / pt(3);
    bpt = pt;
    pt = distort_point(pt,fx,fy,px,py,omega)';
    % fprintf(1, 'Distortion: (%f, %f) -> (%d, %d)\n', bpt(1), bpt(2), pt(1), pt(2));
    h = pt(2);  w = pt(1);
    body_centers(i,:) = pt;

    imgpath = sprintf('background/cam%d/vid1/monkey_%07d.jpg', cams(i), f);
    img = imread(imgpath);
    H = size(img,1);  W = size(img,2);
    patch = img(max(1,h-100):min(h+100,H), max(1,w-100):min(W,w+100), :);
    imwrite(patch, sprintf('background/cam%d/vid1/triangulated_patch_%07d.jpg', cams(i), f));
  end
end
