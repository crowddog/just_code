function rho = compute_rho(r)
%compute the vector rho with two models
 h = max(r(:,1));
 rho=ones(h,(size(r(1,:),2))-2);
  for t=1:h
    tem=r((r(:,1)==t),:);
    rho(t,:)=diag(tem(:,3:end))'./sum(sum(tem(:,3:end),1),2);
  end
end