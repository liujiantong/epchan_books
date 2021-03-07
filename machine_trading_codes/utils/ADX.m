function [myadx ] = ADX( hi, lo, cl, lookback )
%[myadx ] = ADX( hi, lo, cl, lookback )

dmU=zeros(size(cl));
dmD=dmU;

upMove=hi-backshift(1, hi);
dnMove=backshift(1, lo)-lo;

dmU(upMove > dnMove & upMove > 0)=upMove(upMove > dnMove & upMove > 0);
dmD(dnMove > upMove & dnMove > 0)=dnMove(dnMove > upMove & dnMove > 0);

diU=100*smartExpMovingAvg(dmU, lookback)./atr(lookback, hi, lo, cl);
diD=100*smartExpMovingAvg(dmD, lookback)./atr(lookback, hi, lo, cl);

myadx=100*smartExpMovingAvg(abs((diU-diD)./(diU+diD)), lookback);


end

