clear all; close all; clc;

startup()
difficulty = 'queryUrl';
tag_template = 'dog1';
settings = struct();
settings.thresh = 0.01;
settings.maxIter = 1e3;
settings.EPS = 1e-15;
settings.numeric_error = 0;
settings.write = 1; %  write results if 1
settings.verbose = 2;
settings.op_dir = 'results/';
settings.ip_dir = 'input/';
settings.compute_metrics = 0;
tag = tag_template;
expt = tag;
[x,z,nQueryUrls,nLabelers,nLabels, K, v] = load_data(expt, settings);
init_id = 1;
predA=ones(nQueryUrls,2);
for i=1:nQueryUrls
 tmp=x((x(:,1)==i),:);
 e=mode(tmp(:,3));
 predA(i,:)=[i,e];
end
[mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(z, predA(:,2));
fprintf('mse = %.3f, mae = %.3f, corr = %.3f, zero_one_acc = %.3f\n', mse, mae, corr_coef, zero_one_acc);
% accuacy = compute_accuracy(z, predA(:,2)); 
%  fprintf('accuacy = %.3f\n', accuacy); 