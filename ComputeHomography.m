function H = ComputeHomography(u, X)

A = [];
for i = 1 : size(u,1)
    A = [A; X(i,:) zeros(1,3) -u(i,1)*X(i,:)];
    A = [A; zeros(1,3) X(i,:) -u(i,2)*X(i,:)];
end

[u, d, v] = svd(A);
h = v(:,end);
H = [h(1:3)'; h(4:6)'; h(7:9)'];
H = H/norm(H);