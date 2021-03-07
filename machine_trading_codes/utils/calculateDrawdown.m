function calculateDrawdown(cumPnL, capital, tday, varargin)

if (length(varargin)>0)
    fid=varargin{1};
else
    fid=1;
end

% assert(length(cumPnL)==length(tday)-1);

drawdowns=[]; % assume all negative
drawdownLens=[];

beginDate=[];
endDate=[];

peak = cumPnL(1);
if (peak<0)
    drawdowns(1) = peak;
    drawdownLens(1) = 1;
    beginDate(1) = 1;
    endDate(1) = 1;
else
    drawdowns(1) = 0;
    drawdownLens(1) = 0;
    beginDate(1) = 1;
    endDate(1) = 1;
end

for d=2:length(cumPnL)
    if (cumPnL(d) >= peak)
        peak = cumPnL(d);
        drawdowns(end+1) = 0;
        drawdownLens(end+1) = 0;
        beginDate(end+1) = d;
        endDate(end+1) = d;
    else
        drawdowns(end+1) = drawdowns(end) + (cumPnL(d)-cumPnL(d-1));
        drawdownLens(end+1) = drawdownLens(end) + 1;
        beginDate(end+1) = beginDate(end);
        endDate(end+1) = d;
    end
end

assert(length(drawdowns)==length(drawdownLens));
assert(length(drawdowns)==length(beginDate));
assert(length(drawdowns)==length(endDate));
assert(length(drawdowns)==length(cumPnL));

drawdowns=drawdowns'./(capital);

% [maxDrawdown, maxDDidx]=max(-drawdowns);
[sortedDrawdown, Isort]=sort(drawdowns);

% fprintf(1, '\n%s %f between %s and %s\n', 'Max drawdown=', -maxDrawdown, char(tday(beginDate(maxDDidx)-1)),  char(tday(endDate(maxDDidx)-1)));
% fprintf(1, '%s %f between %s and %s\n', 'Largest drawdown=    ', sortedDrawdown(1), char(tday(beginDate(Isort(1))-1)),  char(tday(endDate(Isort(1))-1)));
% fprintf(1, '%s %f between %s and %s\n', '2nd Largest drawdown=', sortedDrawdown(2), char(tday(beginDate(Isort(2))-1)),  char(tday(endDate(Isort(2))-1)));
% fprintf(1, '%s %f between %s and %s\n', '3rd Largest drawdown=', sortedDrawdown(3), char(tday(beginDate(Isort(3))-1)),  char(tday(endDate(Isort(3))-1)));
fprintf(fid, '%s %f between %s and %s\n', 'Largest drawdown=    ', sortedDrawdown(1), num2str(tday(beginDate(Isort(1)))),  num2str(tday(endDate(Isort(1)))));
fprintf(fid, '%s %f between %s and %s\n', '2nd Largest drawdown=', sortedDrawdown(2), num2str(tday(beginDate(Isort(2)))),  num2str(tday(endDate(Isort(2)))));
fprintf(fid, '%s %f between %s and %s\n', '3rd Largest drawdown=', sortedDrawdown(3), num2str(tday(beginDate(Isort(3)))),  num2str(tday(endDate(Isort(3)))));

% [maxDrawdownLen, maxDDLidx]=max(drawdownLens);
[sortedDrawdownLen, Isort]=sort(drawdownLens);

fprintf(fid, '%s %i time-units between %s and %s\n', 'Longest drawdown duration=    ', sortedDrawdownLen(end), num2str(tday(beginDate(Isort(end)))),  num2str(tday(endDate(Isort(end)))));
% fprintf(1, '%s %i days between %s and %s\n', '2nd Longest drawdown duration=', sortedDrawdownLen(end-1), char(tday(beginDate(Isort(end-1))-1)),  char(tday(endDate(Isort(end-1))-1)));
% fprintf(1, '%s %i days between %s and %s\n', '3rd Longest drawdown duration=', sortedDrawdownLen(end-2), char(tday(beginDate(Isort(end-2))-1)),  char(tday(endDate(Isort(end-2))-1)));

