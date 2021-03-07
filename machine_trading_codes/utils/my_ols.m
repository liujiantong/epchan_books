function results=my_ols(y,x,w)
% PURPOSE: least-squares regression 
%---------------------------------------------------
% USAGE: results = ols(y,x)
% where: y = dependent variable vector    (nobs x 1)
%        x = independent variables matrix (nobs x nvar), a column of ones should be included
%---------------------------------------------------
% RETURNS: a structure
%        results.meth  = 'ols'
%        results.beta  = bhat     (nvar x 1)
%        results.tstat = t-stats  (nvar x 1)
%        results.yhat  = yhat     (nobs x 1)
%        results.resid = residuals (nobs x 1)
%        results.sige  = e'*e/(n-k)   scalar
%        results.rsqr  = rsquared     scalar
%        results.rbar  = rbar-squared scalar
%        results.dw    = Durbin-Watson Statistic
%        results.nobs  = nobs
%        results.nvar  = nvars
%        results.y     = y data vector (nobs x 1)
%        results.bint  = (nvar x2 ) vector with 95% confidence intervals on beta

if (nargin < 2); error('Wrong # of arguments to ols'); 
else
 [nobs nvar] = size(x); [nobs2 junk] = size(y);
 if (nobs ~= nobs2); error('x and y must have same # obs in ols'); 
 end;
end;

if (nargin == 3)
    assert(size(w, 1)==size(y, 1) & size(w, 2)==1 & all(w>=0));
    %     w=diag(w);
end

results.meth = 'ols';
results.y = y;
results.nobs = nobs;
results.nvar = nvar;

if (nargin == 2)
    % L=chol(x'*w*x);
    [q r] = qr(x,0);
    xpxi = (r'*r)\eye(nvar);
else
    %         xpxi = inv(x'*w*x);
    
    %     L=chol(x'*w*x);
    %     [q r] = qr(L,0);
    %     xpxi = (r'*r)\eye(nvar);
    
    xw=repmat(sqrt(w), [1 size(x, 2)]).*x;
    [q r] = qr(xw,0);
    xpxi = (r'*r)\eye(nvar);
end

if (nargin > 2)
    yw=repmat(sqrt(w), [1 size(y, 2)]).*y;
    results.beta = xpxi*(xw'*yw);
else
    results.beta = xpxi*(x'*y);
end

if (0)
    results.yhat = x*results.beta;
    results.resid = y - results.yhat;
    sigu = results.resid'*results.resid;
    results.sige = sigu/(nobs-nvar);
    tmp = (results.sige)*(diag(xpxi));
    sigb=sqrt(tmp);
    
    results.mse = sigu/nobs;
end