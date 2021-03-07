function signals=balanceSignalsSoft(signals, rating, thresh)
% signals=balanceSignalsSoft(signals, rating, thresh) will generate long-short signals
% with all(sum(signals, 2)/sum(abs(signals, 2)) <= thresh) based on eliminating signals with medium
% rating. E.g. signals=[1 0 0 -1 1], rating=[5 3 2 1 4], thresh=0 will generate
% signal=[1 0 0 -1 0]. Note that rating does not have to be integer, but
% highest rating must correspond to 1 in signal, and lowest to -1.

netsig=sum(signals, 2);
capital=sum(abs(signals), 2);
maxDelta=sign(netsig).*floor(thresh*capital);
change=netsig-maxDelta;

for t=1:size(signals, 1)
   if (netsig(t) > 0)
       lidx=find(signals(t, :) == 1);
       numL=length(lidx);
       [foo, idxL]=sort(rating(t, lidx));
       signals(t, lidx(idxL(1:min(numL, change(t)))))=0;
   elseif (netsig(t) < 0) 
       sidx=find(signals(t, :) == -1);
       numS=length(sidx);
       [foo, idxS]=sort(-rating(t, sidx));
       signals(t, sidx(idxS(1:min(numS, abs(change(t))))))=0;
   end
end
