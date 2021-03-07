function [ w ] = WilliamPctR( hi, lo, cl, lookback )
% [ w ] = WilliamPctR( hi, lo, cl, lookback )
%   w = (cl-hi_lookback)./(hi_lookback-lo_lookback)*100

mhi=smartMovingMax(hi, lookback);
mlo=smartMovingMin(lo, lookback);

w = (cl-mhi)./(mhi-mlo)*100;