function [ m ] = multi_lags(matrix, lags)
% lags is array of different lags for each matrix column
m = zeros(size(matrix));
for ii=1:length(lags)
    m(:,ii) = lagmatrix(matrix(:,ii),lags(ii));
end

end

