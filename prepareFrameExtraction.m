clc
clear
close all

path = '/mnt/monkey_data/Experiment6/';

for i = 1 :35
    i;
    xyloObj = VideoReader([path,int2str(i),'/im/video1.mp4']);
    info = get(xyloObj);
    all_durations(i) = info.Duration;
    clear info xyloObj
end

% Exception
second_vid = get(VideoReader([path, '20/second_im/video2.mp4']));
all_durations(20) = all_durations(20) + second_vid.Duration;

% 
% for i = 1 : 35
%     i
%     mkdir([path,int2str(i),'\second_im']);
%     pp = ([path,int2str(i),'\second_im\']);
%     movefile([path,int2str(i),'\image\video2.mp4'],pp) 
% end

% for i = 1 : 35
%     i
%     delete([path,int2str(i),'\image\*.bmp'],pp) 
% end


% %22 baraxe.
% 
% for i = 18 : 35
% i
% pp = ([path,int2str(i),'\image\']);
% 
%     files = dir(fullfile(pp, '*.mp4'));
%     for j = 1 : length(files)
%         movefile([pp,files(j).name],[pp,'video',int2str(j),'.mp4']);
%     end
% end

SW = [180+5.59 180+27.38 120+45.52 47.56 120+14.46 180+0.28 60+33.03 17.95 59.96 20.08 60+59.07 5.99 45.42 28.20 60+55.60 60+48.16 55.72 120+59.14 ...
    60+23.95 12.32 10.70 180+2.92 180+8.06 60+26.44 120+54.86 60+28.83 180+24.40 14.81 58.59 180+20.53 60+49.06 53.59 120+52.34 43.35 30.37];
VT = [300+19.97 300+38.02 240+40.20 120+18.82 240+5.14 300+2.42 180+13.76 120+27.11 120+30.68 120+27.58 180+48.21 120+22.21 120+23.21 120+18.79 180+44.04 ...
    180+33.63 120+29.45 300+0.23 120+56.61 120+23.98 120+24.78 180+33.90 300+23.76 180+0.58 240+51.69 15.43 300+37.14 120+25.11 120+30.73 300+39.26 ...
    180+32.56 120+28.90 240+48.34 120+22.46 120+19.27];
SW_VT = SW - VT;
% start for SFM is 330.
% start for frame is 810.
% startSW = SW_VT(34)+413;
ss = 460;
startSW = SW_VT(17) + ss;
startVT = (startSW - SW_VT); 
% base is camera 17.

handle = fopen(sprintf('../extract_video1_%d.sh', ss), 'w');
for i=1:35
    dir = sprintf('/mnt/monkey_data/Experiment6/%d', i);
    out_dir = sprintf('%s/image_video1_%d', dir, ss);
    mkdir(out_dir);
    cmd = sprintf('ffmpeg -ss %f -i %s/im/video1.mp4 -t 540 -r 1 %s/image%%07d.bmp', startVT(i), dir, out_dir);
    fprintf(handle, '%s\n', cmd);
end
fclose(handle);

% im_x= 1280;
% im_y= 720;
% fx= 658.77248;
% fy= 663.25464;
% px= 636.20736;
% py= 349.37424;
% % omega= 0.7747;
% omega=0.867213;
% fpath = 'G:\Research\Data\MonkeyData\experiment6\Yuan\'; 
% for i = 1 : 35
%     path = ['G:\Research\Data\MonkeyData\experiment6\',int2str(i),'\im\image0000001.bmp'];
%     im = imread(path);
%     im2 = imresize(im,1/(1920/1280));
%     img = im2double(im2);
%     if i == 22
%         img = imrotate(img,180);
%     end
%     out_dir = [fpath,sprintf('image%07d.jpg',i)];
%     imUndistortion = undistortImageGOPRO(img, omega, fx, fy ,out_dir , px , py);
%     
% end
