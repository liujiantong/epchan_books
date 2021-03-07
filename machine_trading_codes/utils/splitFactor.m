function splits=splitFactor(prevDate,  stocks)

% Split-adjust
splits=1./parseSplitsCalendar(prevDate, stocks);
