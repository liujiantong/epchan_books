function [ myCCI ] = CCI(  hi, lo, cl )
%[ myCCI ] = CCI(  hi, lo, cl )
%   CCI=(Typical_Price-Mean(Typical_Prices))/(0.015*MeanAbsDev(Typical_Prices))

TP=(hi+lo+cl)/3;

avg=smartmean(TP);
mdev=smartmean(abs(TP-avg));

myCCI=(TP(end)-avg)/(0.015*mdev);


end

