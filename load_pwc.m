function [ data ] = load_pwc ( filename )
data = csvread(filename,0,1);
data = data(:,[2,4]);
% Demean and Standardize
normalize = @(y) bsxfun(@rdivide, bsxfun(@minus, y, mean(y,1)), std(y));
data = normalize(data);
end
