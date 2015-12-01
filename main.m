%% pwc software % change VC deals over dotcom era Q1 1998 - Q2 2004
nIndustrial = load_nasdaq('Data/nasdaq-industrial.csv');
nComputer = load_nasdaq('Data/nasdaq-computer.csv');
nTelecomm = load_nasdaq('Data/nasdaq-telecommunication.csv');
pwcStuff = load_pwc('Data/PWC_Software.csv');

% Q1 1998 - Q2 2004
support = 12:35;
onez = ones(size(pwcStuff,1), 1);
x = [nIndustrial, nComputer(:,1:5), nTelecomm];

lOnes = ones(1,size(x,2));
x = multi_lags(x, lOnes);
x = [onez x];
X = x(support,:);
Y = pwcStuff(support,1);
[beta] = mvregress(X,Y);
out = X * beta;
SSresid = sum((out - Y).^2);
SStotal = (length(Y)-1)*var(Y);
rsq = 1 - SSresid/SStotal
adjRsq = 1 - (1-rsq)*(length(Y) - 1)/(length(Y) - size(x,2) - 1)

figure;
t = datenum(1998,1:3:3*length(support),1);
plot(t,out,'r',t,Y,'b')
datetick('x', 'yyyy QQ');
legend('regression', 'actual');
ylabel('% change VC software company deals');
xlabel('quarters');
title('regression for % change VC software deals during dotcom era');

% granger causality test
x = [nIndustrial, nComputer, nTelecomm];
x = x(support,:);
y = Y;
isGrangerCausal = zeros(1,size(x,2));
for ii=1:size(x,2)
    [F, c_v] = granger_cause(x(:,ii),y,0.05,4);
    isGrangerCausal(ii) = F > c_v;
end
isGrangerCausal
%% pwc industrial % change VC deals over subprime mortgage crisis Q1 2006 - Q1 2013
% does not work well for software
% used software for the 1998-2004 analysis because of dotcom boom
% use industrial for 2006-2013 because of subprime mortgage crisis
nIndustrial = load_nasdaq('Data/nasdaq-industrial.csv');
nComputer = load_nasdaq('Data/nasdaq-computer.csv');
nBank = load_nasdaq('Data/nasdaq-bank.csv');
nTelecomm = load_nasdaq('Data/nasdaq-telecommunication.csv');
pwcStuff = load_pwc('Data/PWC_Industrial.csv');

%Q1 2006 - Q1 2013
support = 44:72;
x = [nIndustrial(:,[1, 2, 3, 4, 6]), nComputer, nBank(:,[3, 4, 6]), nTelecomm(:,[1, 2, 3, 4, 6])];

lOnes = ones(1,size(x,2));
x = multi_lags(x, lOnes);
x = [onez x];
X = x(support,:);
Y = pwcStuff(support,1);
[beta] = mvregress(X,Y);
out = X * beta;
SSresid = sum((out - Y).^2);
SStotal = (length(Y)-1)*var(Y);
rsq = 1 - SSresid/SStotal
adjRsq = 1 - (1-rsq)*(length(Y) - 1)/(length(Y) - size(x,2) - 1)
figure;
t = datenum(2006,1:3:3*length(support),1);
plot(t,out,'r',t,Y,'b')
datetick('x', 'yyyy QQ');
legend('regression', 'actual');
ylabel('% change VC industrial company deals');
xlabel('quarters');
title('regression for % change VC industrial deals during subprime mortgage crisis');

% granger causality test
x = [nIndustrial, nComputer, nBank, nTelecomm];
x = x(support,:);
y = Y;
isGrangerCausal = zeros(1,size(x,2));
for ii=1:size(x,2)
    [F, c_v] = granger_cause(x(:,ii),y,0.05,4);
    isGrangerCausal(ii) = F > c_v;
end
isGrangerCausal
