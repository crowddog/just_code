function op = normalize_phi_mat(ip,nLabelers,K)
% ip is nLabelers x K x K matrix
% normalizes_phi_mat normalizes ip such that \sum_j op(n,k,j) = 1 \forall n,k

op = ip;
for n = 1:nLabelers
    for k = 1:K
        op(n,k,:) = ip(n,k,:) ./ sum(ip(n,k,:));
    end
end