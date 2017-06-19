clear all; close all; clc;
x = dlmread('input\daan.txt','\t',1,0);

L=size(x(1,:),2);
H =size(x(:,1));
Z=ones(H,L);
for i=1:H
   
    if x(i,1)==x(i,2)
        if x(i,2)~=x(i,3)
        Z(i,:)=x(i,:);
        end
    end
     
 end 
%  accuacy=t/size(true_z,1);
s4 = xlswrite('input\daan.xls', Z); 