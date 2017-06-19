clear all; close all; clc;

tag_template = 'test1';

[z(:,1), predZ(:,1)]=test_my_data_context_glad(tag_template);
[z(:,2), predZ(:,2)]=test_my_data_dawid_skene(tag_template);
[z(:,3), predZ(:,3)]=test_my_data_dawid_skenee_context(tag_template);
[z(:,4), predZ(:,4)]=test_my_data_dawid_skenee_qual(tag_template);
[z(:,5), predZ(:,5)]=test_my_data_glad(tag_template);
[z(:,6), predZ(:,6)]=test_my_data_MajorityVote(tag_template);
for i=1:6
[mse, mae, corr_coef, accacy(i), err] = compute_metrics_simple(z(:,i), predZ(:,i));
end
dlmwrite([tag_template '.accacy.txt'], accacy, 'delimiter', '\t', 'precision', 10, 'roffset', 1);
