function tmp=randcontextm(e,k)
%generated the context m
for i=1:k
L(i)=i;    
end 
Q=ones(k,1);
A=round(rand(k,k)*1000)/1000;
B=tril(A,-1)+triu(A', 0);
for j=1:k
B(j,j)=max(B(j,:))+0.01;
end
tmp=[Q L' B];
for i=2:e
 A=round(rand(k,k)*1000)/1000;
 B=tril(A,-1)+triu(A',-1);
  for j=1:k
   B(j,j)=max(B(j,:))+0.01;
  end
  tmp1=[i*Q L' B];
  tmp=[tmp;tmp1];
end 
end