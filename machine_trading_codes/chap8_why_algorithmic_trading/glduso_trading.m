clear;
% 
load('inputDataOHLCDaily_ETF_20160401', 'tday', 'stocks', 'cl');

gld=cl(:, strcmp('GLD', stocks));
gdx=cl(:, strcmp('USO', stocks));


ratio=gld./gdx; 

plot(datetime(tday, 'ConvertFrom', 'yyyyMMdd'), ratio);
title('GLD/USO');

%% mean reverting trading

lookback=20;
ma=smartMovingAvg(ratio, lookback);
mstd=smartMovingStd(ratio, lookback);
zscore=(ratio-ma)./mstd;

entryZscore=1;
exitZscore=0;

longEntry=zscore < -entryZscore;
shortEntry=zscore > entryZscore;

longExit=zscore >= -exitZscore;
shortExit=zscore <= exitZscore;

positionsLong=NaN(size(ratio)); % long ratio positions
positionsLong(longEntry)=1;
positionsLong(longExit)=0;
positionsLong=fillMissingData(positionsLong); % ensure existing positions are carried forward unless there is an exit signal
positionsLong(isnan(positionsLong))=0;

positionsShort=NaN(size(ratio)); % short ratio positions
positionsShort(shortEntry)=-1;
positionsShort(shortExit)=0;
positionsShort=fillMissingData(positionsShort); % ensure existing positions are carried forward unless there is an exit signal
positionsShort(isnan(positionsShort))=0;

positionsRatio=positionsLong + positionsShort; % ratio positions
positions=zeros(size(positionsRatio, 1), 2); % stocks positions


positions(positionsRatio>0, 1)=1;
positions(positionsRatio>0, 2)=-1;
positions(positionsRatio<0, 1)=-1;
positions(positionsRatio<0, 2)=1;


% Note that we need to sum across returns of gld and gdx
% pnl=smartsum2(backshift(1, positions).*...
%([gld gdx]-backshift(1, [gld gdx]))./backshift(1, [gld gdx]), 2);

onewaytcost=0/10000;
pnl=smartsum(backshift(1, positions).*([gld gdx]-...
    backshift(1, [gld gdx]))-...
    onewaytcost*abs((positions-backshift(1, positions)).*...
    backshift(1, [gld gdx])), 2);
dailyret=pnl./...
    smartsum(abs(backshift(1, positions.*[gld gdx])), 2);

dailyret(~isfinite(dailyret))=0;

testset=find(tday<=20120410);

cumret=cumprod(1+dailyret(testset))-1;

plot(smartcumsum(dailyret(testset)));

plot(datetime(tday(testset), 'ConvertFrom', 'yyyyMMdd'), cumret);
title('Out-of-sample backtest of GLD vs USO');
xlabel('Date');
ylabel('Cumulative Returns');

cagr=(1+cumret(end))^(252/length(cumret))-1;
[maxDD, maxDDD]=calculateMaxDD(cumret);
fprintf(1, 'Out-of-sample: CAGR=%f Sharpe ratio=%f maxDD=%f maxDDD=%i Calmar ratio=%f\n', cagr, sqrt(252)*mean(dailyret)/std(dailyret), maxDD, maxDDD, -cagr/maxDD);
% Out-of-sample: CAGR=0.083189 Sharpe ratio=0.746890 maxDD=-0.168778 maxDDD=394 Calmar ratio=0.492893

