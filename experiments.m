%% # granger causality tests
% http://stats.stackexchange.com/questions/73922/is-this-test-answer-good-enough-to-show-granger-causality
nIndustrial = load_nasdaq('Data/nasdaq-industrial.csv');
nComputer = load_nasdaq('Data/nasdaq-computer.csv');
nBank = load_nasdaq('Data/nasdaq-bank.csv');
nTelecomm = load_nasdaq('Data/nasdaq-telecommunication.csv');
% change from last quarter for # of deals, % change of $ from last quarter
pwcIndustrial = load_pwc('Data/PWC_Software.csv');
support = 12:35; % 1998 - Q2 2004
% support = 44:72;
x = [nIndustrial, nComputer, nTelecomm];
x = x(support,:);
y = pwcIndustrial(support,1);
out = zeros(1,size(x,2));
for ii=1:size(x,2)
    [F, c_v] = granger_cause(x(:,ii),y,0.05,4);
    out(ii) = F > c_v;
end
out
%plot(support, x, 'r', support, y(:,1), 'b');
%legend('nasdaq %change open price', 'pwc %change # of deals');

%% test granger cause
x = 2*pi*1:101;
y1 = sin(x);
y2 = lagmatrix(sin(x),1);
y2(1) = 1;
% plot(x,y1,x,y2);
% legend('y1','y2');
[F, c_v, BIC] = granger_cause(y2,y1,0.05,5)
% lag y1 by 1 to get y2