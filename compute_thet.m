 function thet =compute_thet(r,i)
%function thet =compute_thet()
%compute the vector thet with two context models
 %r=randcontextm(5,3);
%  i=4;
% EPS=1e-15;
% disp(i);
 tmp1=r((r(:,1)==i),3:end);
 t=size(tmp1,1);
 thet=zeros(t,t);
  for j=1:t
      thet(j,:)=tmp1(j,:)./(sum(tmp1(j,:),2)-tmp1(j,j));
 %     thet(jj,:)=tmp1(jj,3:t+2)./(sum(tmp1(jj,3:t+2),2));
      thet(j,j)=tmp1(j,j)/sum(tmp1(j,:),2);
  end
%   for l=1:t
%       for w=1:t
%         thet(l,w)= max(thet(l,w),EPS);
%         thet(l,w)= min(thet(l,w),EPS);
%       end
%   end
end