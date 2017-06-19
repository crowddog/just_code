function [x,z,nQueryUrls,nLabelers,nLabels, K, v] = load_data(expt, settings)
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

x = dlmread([settings.ip_dir expt '.response.txt'],'\t',1,0);
z = dlmread([settings.ip_dir expt '.gold.txt'],'\t',0,0);
nQueryUrls = max(x(:,1));
nLabelers = max(x(:,2));
nLabels = size(x,1);
ratings_sort = sort(unique(x(:,3)));
v = (min(ratings_sort):max(ratings_sort))';  % gaps are OK, eg. 1,3,4,5
K = length(v);
 