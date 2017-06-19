clear all; close all; clc;
[x,z] = load_data();
L=size(z(1,:),2);
H = size(z(:,1),1);
rho=ones(H*(L-1),L+1);
for i=1:H
    for r=1:L-1
      rho((i-1)*(L-1)+r,1)=i+200;
      rho((i-1)*(L-1)+r,2)=r;
      for j=2:L
         p1=z(i,r+1);
         p2=z(i,j);
         rho((i-1)*(L-1)+r,j+1)=distence(x,p1,p2);
          if rho((i-1)*(L-1)+r,j+1)==1
               rho((i-1)*(L-1)+r,j+1)=1-0.01; 
          end
      end
    end
 end 
%  accuacy=t/size(true_z,1);
dlmwrite('input\context1.txt', rho, 'delimiter', '\t', 'precision', '%.3f', 'roffset', 1);
s4 = xlswrite('input\context1.xls', rho); 