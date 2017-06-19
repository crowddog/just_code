function accuacy = compute_accuracy(true_z, pred_z)
t=0;
for i=1:size(true_z,1)
    if true_z(i)==pred_z(i);
        t=t+1;
    end
end 
accuacy=t/size(true_z,1);
end
