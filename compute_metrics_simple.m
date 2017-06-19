function [mse, mae, corr_coef, zero_one_acc, err] = compute_metrics_simple(true_z, pred_z)

err = true_z - pred_z;
mse = mean( err.^2 );
mae = mean( abs(err) );

corr_mat = corrcoef(true_z, pred_z);
corr_coef = corr_mat(1,2);

round_true_z = round(true_z);
round_pred_z = round(pred_z);
zero_one_acc = sum(round_pred_z==round_true_z)/ length(round_pred_z);
