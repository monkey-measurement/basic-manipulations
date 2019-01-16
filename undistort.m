clc
clear
close all

% im_x= 1280;
% im_y= 720;
% fx= 547.5584;
% fy= 535.48416;
% px= 640;
% py= 360;
% % omega= 0.00161863445;
% omega= 0.00119;

im_x= 1280;
im_y= 720;
fx= 658.77248;
fy= 663.25464;
px= 636.20736;
py= 349.37424;
% omega= 0.7747;
omega=0.867213;


firtFrame = 1;
lastFrame = 540;
% sampling_rate = 30;
first_cam = 1;
last_cam = 35;
ss = 460;
path = sprintf('/mnt/monkey_data/Experiment6/allFrames_video1_%d', ss);
for i=firtFrame:lastFrame
    mkdir(sprintf('%s/%08d', path, i));
    fpath = sprintf('%s/%08d/image', path, i);
    mkdir(fpath);
    for j=first_cam:last_cam
       image_dir = ['/mnt/monkey_data/Experiment6/',int2str(j),sprintf('/image_video1_%d/image%07d.bmp', ss, i)];
       if exist(image_dir, 'file') ~= 2,  continue; end
       I = imread(image_dir);
       im2 = imresize(I,1/(1920/1280));
       img = im2double(im2);
       if j == 22
           img = imrotate(img,180);
       end
       out_dir = sprintf('%s/image%07d.jpg', fpath, j);
       imUndistortion = undistortImageGOPRO(img, omega, fx, fy ,out_dir , px , py);
    end
end
