function [numWin numLose]=calculateNumWinLoseTrades(positions, cumret)
% [numWin numLose]=calculateNumWinLoseTrades(positions, cumret)
% calculation of num winning and losing RT trades.

assert(all(isfinite(cumret)));
assert(size(positions, 2)==1);
assert(size(cumret, 2)==1);
numWin=0;
numLose=0;

for t=1:length(cumret)
   
    if (t>1 && positions(t-1, 1)~=0) && positions(t-1,1)~=positions(t, 1) % exit
        if (cumret(t) > entryCumret)
            numWin=numWin+1;
        elseif (cumret(t) < entryCumret)
            numLose=numLose+1;
        end
    end
    
    if (positions(t,1)~=0 && (t==1 || positions(t-1,1)~=positions(t, 1))) % entry
        entryCumret=cumret(t);
    end
        
end

