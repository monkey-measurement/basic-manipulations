function make_dataset(data_dir)
  H = 720;  W = 1280;
  dirs = dir(sprintf('%s/0*', data_dir));
  [frameIds,Rs,Cs] = readPoses();
  K = getIntrinsicParams();
  fileID = fopen(sprintf('%s/labels.txt', data_dir),'w');

  tot = size(dirs,1);
  found = 0;
  for i=1:size(dirs,1)
    dir_ = dirs(i).name;
    afile = sprintf('%s/%s/GroundTruth3D.mat', data_dir, dir_);
    if exist(afile, 'file') ~= 2
      continue;
    end

    found = found + 1;
    load(sprintf('%s/%s/GroundTruth3D.mat', data_dir, dir_));
    img_num = str2num(dir_);
    labels3D = All3DJoints';
    for j=1:35
      if frameIds(j) == 3,  continue; end
      % masking for joints not labeled in sequence
      mask = any(labels3D);
      R = reshape(Rs(j,:,:), 3,3);
      C = reshape(Cs(j,:), 3,1 );

      points2D = K * R * (labels3D - C);
      for k=1:size(points2D,2)
        if points2D(3,k) < 0
          mask(k) = 0;
        end
      end
      points2D = points2D(1:2,:) ./ points2D(3,:);
      points2D(:, ~mask) = zeros(2, sum(~mask));
      num_keypoints_visible = 0;
      for k=1:size(points2D,2)
        x = points2D(1,k);  y = points2D(2,k);
        if mask(k) && (0 < x) && (x <= W) && (0 < y) && (y <= H)
          num_keypoints_visible = num_keypoints_visible + 1;
        end
      end

      bbox = BBin2D(points2D');
      X_l = bbox(2);  X_h = bbox(4);  del_X = X_h - X_l;
      Y_l = bbox(1);  Y_h = bbox(3);  del_Y = Y_h - Y_l;

      %% OLD LOGIC
      %% Write to file only if keypoints visible in image
      % if (del_X < W) && (-del_X < X_l) && (X_l < W) && (del_Y < H) && (-del_Y < Y_l) && (Y_l < H)

      % Write to file only if at least 10 (~80%) keypoints visible
      if num_keypoints_visible >= 10
        points2D = points2D([2,1], :);
        locs = round([ bbox(:); points2D(:) ]);
        fprintf(fileID, data_dir);
        fprintf(fileID,'/%08d/image/image%07d.jpg %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', [ img_num; frameIds(j); locs ] );
      end
    end
  end

  fprintf('Annotations: %d/%d\n', found, tot);
  fclose(fileID);
end
