function [predA,predZ] = context_glad(settings, x, nQueryUrls, nLabelers, nLabels, K, ...
    v, init_id, difficulty, expt,r)
% EM for GLAD model
% M-step uses minimize.m for conjugate gradient optimization
alpha_mu = 1+0.001;   % gaussian prior over alpha_n
alpha_sigma2 = 1+0.001;
log_beta_mu = 1+0.001;    % gaussian prior over log(beta_m)
log_beta_sigma2 = 1+0.001;
DEBUG = 0;
MAXITER_MINIMIZE = 100;   % for minimize.m
r=max(r,settings.EPS);
% not sure which is a reasonable range for initialization?
alpha = sqrt(alpha_sigma2)*randn(nLabelers,1) + alpha_mu;
% alpha = 1;
log_beta = sqrt(log_beta_sigma2)*randn(nQueryUrls,1) + log_beta_mu;
beta = exp(log_beta);
% pi_vec = rand(1,K);
pi_vec = hist(x(:,3), 1:K) + settings.EPS;
pi_vec = pi_vec / sum(pi_vec);
ii = sub2ind([nQueryUrls,K],x(:,1),x(:,3));
% thet = compute_thet(r,1);
assert(strcmp(difficulty,'queryUrl'));

cost_function_E = -Inf*ones(settings.maxIter,1);
cost_function_M = -Inf*ones(settings.maxIter,1);
cost_function_old = -inf;
for iter = 1:settings.maxIter
    % E-step
    log_lambda = ones(nQueryUrls,1)*log(pi_vec);
    for i = 1:nLabels
        m = x(i,1);
        n = x(i,2);
        j = x(i,3);
        thet = compute_thet(r,m);
        s = sigmoid(alpha(n)*beta(m));
        s = max(s,settings.EPS);
        s = min(s,1-settings.EPS);
%       tmp = log(((1-s)/(K-1)).*thet(:,j));
        tmp = log((1-s).*thet(:,j));
        tmp(j) = log(s);
%         if m==198
%           disp(tmp);  
%         end    
        log_lambda(m,:) = log_lambda(m,:) + tmp';
    end
    
    log_lambda = log_lambda - max(log_lambda,[],2)*ones(1,K);
    lambda = exp(log_lambda);
    lambda = lambda ./ (sum(lambda,2)*ones(1,K));
    
    cost_function_E(iter) = ...
        compute_q_glad_context(x,lambda,pi_vec,alpha,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r);
    fprintf('iter = %4d, E-step, Q = %f\n',iter,cost_function_E(iter));
    
    
    % M-step
    pi_vec = sum(lambda,1)/nQueryUrls;
    
    % alpha update
    negQ_gradnegQ_alpha = @(alpha) deal(-compute_q_glad_context(x,lambda,pi_vec,alpha,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r), ...
        -compute_grad_alpha_context(x, alpha, beta, alpha_mu, alpha_sigma2, lambda, ii));
    if DEBUG
        checkgrad2(negQ_gradnegQ_alpha, alpha, 1e-5)
        pause
    end
    alpha_new =  minimize(alpha, negQ_gradnegQ_alpha, MAXITER_MINIMIZE);
    if DEBUG
        if (compute_q_glad_context(x,lambda,pi_vec,alpha_new,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r) < ...
                cost_function_E(iter) )
            fprintf('iter = %4d, skipping alpha update (decreases log likelihood)\n', iter);
        else
            alpha = alpha_new;
        end
    else
        alpha = alpha_new;
    end
    
    % beta update
    negQ_gradnegQ_log_beta = @(log_beta) deal(-compute_q_glad_context(x,lambda,pi_vec,alpha,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r), ...
        -compute_grad_log_beta_context(x, alpha, log_beta, alpha_mu, alpha_sigma2, lambda, ii));
    if DEBUG
        checkgrad2(negQ_gradnegQ_log_beta, log_beta, 1e-5)
        pause
    end
    log_beta_new =  minimize(log_beta, negQ_gradnegQ_log_beta, MAXITER_MINIMIZE);
    beta_new = exp(log_beta_new);
    if DEBUG
        if (compute_q_glad_context(x,lambda,pi_vec,alpha,...
                log_beta_new,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r) > ...
                cost_function_E(iter) )
            log_beta = log_beta_new;
            beta = beta_new;
        else
            fprintf('iter = %4d, M-step, skipping beta update (decreases log likelihood)\n', iter);
        end
    else
        log_beta = log_beta_new;
        beta = beta_new;
    end
    
    cost_function_M(iter) = ...
        compute_q_glad_context(x,lambda,pi_vec,alpha,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r);
    fprintf('iter = %4d, M-step, Q = %f\n',iter,cost_function_M(iter));
    
    % check that E- and M-steps do not decrease loglikelihood (modulo numeric errors)
    assert((cost_function_E(iter)-cost_function_old) >= -settings.numeric_error)
    assert((cost_function_M(iter)-cost_function_E(iter)) >= -settings.numeric_error)
    
    if (abs(cost_function_M(iter)-cost_function_old) < settings.thresh)
        fprintf('Breaking out since del(cost function) < %f\n',settings.thresh);
        break;
    end
    cost_function_old  = cost_function_M(iter);
end
[~,G]=max(lambda');
predZ = lambda * v;
predA=G';
varZ = sum(lambda .* (ones(nQueryUrls,1)*v' - predZ*ones(1,K)).^2,2);

if settings.write
    dlmwrite([settings.op_dir expt '.' 'glad' '.difficulty' difficulty '.init_id' num2str(init_id) '.predGndTruth'], ...
        [(1:nQueryUrls)' predZ varZ], 'delimiter', '\t', 'precision', 10);
    
    save([settings.op_dir expt '.' 'glad' '.difficulty' difficulty '.init_id' num2str(init_id) '.mat'], ...
        'predZ','varZ','alpha','beta','lambda','cost_function_E','cost_function_M');
end
end

function op = compute_grad_alpha_context(x, alpha, beta, alpha_mu, alpha_sigma2, lambda, ii)
ss =  sigmoid(alpha(x(:,2)) .* beta(x(:,1)));
tmp = lambda(ii) .* beta(x(:,1)) - ss .* beta(x(:,1));
op = accumarray(x(:,2),tmp) - (alpha-alpha_mu)/(alpha_sigma2);
end

function op = compute_grad_log_beta_context(x, alpha, log_beta, log_beta_mu, log_beta_sigma2, lambda, ii)
beta_tmp = exp(log_beta);
ss =  sigmoid(alpha(x(:,2)).*beta_tmp(x(:,1)));
tmp = lambda(ii) .* alpha(x(:,2)) - ss .* alpha(x(:,2));
% op = accumarray(x(:,1),tmp) .* beta_tmp - (log_beta-log_beta_mu) / (log_beta_sigma2);
op = accumarray(x(:,1),tmp) - (log_beta-log_beta_mu) / (log_beta_sigma2);
end


function op = compute_q_glad_context(x,lambda,pi_vec,alpha,log_beta,nLabels,K,alpha_mu,alpha_sigma2,log_beta_mu,log_beta_sigma2,r)
EPS = 1e-16;
op = sum(lambda,1) * log(pi_vec)';
op = op - sum(sum(lambda .* log(lambda + EPS))); % entropy term
op = op - 0.5*( length(alpha)*log(alpha_sigma2) + length(log_beta)*log(log_beta_sigma2) );
op = op - 0.5*( (1/log_beta_sigma2)*sum((log_beta-log_beta_mu).^2) + (1/alpha_sigma2)*sum((alpha-alpha_mu).^2) );
beta = exp(log_beta);
ss = sigmoid(alpha(x(:,2)).*beta(x(:,1)));
ss = max(ss,EPS);
ss = min(ss,1-EPS);
% disp(op);
% disp(lambda);
for i = 1:nLabels        % TODO: vectorize this computation
    m = x(i,1);
    n = x(i,2);
    j = x(i,3);
    s = ss(i);
    thet = compute_thet(r,m);
%     disp(thet);
%   tmp = log(((1-s)/(K-1)).*thet(:,j));
    tmp = log((1-s).*thet(:,j));
    tmp(j) = log(s);
    op = op + sum(lambda(m,:) .* tmp');
%     disp(m);
%     disp(op);
end
% thet = compute_thet(r,188);
% fprintf('op = %f\n',op);
assert(~isnan(op));
assert(imag(op)==0);
end
