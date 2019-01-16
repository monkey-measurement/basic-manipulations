function [frameIds, Rs, Cs] = readPoses()
  mfile = sprintf('poses.mat');
  if exist(mfile, 'file') == 2
    load(mfile);
    return;
  end

  cfname = sprintf('camera.txt');
  cfid = fopen(cfname);

  for i=1:2, fgetl(cfid); end

  num_poses = textscan(cfid, '%s %d', 1); num_poses = num_poses{2};
  frameIds = zeros(num_poses, 1); 
  Rs = zeros(num_poses, 3, 3);
  Cs = zeros(num_poses, 3);

  for i=1:num_poses
    frame = textscan(cfid, '%d %d', 1);
    frame = frame{2}+1;
    frameIds(i) = frame;

    Cs(i,:) = cell2mat(textscan(cfid, '%f %f %f', 1));
    Rs(i,:,:) = cell2mat(textscan(cfid, '%f %f %f', 3));
  end

  save(mfile, 'frameIds', 'Rs', 'Cs');
end
