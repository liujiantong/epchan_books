function myRS=RS_smooth(cls, days)
% RS=RS_smooth(cls, days) relative strength based on simple moving
% average of days with Wilder smoothing.




U=cls-backshift(1, cls);
D=-U;

D(U>0)=0;
U(D>0)=0;

% RS=smartMovingSum(U, days)./smartMovingSum(D, days);

avgGain(days, :)=smartsum(U(1:days, :));
avgLoss(days, :)=smartsum(D(1:days, :));

for t=days+1:size(cls, 1)
	avgGain(t, :)=(avgGain(t-1, :)*(days-1)+U(t))/days;
	avgLoss(t, :)=(avgLoss(t-1, :)*(days-1)+D(t))/days;
end

myRS=avgGain./avgLoss;