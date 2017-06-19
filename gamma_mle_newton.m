function [shape, rate] = gamma_mle_newton(logxbar,xbar,n,shape0,rate0)
% computes MLE for gamma distribution

% wrapper around Tom Minka's function using generalized newton method
[a, b] = gamma_fit(xbar, log(xbar)-logxbar);

loglik_old = compute_gamma_loglik(logxbar,xbar,n,shape0,rate0);
loglik_new = compute_gamma_loglik(logxbar,xbar,n,a,1./b);

if ( isnan(a) || isnan(b) || (imag(a)~=0) || (imag(b)~=0) || isnan(loglik_old) || isinf(loglik_old) )
    warning('NaN/Complex value returned by gamma_fit in gamma_mle_newton (see below); returning old values');
    logxbar;
    xbar;
    loglik_old;
    a;
    b;
    shape = shape0;
    rate = rate0;
else
    shape = a;
    rate = 1 ./ b;
end

if ~(isnan(loglik_old) || isinf(loglik_old))
    assert(loglik_new >= loglik_old);
end


    function op = compute_gamma_loglik(logxbar,xbar,n,shape,rate)
        op = n*(shape*log(rate)-gammaln(shape) + (shape-1)*logxbar - rate*xbar);
    end
end
