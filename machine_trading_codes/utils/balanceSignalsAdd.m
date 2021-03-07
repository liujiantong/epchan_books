function signals=balanceSignalsAdd(signals, rating)
% signals=balanceSignalsAdd(signals, rating) will generate long-short signals
% with all(sum(signals, 2)==0) based on adding signals of opposite signs
% with the highest rating. E.g. signals=[1 0 0 -1 1], rating=[5 3 2 1 4], will generate
% signal=[1 0 -1 -1 0]. Note that rating does not have to be integer, but
% highest rating must correspond to 1 in signal, and lowest to -1.

netsig=sum(signals, 2);

for t=1:size(signals, 1)
   if (netsig(t) > 0)
       sidx=find(signals(t, :) == 0);
       numS=length(sidx);
       [foo, idxS]=sort(rating(t, sidx), 'ascend');
       signals(t, sidx(idxS(1:min(numS, netsig(t)))))=-1;
   elseif (netsig(t) < 0) 
       lidx=find(signals(t, :) == 0);
       numL=length(lidx);
       [foo, idxL]=sort(rating(t, lidx), 'descend');
       signals(t, lidx(idxL(1:min(numL, abs(netsig(t))))))=1;
   end
end
