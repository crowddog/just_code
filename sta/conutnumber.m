clear all; close all; clc;
x = dlmread('\input\dog.response.txt','\t',1,0);
N=max(x(:,1));
m1=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=1
    tem2=unique(tem(1,:),'rows');
   elseif size(tem,1)<1
    tem2=unique(tem,'rows');
   end
    m1(i,1)=i;
    m1(i,2)=size(tem2,1);
end

m2=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=2
    tem2=unique(tem([1,2],:),'rows');
   elseif size(tem,1)<2
    tem2=unique(tem,'rows');
   end
    m2(i,1)=i;
    m2(i,2)=size(tem2,1);
end

m3=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=3
    tem2=unique(tem([1,2,3],:),'rows');
   elseif size(tem,1)<3
    tem2=unique(tem,'rows');
   end
    m3(i,1)=i;
    m3(i,2)=size(tem2,1);
end


m4=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=4
    tem2=unique(tem([1,2,3,4],:),'rows');
   elseif size(tem,1)<4
    tem2=unique(tem,'rows');
   end
    m4(i,1)=i;
    m4(i,2)=size(tem2,1);
end

m5=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=5
    tem2=unique(tem([1,2,3,4,5],:),'rows');
   elseif size(tem,1)<5
    tem2=unique(tem,'rows');
   end
    m5(i,1)=i;
    m5(i,2)=size(tem2,1);
end

m6=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=6
    tem2=unique(tem([1,2,3,4,5,6],:),'rows');
   elseif size(tem,1)<6
    tem2=unique(tem,'rows');
   end
    m6(i,1)=i;
    m6(i,2)=size(tem2,1);
end

m7=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=7
    tem2=unique(tem([1,2,3,4,5,6,7],:),'rows');
   elseif size(tem,1)<7
    tem2=unique(tem,'rows');
   end
    m7(i,1)=i;
    m7(i,2)=size(tem2,1);
end

m8=zeros(N,2);
for i=1:N
   tem=x(x(:,1)==i,[1,3]);
   if size(tem,1)>=8
    tem2=unique(tem([1,2,3,4,5,6,7,8],:),'rows');
   elseif size(tem,1)<8
    tem2=unique(tem,'rows');
   end
    m8(i,1)=i;
    m8(i,2)=size(tem2,1);
end
%s1 = xlswrite('input\stadisnumberfre1.xls', m1);
%s2 = xlswrite('input\stadisnumberfre2.xls', m2);
%s3 = xlswrite('input\stadisnumberfre3.xls', m3);
%s4 = xlswrite('input\stadisnumberfre4.xls', m4);
%s5 = xlswrite('input\stadisnumberfre5.xls', m5);
%s6 = xlswrite('input\stadisnumberfre6.xls', m6);
%s7 = xlswrite('input\stadisnumberfre7.xls', m7);
s8 = xlswrite('input\stadisnumberfre8.xls', m8);


% tag_template = 'dog1';
% settings = 'input/';
% tag = tag_template;
% expt = tag;
% [x,z,nTask,nWorker,nLabels] = load_data(expt, settings);
% sta=zeros(nLabels,4);
% mMax = max(x(:,3));
% t1=zeros(nLabels,2);
% t=1;
% for i=1:nTask
%    tem=x(x(:,1)==i,3);
%    nMax = max(tem(:,1));
%    for j=1:nMax
%        tems=tem(tem(:,1)==j,1);
%        n=size(tems,1);
%        if n~=0
%          sta(t,1)=i;
%          sta(t,2)=j;
%          sta(t,3)=n;
%          if z(i,1)==j
%            sta(t,4)=j;  
%          end
%          t=t+1;
%        end
%    end 
% end
% t1=sta(sta(:,4)~=0,:);
% t2=sta(sta(:,3)~=0,:);
% s1 = xlswrite('input\stadis1.xls', t1); 
% s2 = xlswrite('input\stadis2.xls', t2); 