function dividends=dividendFactor(todayDate, stocks, cl)

% Dividend-adjust
dividends=parseDividendCalendar(todayDate, stocks);
if (~isempty(dividends))
    dividends=(cl-dividends)./cl;
end