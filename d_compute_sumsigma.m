
function sumsigma =d_compute_sumsigma(alpha,beta, x,rho,lambda,r)
%compute the vector sumsigma without id difficulty
  nLabels=size(x(:,1),1);
%   nQueryUrls=max(x(:,1));
  id =d_idifficulty(r);
  sumsigma=ones(nLabels,1);
  for i=1:nLabels
    sumsigma(i)=sum(lambda(x(i,1),:).*(log(rho(x(i,1),:)).*rho(x(i,1),:).^(alpha(x(i,2)).*(beta(x(i,1))+id(x(i,1)))))./(1-rho(x(i,1),:).^(alpha(x(i,2)).*(beta(x(i,1))+id(x(i,1))))));
  end
end