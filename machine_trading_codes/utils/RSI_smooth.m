function myRsi = RSI_smooth( cl, x )
%myRsi = RSI_smooth( cl, x )
% smoothed RSI from Joe Duffy


myRsi=100-100./(1+RS_smooth(cl, x));
end

