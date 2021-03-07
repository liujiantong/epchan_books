function [ macd ] = MACD( ema12, ema26 )
% [ macd ] = MACD(  ema12, ema26  )
%   MACD= (12-day EMA - 26-day EMA) 
%   Signal Line= 9-day EMA of MACD
%   MACD "histogram"= MACD - Signal Line

macd=ema12-ema26;
macd=macd-smartExpMovingAvg(macd, 9);
