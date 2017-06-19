% function[z, predA]=test_my_data_context_glad(tag_template)

clear all; close all; clc;

startup()
difficulty = 'queryUrl';
tag_template = 'dog1';
settings = struct();
settings.thresh = 0.1;
settings.maxIter = 1e3;
settings.EPS = 1e-15;
settings.numeric_error = 0;
settings.write = 0; %  write results if 1
settings.verbose = 2;
settings.op_dir = 'results/';
settings.ip_dir = 'input/';
settings.compute_metrics = 0;
tag = tag_template;
expt = tag;
[x,z,nQueryUrls,nLabelers,nLabels, K, v] = load_data(expt, settings);
r = load_context(settings,expt);
init_id = 1; 
[predZ,predA] = context_glad(settings, x, nQueryUrls, nLabelers, nLabels, K, v, init_id, difficulty, expt,r);

[mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(z, predZ);
fprintf('mse = %.3f, mae = %.3f, corr = %.3f, zero_one_acc = %.3f\n', mse, mae, corr_coef, zero_one_acc);
% [mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(z, predA);
% fprintf('mse = %.3f, mae = %.3f, corr = %.3f, zero_one_acc = %.3f\n', mse, mae, corr_coef, zero_one_acc);
% end