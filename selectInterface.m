function selectInterface()
  frames_to_filter = 301:856;
  for f=frames_to_filter
    fnames = dir(sprintf('background/results/experiment_1_4/sequence_2/frame%d*jpg', f));
    all = figure();
    num_images = size(fnames,1);
    bw = 20;
    border(1,1,:) = [0 255 0];  % green
    % border = repmat(border, bw, bw, 1);

    for i=1:num_images
      img = imread(fullfile(fnames(i).folder, fnames(i).name));
      subplot(2, 4, i);
      imshow(img);
      ax = gca;
      set(gca,'tag',num2str(i));
      title(num2str(i));
      images{i} = img;

      % paste image onto green template to get border
      bordered_img = repmat(border, size(img,1)+2*bw, size(img,2)+2*bw, 1);
      bordered_img(bw+1:end-bw,bw+1:end-bw,:) = img;
      bordered_images{i} = uint8(bordered_img);
    end

    selected = false(size(images));
    detail = false;
    cur_detailed = 0;
    bad_frame = false;      % Not enough good candidates or similar to some past frame
    while true
      w = waitforbuttonpress;
      switch w 
      case 1 % keyboard 
        key = get(gcf,'currentcharacter'); 
        switch key
        case {'1','2','3','4','5','6','7','8'}
          if gcf == all
            if cur_detailed == 0
              detail = figure();
            else
              figure(detail);
            end
            key = str2num(key);
            cur_detailed = key;
            imshow(images{cur_detailed});
            title(cur_detailed);
          end
        case 27 % Esc
          if numel(find(selected)) < 4
            % show dialog box
            msgbox('You must select at least 4 images. If not possible, press "b" to skip as a bad frame.');
          else
            break;
          end
        case 28 % Left arrow
          if gcf == detail
            if cur_detailed > 1
              cur_detailed = cur_detailed - 1;
            else
              cur_detailed = 8;
            end
            imshow(images{cur_detailed});
            title(cur_detailed);
          end
        case 29 % Right arrow
          if gcf == detail
            if cur_detailed < 8
              cur_detailed = cur_detailed + 1;
            else
              cur_detailed = 1;
            end
            imshow(images{cur_detailed});
            title(cur_detailed);
          end
        case 'a'
          figure(all);
        case 'b'
          bad_frame = true;
          break;
        end
      case 0 % mouse click 
        mousept = get(gca,'currentPoint');
        x = mousept(1,1);
        y = mousept(1,2);
        k = str2num(get(gca,'tag')); 

        if selected(k)
          subplot(2,4,k);
          imshow(images{k});
          set(gca,'tag',num2str(k));
          title(k);
          selected(k) = false;
        else
          subplot(2,4,k);
          imshow(bordered_images{k});
          set(gca,'tag',num2str(k));
          title(k);
          selected(k) = true;
        end
      end
    end

    if ~bad_frame
      selected = find(selected);
      fprintf('  Selecting images: ');  disp(selected);
      for s=selected
        copyfile(fullfile(fnames(s).folder, fnames(s).name), 'background/results/experiment_1_4/sequence_2_selected/');
      end
      % for img in selected, move to other folder
    else
      fprintf('  Bad frame %d skipped\n', f);
    end

    close all;
  end
end
