function atr=atr(days,  hi, lo, cl)
%  atr=atr(days,  hi, lo, cl)=Average True Range of the last days of data.

dayrange=NaN(size(hi));
for s=1:size(hi, 2)
    dayrange(:, s)=max([hi(:, s)-lo(:, s) abs(hi(:, s)-backshift(1, cl(:, s))) abs(backshift(1, cl(:, s))-lo(:, s))], [], 2);
end

atr=smartMovingAvg(dayrange, days);
end