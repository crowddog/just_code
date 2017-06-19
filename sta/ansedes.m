clear all; close all; clc;
tag_template = 'dogt';
settings = 'input/';
tag = tag_template;
expt = tag;
[x,z,nTask,nWorker,nLabels] = load_data(expt, settings);
sta=zeros(nLabels,4);
mMax = max(x(:,3));
t1=zeros(nLabels,2);
t=1;
for i=1:nTask
   tem=x(x(:,1)==i,3);
   nMax = max(tem(:,1));
   for j=1:nMax
       tems=tem(tem(:,1)==j,1);
       n=size(tems,1);
       if n~=0
         sta(t,1)=i;
         sta(t,2)=j;
         sta(t,3)=n;
         if z(i,1)==j
           sta(t,4)=j;  
         end
         t=t+1;
       end
   end 
end
t1=sta(sta(:,4)~=0,:);
t2=sta(sta(:,3)~=0,:);
s1 = xlswrite('input\stadis1.xls', t1); 
s2 = xlswrite('input\tworound.xls', t2); 