function [predZ,predA] = dawid_skene(settings, x, nQueryUrls, nLabelers, nLabels, K, ...
    v, init_id, difficulty, expt)
% EM for Dawid-Skene model

assert(strcmp(difficulty,'off'));

%hyper parameter init
alpha = 1;  % alpha is Dirichlet concentration parameter --- each entry will be smoothed by alpha/K

% parameter initializations
match_empirical_stats = 1; % initialize randomly around the empirical stats
% match_empirical_stats = 0; % random initialization, performs much worse in my experiments

if match_empirical_stats
    pi_vec = hist(x(:,3), 1:K) + settings.EPS;
    %phi_mat = alpha / K *ones(nLabelers,K,K);
    phi_mat = rand(nLabelers,K,K);
    for i = 1:nLabels
        n = x(i,2);
        j = x(i,3);
        phi_mat(n,j,j) =  phi_mat(n,j,j) + 1; % assume every turker is correct
    end
else
    pi_vec = rand(1,K);
    phi_mat = rand(nLabelers,K,K);
end
phi_mat = normalize_phi_mat(phi_mat,nLabelers,K);
pi_vec = pi_vec / sum(pi_vec);

cost_function_E = -Inf*ones(settings.maxIter,1);
cost_function_M = -Inf*ones(settings.maxIter,1);

cost_function_old = -Inf;

if settings.compute_metrics
    true_ordinal_loglik = -Inf*ones(settings.maxIter,1);
    true_corr_coef = NaN*ones(settings.maxIter,1);
    true_mse = Inf*ones(settings.maxIter,1);
    true_zero_one_acc = Inf*ones(settings.maxIter,1);
    true_mae = Inf*ones(settings.maxIter,1);
    ind = sub2ind([nQueryUrls, K], (1:nQueryUrls)', settings.true_z);
end

for iter = 1:settings.maxIter
    
    % E-step
    log_lambda = ones(nQueryUrls,1)*log(pi_vec);
    for i = 1:nLabels
        m = x(i,1);
        n = x(i,2);
        j = x(i,3);
        log_lambda(m,:) = log_lambda(m,:) + log(phi_mat(n,:,j));
    end
    log_lambda = log_lambda - max(log_lambda,[],2)*ones(1,K);
    lambda = exp(log_lambda);
    lambda = lambda ./ (sum(lambda,2)*ones(1,K));
    
    cost_function_E(iter) = compute_q_dawid_skene(x,lambda,phi_mat,pi_vec,nLabels,alpha);
    if settings.verbose >= 2
        fprintf('iter = %4d, E-step, Q = %f\n',iter,cost_function_E(iter));
    end
    
    % M-step
    
    pi_vec = sum(lambda,1)/nQueryUrls;
    phi_mat = 0*phi_mat + alpha/K; % smoothing by alpha/K (NOT alpha)
    for i = 1:nLabels
        m = x(i,1);
        n = x(i,2);
        j = x(i,3);
        phi_mat(n,:,j) = phi_mat(n,:,j) + lambda(m,:);
    end
    phi_mat=max(phi_mat,settings.EPS);
    phi_mat = normalize_phi_mat(phi_mat,nLabelers,K);
    
%     predZ = lambda * v;
    if settings.compute_metrics
        [true_mse(iter), true_mae(iter), true_corr_coef(iter), true_zero_one_acc(iter)] = ...
            compute_metrics_simple(settings.true_z, predZ);
        true_ordinal_loglik(iter) = sum(log(lambda(ind)));
    end
    
    cost_function_M(iter) = compute_q_dawid_skene(x,lambda,phi_mat,pi_vec,nLabels,alpha);
    if settings.verbose >= 2
        fprintf('iter = %4d, M-step, Q = %f\n',iter,cost_function_M(iter));
    end
    
    assert((cost_function_M(iter)-cost_function_old) >= -settings.numeric_error)
    
    if (abs(cost_function_M(iter)-cost_function_old) < settings.thresh)
        if settings.verbose >= 2
            fprintf('Breaking out since del(cost function) < %f\n',settings.thresh);
            break;
        end
    end
    cost_function_old  = cost_function_M(iter);
    
end

if settings.compute_metrics
    fprintf('ordinal loglik = %.2f, mse = %.2f, mae = %.2f, corr = %.2f, zero_one_acc = %.2f, alpha = %.2f, match_stats = %d, init_id = %d\n',...
        true_ordinal_loglik(iter),true_mse(iter), true_mae(iter),...
        true_corr_coef(iter), true_zero_one_acc(iter), alpha, match_empirical_stats, init_id);
end
[~,G]=max(lambda');
predA=G';
predZ = lambda * v;
varZ = sum(lambda .* (ones(nQueryUrls,1)*v' - predZ*ones(1,K)).^2, 2);

if settings.write
    dlmwrite([settings.op_dir expt '.' 'dawid_skene' '.difficulty' difficulty '.init_id' num2str(init_id) '.predGndTruth'],...
        [(1:nQueryUrls)' predZ varZ], 'delimiter', '\t', 'precision', 10);
    
    save([settings.op_dir expt '.' 'dawid_skene' '.difficulty' difficulty '.init_id' num2str(init_id) '.mat'] ...
        ,'predZ','varZ','phi_mat','pi_vec','lambda','cost_function_E','cost_function_M');
end
end



function op = compute_q_dawid_skene(x,lambda,phi_mat,pi_vec,nLabels,alpha)
EPS = 1e-16;
phi_mat=max(phi_mat,EPS);
% alpha=max(alpha,EPS);
op = sum(lambda,1) * log(pi_vec)';
op = op - sum(sum(lambda .* log(lambda))); % entropy term
for i = 1:nLabels
    m = x(i,1);
    n = x(i,2);
    j = x(i,3);
    op = op + lambda(m,:) * log(phi_mat(n,:,j))';
end
[N,K,~] = size(phi_mat);
op = op + (alpha/K - 1)*sum(sum(sum(log(phi_mat)))) ...
    + N*K*( gammaln(alpha) - K*gammaln(alpha/K) ); % alpha is Dirichlet concentration parameter
assert(~isnan(op))
end
