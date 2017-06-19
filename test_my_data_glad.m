clear all; close all; clc;
% function[z, predZ]=test_my_data_glad(tag_template)
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
init_id = 1; 
[predZ,predA] = glad(settings, x, nQueryUrls, nLabelers, nLabels, K, v, init_id, difficulty, expt);
[mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(z, predA);
fprintf('mse = %.3f, mae = %.3f, corr = %.3f, zero_one_acc = %.3f\n', mse, mae, corr_coef, zero_one_acc);
% end
