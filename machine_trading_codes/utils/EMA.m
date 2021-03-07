function [ myEMA ] = EMA( x, N )
%[ myEMA ] = EMA( x, N )
%   Exponential moving average

myEMA=NaN(size(x));

alpha=2/(N+1);
% myEMA(1, :)=alpha*x(1, :);
myEMA(1, :)=x(1, :);


for t=2:size(x, 1)
	prevEMA=myEMA(t-1, :);
	prevEMA(isnan(prevEMA))=x(t, isnan(prevEMA));
	
	currentX=x(t, :);
	currentX(isnan(currentX))=prevEMA(isnan(currentX));
	myEMA(t, :)=alpha*currentX+(1-alpha)*prevEMA;
end


end

