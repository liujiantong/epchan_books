function RS=RS(cls, days)
% RS=RS(cls, days) relative strength based on simple moving
% average of days.

U=cls-backshift(1, cls);
D=-U;

D(U>0)=0;
U(D>0)=0;

% RS=smartMovingSum(U, days)./smartMovingSum(D, days);
% RS=EMA(U, days)./EMA(D, days);

% sumU=smartMovingSum(U, days);
% sumD=smartMovingSum(D, days);
 
RS=NaN(size(U));
sumU=smartsum(U(2:days+1, :));
sumD=smartsum(D(2:days+1, :));
RS(days+1, :)=sumU./sumD;

for t=days+2:size(RS, 1)
	sumU=(sumU*(days-1)+U(t, :))/days;
	sumD=(sumD*(days-1)+D(t, :))/days;
	RS(t, :)=sumU./sumD;
end