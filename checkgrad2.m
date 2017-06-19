function d = checkgrad2(f, X, e)
%
% modified version of Carl Rasmussen's checkgrad.m. List of changes:
% --- optional arguments P1, P2, etc. are not supported
% --- checkgrad2 takes in anonymous function as input (NOT function name as checkgrad)
%
% checkgrad2 checks the derivatives in a function, by comparing them to finite
% differences approximations. The partial derivatives and the approximation
% are printed and the norm of the diffrence divided by the norm of the sum is
% returned as an indication of accuracy.
%
% usage: checkgrad2(f, X, e)
%
% where X is the argument and e is the small perturbation used for the finite
% differences. The function f should be of the type 
%
% [fX, dfX] = f(X)
%
% where fX is the function value and dfX is a vector of partial derivatives.
%

[y dy] = f(X);

dh = zeros(length(X),1) ;
for j = 1:length(X)
  dx = zeros(length(X),1);
  dx(j) = dx(j) + e;                               % perturb a single dimension
  [y2 dy2] = f(X+dx);
  dx = -dx ;
  [y1 dy1] = f(X+dx);
  dh(j) = (y2 - y1)/(2*e);
end

disp([dy dh])                                          % print the two vectors
d = norm(dh-dy)/norm(dh+dy);       % return norm of diff divided by norm of sum
