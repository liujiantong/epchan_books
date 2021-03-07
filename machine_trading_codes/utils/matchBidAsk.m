function [ dt, myBid, myAsk] = matchBidAsk( dtBid, bid, dtAsk, ask )
%  [ dt, bid, ask] = matchBidAsk( dtBid, bid, dtAsk, ask )
%  dtBid and dtAsk are datetimes arrays, with overlap but not identical,
%  bid and ask are price arrays. Output dt is the union of dtBid and dtAsk. Missing
%  prices are fill-forwarded.

dt=union(dtBid, dtAsk);

[~, idx1, idxB]=intersect(dtBid, dt);
[~, idx2, idxA]=intersect(dtAsk, dt);

myBid=NaN(size(dt, 1), 1);
myAsk=myBid;
myBid(idxB)=bid(idx1);
myAsk(idxA)=ask(idx2);

myBid=fillMissingData(myBid);
myAsk=fillMissingData(myAsk);

end

