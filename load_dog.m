clear all; close all; clc;
% loads dataset and creates nQueryUrls, nLabelers, nLabels, K
% 
% x will be a nLabels x 4 matrix; where each row contains the following:
% (instanceId, labelerId, rating, categoryId)
% NOTE: x could also be a nLabels x 3 matrix; the last column is acccessed 
% only by ordmultinomial_mixture when difficulty == 'query'
%
% x(:,3) always contains values in 1:K (and NOT v_1, v_2, ..., v_K)
% v = 1:K in my experiments
% set v to [v_1, v_2, ..., v_K] here if you wish to use a different value

x = dlmread('F:\context_crowd\input\dog.response.txt','\t',0,0);
z = dlmread('F:\context_crowd\input\dog.gold.txt','\t',0,0);
nQueryUrls = max(x(:,1));
nLabelers = max(x(:,2));
nLabels = size(x,1);
for i=1:nLabels
    x(i,3)=x(i,3)+1;
end
for i=1:nQueryUrls
    z(i,1)=z(i,1)+1;
end
r=[0.7102,0.2735,0.103,0.0058;
    0.3199,0.6671,0.0113,0.0018;
    0.0119,0.0055,0.6935,0.2891;
    0.0120,0.0038,0.2677,0.7165];
% r=[0.4571,0.3199,0.103,0.12;
%     0.3199,0.4291,0.113,0.138;
%     0.103,0.113,0.4311,0.3529;
%     0.12,0.138,0.3529,0.3891];
for i=1:4
L(i)=i;    
end
Q=ones(4,1);
tmp=[Q L' r];
for i=2:nQueryUrls
  tmp1=[i*Q L' r];
  tmp=[tmp;tmp1];
end 
dlmwrite('F:/context_crowd/input/dog.context.txt', tmp, 'delimiter', '\t', 'precision', 10, 'roffset', 1);
