function [data] = load_nasdaq (filename)
monthlyData = csvread(filename,0,1);
% Open,High,Low,Close,Volume,Adj Close
quarters = floor(size(monthlyData,1)/3);
monthsPerQuarter = 3;
%quarterlyData starts from Q1 1995
%the columns are change over quarter, open, high, minimum, close index,
%swing, and momentum of swing (if positive, momentum+1) else momentum-1
quarterlyData = zeros(quarters, 5);
OPEN_COL = 1;
HIGH_COL = 2;
LOW_COL = 3;
CLOSE_COL = 4;
SWING_COL = 5;
for ii=1:quarters
    quarterStart = monthsPerQuarter * (ii - 1) + 1;
    quarterEnd = quarterStart + monthsPerQuarter - 1;
    qOpen = monthlyData(quarterStart,OPEN_COL);
    qHigh = max(monthlyData(quarterStart:quarterEnd,HIGH_COL));
    qMin = min(monthlyData(quarterStart:quarterEnd,LOW_COL));
    qClose = monthlyData(quarterEnd,CLOSE_COL);
    swing = qClose - qOpen;
    quarterlyData(ii,:) = [qOpen qHigh qMin qClose swing];
end

data = zeros(quarters-1, 6);
momentum = 0;
for ii=2:quarters
    pctChange = 100 * (quarterlyData(ii,:)-quarterlyData(ii-1,:))./quarterlyData(ii-1,:);
    if quarterlyData(ii,SWING_COL) > 0
        momentum = momentum + 1;
    else
        momentum = momentum - 1;
    end
    data(ii-1,:) = [pctChange, momentum];
end

normalize = @(y) bsxfun(@rdivide, bsxfun(@minus, y, mean(y,1)), std(y));
data = normalize(data);
% percentChangeQuarterlyData
% percentChangeQuarterlyData starts from Q2 1995
% quarterlyData
% percentChangeQuarterlyData

end