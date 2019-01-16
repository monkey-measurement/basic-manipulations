function [bbox] = BBin2D(rPointSet2Dtemp)
    Ys = rPointSet2Dtemp(:,2);
    Xs = rPointSet2Dtemp(:,1);
    bbox_top_left_y = min(Ys)-40;
    bbox_top_left_x = min(Xs)-40;
    bbox_bot_right_y = max(Ys)+40;
    bbox_bot_right_x = max(Xs)+40;
    dis1 = abs(bbox_top_left_y-bbox_bot_right_y);
    dis2 = abs(bbox_top_left_x-bbox_bot_right_x);
    if dis1 > dis2
        deltad = dis1-dis2;
        bbox_top_left_x = bbox_top_left_x - (deltad/2);
        bbox_bot_right_x = bbox_bot_right_x + (deltad/2);
    else
        deltad = dis2-dis1;
        bbox_top_left_y = bbox_top_left_y - (deltad/2);
        bbox_bot_right_y = bbox_bot_right_y + (deltad/2);
    end

    bbox = [bbox_top_left_y, bbox_top_left_x, bbox_bot_right_y, bbox_bot_right_x];
end
