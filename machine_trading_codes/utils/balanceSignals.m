function signals=balanceSignals(signals, rating)
% signals=balanceSignals(signals, rating) will generate long-short signals
% with all(sum(signals, 2)==0) based on eliminating signals with medium
% rating. E.g. signals=[1 0 0 -1 1], rating=[5 3 2 1 4], will generate
% signal=[1 0 0 -1 0]. Note that rating does not have to be integer, but
% highest rating must correspond to 1 in signal, and lowest to -1.

% assert(all(all(rating(signals == 1) > rating(signals == -1), 1)));

% [foo, idx]=sort(rating, 2, 'ascend');

netsig=sum(signals, 2);

for t=1:size(signals, 1)
   if (netsig(t) > 0)
       lidx=find(signals(t, :) == 1);
       numL=length(lidx);
       [foo, idxL]=sort(rating(t, lidx), 'ascend');
       signals(t, lidx(idxL(1:min(numL, netsig(t)))))=0;
   elseif (netsig(t) < 0) 
       sidx=find(signals(t, :) == -1);
       numS=length(sidx);
       [foo, idxS]=sort(rating(t, sidx), 'descend');
       signals(t, sidx(idxS(1:min(numS, abs(netsig(t))))))=0;
   end
end
