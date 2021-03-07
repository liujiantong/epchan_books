function [ cumulativeNormalDist ] = cumulNormal(x)
%  [ cumulativeNormalDist ] = cumulNormal(x)

a1=0.4361836;
a2=-0.1201676;
a3=0.937298;
k=1/(1+0.33267*abs(x));

cumulativeNormalDist=1-normalDist(abs(x))*(a1*k+a2*k^2+a3*k^3);

if (x < 0)
    cumulativeNormalDist=1-cumulativeNormalDist;
end

end

