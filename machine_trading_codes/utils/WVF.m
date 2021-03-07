function [ myWVF ] = WVF( lo, cl, lookback )
%[ myWVF ] = WVF( lo, cl, lookback )
%   Williams Synthetic VIX (Williams VIX Fix)

hi22=smartMovingMax(cl, lookback);

myWVF=(hi22-lo)./hi22*100;


end

