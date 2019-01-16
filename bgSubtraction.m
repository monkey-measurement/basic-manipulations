function [filtered,img,res,background] = bgSubtraction(threshold)
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
for i=1:8
  background(i,:,:,:) = imread(sprintf('background/cam5/vid1/empty_%03d.jpg', i));
  background(8 + i,:,:,:) = imread(sprintf('background/cam5/vid4/empty_%03d.jpg', i));
end
% keyboard();
background = squeeze(mean(background, 1));

for i=1:120
  if mod(i,100) == 0
    disp(i);
  end
  imgpath = sprintf('background/cam5/vid1/monkey_%03d.jpg', i);
  img = imread(imgpath);
  res = abs(double(img) - background);

  mask = res > threshold;
  % % disp(sum(reshape(mask,[],1)));
  filtered = uint8(double(img) .* mask);
  filtered = medfilt2(rgb2gray(filtered));
  % gaussian_blur = 4;
  % filtered = imgaussfilt(filtered, gaussian_blur);
  % imshow(filtered);
  % waitforbuttonpress();
  % for stddev=[1 2 4 8]
  %   blur = imgaussfilt(filtered, stddev);
  %   imshow(blur);
  %   waitforbuttonpress();
  % end
  imwrite(filtered, sprintf('background/cam5/vid1/filtered_%03d.jpg', i));

  H = size(img,1);
  W = size(img,2);

  % res = res .* mask;
  % m = rgb2gray(res);

  %% MAX based
  % [~,I] = max(reshape(m, [], 1));
  % [h,r] = ind2sub([H,W], I);

  %% AVG based
  [hs,rs] = ind2sub([H,W], find(filtered));
  h = int16(mean(hs,1)); r = int16(mean(rs,1));

  patch = img(max(1,h-100):min(h+100,H), max(1,r-100):min(W,r+100), :);

  %% k-means based
  % I = find(m);
  % num_clusters = 3;
  % [idx,C] = kmeans(I,num_clusters,'Replicates',5,'Display','final');
  % [hs,rs] = ind2sub([H,W], int32(C));
  % for k=1:num_clusters
  %   h = hs(k); r = rs(k);
  %   patch = img(max(1,h-100):min(h+100,H), max(1,r-100):min(W,r+100), :);
  %   imshow(patch);
  %   waitforbuttonpress();
  % end
  imwrite(patch, sprintf('background/cam5/vid1/patch_%03d.jpg', i));
end

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
end
