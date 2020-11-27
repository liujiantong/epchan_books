% 
% written by:
% Ernest Chan
%
% Author of “Quantitative Trading: 
% How to Start Your Own Algorithmic Trading Business”
%
% ernest@epchan.com
% www.epchan.com

clear; % make sure previously defined variables are erased.

load('inputDataOHLCDaily_ETF_20160401', 'tday', 'stocks', 'cl');

gld=cl(:, strcmp('GLD', stocks));
gdx=cl(:, strcmp('GDX', stocks));

goodData=find(all(isfinite([gld gdx]), 2));

gld=gld(goodData(1):end);
gdx=gdx(goodData(1):end);
tday=tday(goodData(1):end);

trainset=1:round(length(tday)/2); % define indices for training set

testset=trainset(end)+1:length(tday); % define indices for test set

% determines the hedge ratio on the trainset
results=ols(gld(trainset), gdx(trainset)); % use regression function 
hedgeRatio=results.beta; % 1.6368

spread=gld-hedgeRatio*gdx; % spread = GLD - hedgeRatio*GDX

plot(datetime(tday(trainset), 'ConvertFrom', 'yyyyMMdd'), spread(trainset));

figure;

plot(datetime(tday(testset), 'ConvertFrom', 'yyyyMMdd'), spread(testset));
title('GLD-2.21*GDX');

figure;

spreadMean=mean(spread(trainset)); % mean  of spread on trainset

spreadStd=std(spread(trainset)); % standard deviation of spread on trainset

zscore=(spread - spreadMean)./spreadStd; % z-score of spread

longs=zscore<=-2; % buy spread when its value drops below 2 standard deviations.

shorts=zscore>=2; % short spread when its value rises above 2 standard deviations.

exits=abs(zscore)<=1; % exit any spread position when its value is within 1 standard deviation of its mean.

positions=NaN(length(tday), 2); % initialize positions array

positions(shorts, :)=repmat([-1 1], [length(find(shorts)) 1]); % long entries

positions(longs,  :)=repmat([1 -1], [length(find(longs)) 1]); % short entries

positions(exits,  :)=zeros(length(find(exits)), 2); % exit positions

positions=fillMissingData(positions); % ensure existing positions are carried forward unless there is an exit signal

cl=[gld gdx]; % combine the 2 price series

dailyret=(cl - backshift(1, cl))./backshift(1, cl);

pnl=sum(backshift(1, positions).*dailyret, 2);

sharpeTrainset=sqrt(252)*mean(pnl(trainset(2:end)))./std(pnl(trainset(2:end))) % the Sharpe ratio on the training set should be about 2.3

sharpeTestset=sqrt(252)*mean(pnl(testset))./std(pnl(testset)) % the Sharpe ratio on the test set should be about 1.5
% sharpeTestset =
% 
%    -0.272095828585921
plot(datetime(tday(testset), 'ConvertFrom', 'yyyyMMdd'), cumsum(pnl(testset)));

