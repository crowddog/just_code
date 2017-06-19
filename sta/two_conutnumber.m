clear all; close all; clc;
x = dlmread('\input\dog.response.txt','\t',1,0);
N=max(x(:,1));
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem3=tem(1:3,:);
   elseif size(tem,1)~=1
    tem1=tem(1:3,:);
    latem3=[latem3;tem1];
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem4=tem(1:4,:);
   elseif size(tem,1)~=1
    tem1=tem(1:4,:);
    latem4=[latem4;tem1];
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem5=tem(1:5,:);
   elseif size(tem,1)~=1
    tem1=tem(1:5,:);
    latem5=[latem5;tem1];
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem6=tem(1:6,:);
   elseif size(tem,1)~=1
    tem1=tem(1:6,:);
    latem6=[latem6;tem1];
   end
end

for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem7=tem(1:7,:);
   elseif size(tem,1)~=1
    tem1=tem(1:7,:);
    latem7=[latem7;tem1];
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem8=tem(1:8,:);
   elseif size(tem,1)~=1
    tem1=tem(1:8,:);
    latem8=[latem8;tem1];
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem9=tem(1:9,:);
   elseif size(tem,1)~=1
    tem1=tem(1:9,:);
    latem9=[latem9;tem1];
   end
end

for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem10=tem(1:10,:);
   elseif size(tem,1)~=1
    tem1=tem(1:10,:);
    latem10=[latem10;tem1];
   end
end

for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem11=tem(1:11,:);
   elseif size(tem,1)~=1
    tem1=tem(1:11,:);
    latem11=[latem11;tem1];
   end
end

% s1 = xlswrite('input\result3.xls', latem3);
% s2 = xlswrite('input\result4.xls', latem4);
% s3 = xlswrite('input\result5.xls', latem5);
% s4 = xlswrite('input\result6.xls', latem6);
% s5 = xlswrite('input\result7.xls', latem7);
s6 = xlswrite('input\result8.xls', latem8);
% s7 = xlswrite('input\result9.xls', latem9);
% s8 = xlswrite('input\result10.xls', latem10);
% s9 = xlswrite('input\result11.xls', latem11);