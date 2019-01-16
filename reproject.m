% Given a set(s) of 3D point and a camera matrix, compute reprojection point
% set on tha camera
function rPointSet2D = reproject(PointSet3D, CameraMatrix)
%   PointSet3D - n x 3 or an cell array of 3-column matrices
%   CameraMatrix - 3 x 4
%   rPointSet2D - n x 2 or an cell array of 2-column matrices
    rPointSet2D = cell(length(PointSet3D),1); % it doesn't matter if rPointSet2D is matrix
    
    % in case CameraMatrix does not exist, meaning that it is zeros matrix
    if isequal(CameraMatrix, zeros(3,4))
        disp('invalid CameraMatrix in function reproject!');
        if iscell(PointSet3D)
            for i = 1:length(PointSet3D)
                n = size(PointSet3D{i}, 1);
                rPointSet2D = zeros(n, 2);
            end
        else
            n = size(PointSet3D, 1);
            rPointSet2D = zeros(n, 2);
        end
        return;
    end
   
    % reprojection
    if iscell(PointSet3D)
        for i = 1:length(PointSet3D)
            rPointSet2D{i} = reproj(PointSet3D{i}, CameraMatrix);
        end
    else
        rPointSet2D = reproj(PointSet3D, CameraMatrix);
    end
end

function rPointSet2D = reproj(PointSet3D, CameraMatrix)
    % mask for valid 3D points (not [0 0 0]), may not be perfect solution
    mask = any(PointSet3D'); % 1xn
    
    n = size(PointSet3D, 1);
    Rp = CameraMatrix * [PointSet3D'; ones(1, n)]; % 3 x n
    Rp = Rp(1:2, :) ./ Rp(3, :); % 2 x n
    Rp(:, ~mask) = zeros(2, sum(~mask)); % set coordinates of invalid points to 0
    
    rPointSet2D = Rp'; % n x 2
end
