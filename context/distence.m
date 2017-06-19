function op = distence(x,y,c)
T=(((x(y,2:7)-x(c,2:7))./2).*[0.5,0.5,0.7,0.9,1.0,1.0]).^2;
Trans=sum(T,2)./24;
tp1=sqrt(Trans);
op = 1./ (1+(tp1));