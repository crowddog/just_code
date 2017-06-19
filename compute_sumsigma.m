function sumsigma = compute_sumsigma(alpha,beta, x,rho,lambda)
%compute the vector sumsigma without id difficulty
  nLabels=size(x(:,1),1);
  sumsigma=ones(nLabels,1);
  for i=1:nLabels
    sumsigma(i)=sum(lambda(x(i,1),:).*(log(rho(x(i,1),:)).*(rho(x(i,1),:).^(alpha(x(i,2)).*beta(x(i,1)))))./(1-rho(x(i,1),:).^(alpha(x(i,2)).*beta(x(i,1)))));
  end
end