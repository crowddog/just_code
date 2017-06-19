function op = accumarray_mat(sub, val_mat, N)
% assumes sub is a single vector with values in the range 1:N

K = size(val_mat,2);
op = zeros(N, K);
for k = 1:K
    op(:,k) = accumarray(sub,val_mat(:,k));
end
