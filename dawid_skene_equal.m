function [predZ,predA] = dawid_skene_equal(settings, x, nQueryUrls, nLabelers, nLabels, K, ...
    v, init_id, difficulty, expt)
% EM for Homogenous Dawid-Skene model
%hyper parameter init
% beta=1;% beta is Dirichlet concentration parameter --- each entry will be smoothed by alpha/K
assert(strcmp(difficulty,'off'));
alpha_n=zeros(nLabelers,1);
for i = 1:nLabels
   n = x(i,2);
  alpha_n(n)=alpha_n(n)+1;
 end 
%majorityvote½á¹û
beta_alpha=ones(nLabelers,1)+1.001;
beta_beta=ones(nLabelers,1)+0.001;
% predA1=zeros(nQueryUrls,2);
% for i=1:nQueryUrls
%  tmp=x((x(:,1)==i),:);
%  e=mode(tmp(:,3));
%  predA1(i,:)=[i,e];
% end
% alpha=ones(nLabelers,1);
% for i=1:nLabelers;
%  tmp=x((x(:,2)==i),:);
%  e=(tmp(:,[1,3]));
%  c=intersect(predA1,e,'rows');
%  alpha(i)=size(c,1)/size(e,1);
% end
alpha=ones(nLabelers,1)/K;
pi_vec = ones(1,K);
pi_vec=pi_vec/nQueryUrls;
% for i=1:K
%    w=0; 
%    for t=1:nQueryUrls
%       tmp1=x((x(:,1)==t),3);
%       w2=size( tmp1);
%       w1=size(tmp1==i); 
%       w=w+w1/w2;
%    end
%   pi_vec(i)=w/nQueryUrls;
% end
% disp(alpha); 
cost_function_E = -Inf*ones(settings.maxIter,1);
cost_function_M = -Inf*ones(settings.maxIter,1);
cost_function_old = -Inf;
for iter = 1:settings.maxIter 
 % E-step
 
  log_lambda = ones(nQueryUrls,1)*log(pi_vec);
 
  for i = 1:nLabels
        m = x(i,1);
        n = x(i,2);
        j = x(i,3);
        s = alpha(n);
        s = max(s,settings.EPS);
        s = min(s,1-settings.EPS);
        tmp = log((1-s)/(K-1)) *ones(1,K);
        tmp(j) = log(s);
        log_lambda(m,:) = log_lambda(m,:) + tmp;
  end
 
  log_lambda = log_lambda - max(log_lambda,[],2)*ones(1,K);
  lambda = exp(log_lambda);
  lambda = lambda ./ (sum(lambda,2)*ones(1,K));
%   disp(lambda);
    cost_function_E(iter) = compute_q_dawid_skene_equal(x,lambda,pi_vec,nLabels,alpha,beta_alpha,beta_beta,K);
    if settings.verbose >= 2
        fprintf('iter = %4d, E-step, Q = %f\n',iter,cost_function_E(iter));
    end
    
 % M-step
    
    pi_vec = sum(lambda,1)/nQueryUrls;
    alpha = beta_alpha-1;
    for i = 1:nLabels
        m = x(i,1);
        n = x(i,2);
        j = x(i,3);
        alpha(n)=alpha(n)+lambda(m,j);
%      alpha_n=alpha_n(n)+1;
    end
    alpha=alpha./(alpha_n+beta_beta+beta_alpha-2);  
cost_function_M(iter) = ...
        compute_q_dawid_skene_equal(x,lambda,pi_vec,nLabels,alpha,beta_alpha,beta_beta,K);
    fprintf('iter = %4d, M-step, Q = %f\n',iter,cost_function_M(iter));  
 % check that E- and M-steps do not decrease loglikelihood (modulo numeric errors)   
  assert((cost_function_E(iter)-cost_function_old) >= -settings.numeric_error)
%   assert((cost_function_M(iter)-cost_function_E(iter)) >= -settings.numeric_error)
  if (abs(cost_function_M(iter)-cost_function_old) < settings.thresh)
        fprintf('Breaking out since del(cost function) < %f\n',settings.thresh);
        break;
  end   
 cost_function_old  = cost_function_M(iter); 
end   
%   predZ = lambda * v;
[~,G]=max(lambda');
predA=G';
predZ = lambda * v;
% disp(lambda);
varZ = sum(lambda .* (ones(nQueryUrls,1)*v' - predZ*ones(1,K)).^2,2);
if settings.write
    dlmwrite([settings.op_dir expt '.' 'dawid_skene_equal' '.difficulty' difficulty '.init_id' num2str(init_id) '.predGndTruth'],...
        [(1:nQueryUrls)' predZ varZ], 'delimiter', '\t', 'precision', 10);
    
    save([settings.op_dir expt '.' 'dawid_skene_equal' '.difficulty' difficulty '.init_id' num2str(init_id) '.mat'] ...
        ,'predZ','varZ','alpha','pi_vec','lambda','cost_function_E','cost_function_M');
end
end

function op = compute_q_dawid_skene_equal(x,lambda,pi_vec,nLabels,alpha,beta_alpha,beta_beta,K)
op = sum(lambda,1) * log(pi_vec)';
op = op - sum(sum(lambda .* log(lambda))); % entropy term
Beta=gamma(beta_alpha).* gamma(beta_beta)./gamma(beta_alpha+beta_beta);
op = op + sum(((beta_alpha-1).*log(alpha)+ (beta_beta-1).*log(1-alpha))-log(Beta));
EPS=1e-15;
for i = 1:nLabels        % TODO: vectorize this computation
    m = x(i,1);
    n = x(i,2);
    j = x(i,3);
    s =alpha(n);
    s = max(s,EPS);
    s = min(s,1-EPS);
    tmp = log((1-s)/(K-1))*ones(1,K);
    tmp(j) = log(s);
    op = op + lambda(m,:) * tmp';  
end
assert(~isnan(op))
end
