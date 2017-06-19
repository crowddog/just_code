clear all; close all; clc;

startup()

WRITE = 1;
nQueries = 20;
tag_template = 'test1';
K = 4;
L=0.90;
T=5;
alpha_mu = 0;   % prior over (alpha_n)
alpha_sigma2 = 1;
% log_alpha_mu = 1;   % prior over (alpha_n)
% log_alpha_sigma2 = 1;
log_beta_mu = 0;    % prior over log(beta_m)
log_beta_sigma2 = 1;

difficulty = 'off';

settings = struct();
settings.thresh = 0.01;
settings.maxIter = 1e3;
settings.EPS = 1e-15;
settings.numeric_error = 0;
settings.write = 0; %  write results if 1
settings.verbose = 2;
settings.op_dir = 'results/';
settings.ip_dir = 'input/';
settings.compute_metrics = 0;

v = (1:K)';
for init_id = 1:1  
    tag = tag_template;
    expt = tag;
    for numAvgRatingsPerQueryUrl = T %1:6
        
        nQueryUrls = nQueries*10;
        nLabels = numAvgRatingsPerQueryUrl * nQueryUrls;
        nLabelers = round(nLabels/3);
        r=randcontextm(nQueryUrls,K);
        
        x = zeros(nLabels,4);
        z = ceil(rand(nQueryUrls,1)*K+eps);
        x(:,1) = ceil(rand(nLabels,1)*nQueryUrls+eps);
        tmp = randperm(nLabels);
        x(tmp(1:nQueryUrls),1) = (1:nQueryUrls)'; % to ensure every qu occurs atleast once
        
        x(:,2) = ceil(rand(nLabels,1)*nLabelers+eps);
        qu2q = ceil(rand(nQueryUrls,1)*nQueries+eps);
        x(:,4) = qu2q(x(:,1)); % 4th column contains queryId
        
         alpha=ones(nLabelers,1).*L;

         for i = 1:nLabels
            m = x(i,1);
            n = x(i,2);
            thet = compute_thet(r,m);
            s = alpha(n);
            p = (ones(K,1) * (1 - s)).* (thet(z(m),:)');
            p(z(m)) = s;
            x(i,3) = find(sample_hist(p, 1));
         end  
        
        [predZ,predA] = dawid_skene_context(settings, x, nQueryUrls, nLabelers, nLabels, K, v, init_id, difficulty, expt,r);
        [mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(z, predZ);
        fprintf('mse = %.3f, mae = %.3f, corr = %.3f, zero_one_acc = %.3f\n', mse, mae, corr_coef, zero_one_acc);
        
         if WRITE
             dlmwrite([settings.ip_dir expt '.gold.txt'], z, 'delimiter', '\t', 'precision', 10);
             dlmwrite([settings.ip_dir expt '.response.txt'], x, 'delimiter', '\t', 'precision', 10, 'roffset', 1);
             dlmwrite([settings.ip_dir expt '.context.txt'], r, 'delimiter', '\t', 'precision', 10, 'roffset', 1);
        end
    end
end
