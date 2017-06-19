clear all; close all; clc;
tag_template = 'dog1';
tag = tag_template;
expt = tag;
settings = 'input/';
x = dlmread([settings expt '.response.txt'],'\t',1,0);
N=max(x(:,1));
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem3=tem(1:3,:);
   elseif size(tem,1)>=3
    tem1=tem(1:3,:);
    latem3=[latem3;tem1];
   elseif size(tem,1)<3
     latem3=[latem3;tem];  
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem4=tem(1:4,:);
   elseif size(tem,1)>=4
    tem1=tem(1:4,:);
    latem4=[latem4;tem1];
   elseif size(tem,1)<4
     latem4=[latem4;tem];  
   end
end

for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem5=tem;
   elseif size(tem,1)>=5
    tem1=tem(1:5,:);
    latem5=[latem5;tem1];
   elseif size(tem,1)<5
     latem5=[latem5;tem];  
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem6=tem;
   elseif size(tem,1)>=6
    tem1=tem(1:6,:);
    latem6=[latem6;tem1];
   elseif size(tem,1)<6
     latem6=[latem6;tem];  
   end
end

for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem7=tem;
   elseif size(tem,1)>=7
    tem1=tem(1:7,:);
    latem7=[latem7;tem1];
   elseif size(tem,1)<7
     latem7=[latem7;tem];  
   end
end
for i=1:N
   tem=x(x(:,1)==i,:);
   if tem(1,1)==1
    latem8=tem;
   elseif size(tem,1)>=8
    tem1=tem(1:8,:);
    latem8=[latem8;tem1];
   elseif size(tem,1)<8
     latem8=[latem8;tem];  
   end
end


s1 = xlswrite('input\result3.xls', latem3);
s2 = xlswrite('input\result4.xls', latem4);
s3 = xlswrite('input\result5.xls', latem5);
s4 = xlswrite('input\result6.xls', latem6);
s5 = xlswrite('input\result7.xls', latem7);
s5 = xlswrite('input\result8.xls', latem8);
