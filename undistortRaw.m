function imUndistortion = undistortImageGOPRO(im, Omega, fx, fy ,name , Px , Py)

[X, Y] = meshgrid(1:(size(im,2)), 1:(size(im,1)));
h = size(X, 1); w = size(X,2);
X = X(:);
Y = Y(:);

pt = [X'; Y'];
pt = bsxfun(@minus, pt, [Px;Py]);
pt = bsxfun(@rdivide, pt, [fx;fy]);
r_u = sqrt(sum(pt.^2, 1));
r_d = 1 / Omega * atan(2*r_u*tan(Omega/2));
% r_u = tan(r_d*Omega)/2/tan(Omega/2);
% pt = bsxfun(@times, pt, r_u ./ r_d);
x_u = r_d./r_u.*pt(1,:);
y_u = r_d./r_u.*pt(2,:);
pt2 = [x_u;y_u];
 pt = bsxfun(@times, pt2, [fx;fy]);
pt2 = bsxfun(@plus, pt, [Px;Py]);

imUndistortion(:,:,1) = reshape(interp2(im(:,:,1), pt2(1,:), pt2(2,:)), [h, w]);
imUndistortion(:,:,2) = reshape(interp2(im(:,:,2), pt2(1,:), pt2(2,:)), [h, w]);
imUndistortion(:,:,3) = reshape(interp2(im(:,:,3), pt2(1,:), pt2(2,:)), [h, w]);
I2 = im2uint8(imUndistortion);

% figure(1)
% clf;
% imshow(I2);
imwrite(I2,name);