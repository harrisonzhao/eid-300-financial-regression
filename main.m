%% pwc software % change VC deals over dotcom era Q1 1998 - Q2 2004
nIndustrial = load_nasdaq('Data/nasdaq-industrial.csv');
nComputer = load_nasdaq('Data/nasdaq-computer.csv');
nTelecomm = load_nasdaq('Data/nasdaq-telecommunication.csv');
pwcStuff = load_pwc('Data/PWC_Software.csv');

% Q1 1998 - Q2 2004
support = 12:35;

% granger causality test
x = [nIndustrial, nComputer, nTelecomm];
testx = x(support,:);
testy = pwcStuff(support,1);
isGrangerCausal = zeros(1,size(testx,2));
for ii=1:size(x,2)
    [F, c_v] = granger_cause(testx(:,ii),testy,0.05,4);
    isGrangerCausal(ii) = F > c_v;
end
isGrangerCausal
x = x(:,find(isGrangerCausal == 1));

lOnes = ones(1,size(x,2));
x = multi_lags(x, lOnes);
onez = ones(size(x,1),1);
x = [onez x];
X = x(support,:);
Y = testy;
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

% granger causality test
x = [nIndustrial, nComputer, nBank, nTelecomm];
testx = x(support,:);
testy = pwcStuff(support,1);
isGrangerCausal = zeros(1,size(testx,2));
for ii=1:size(x,2)
    [F, c_v] = granger_cause(testx(:,ii),testy,0.05,4);
    isGrangerCausal(ii) = F > c_v;
end
isGrangerCausal
x = x(:,find(isGrangerCausal == 1));

lOnes = ones(1,size(x,2));
x = multi_lags(x, lOnes);
onez = ones(size(x,1),1);
x = [onez x];
X = x(support,:);
Y = testy;
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


%% regression for pwc $ contained in deals using # vc deals as independent var

dirName = 'Data/';
files = dir(fullfile(dirName, 'PWC*'));
fnames = {files.name}';
figure;
for ii=1:length(fnames)
    data = csvread(strcat(dirName,fnames{ii}),0,1);
    data = data(:,[1,3]); % get # of deals and $ amount total
    x = data(:,1);
    Y = data(:,2);
    t = datenum(1995,1:3:3*length(x),1);
    onez = ones(size(x,1), 1);
    X = [onez,x];
    [beta] = mvregress(X,Y);
    subplot(3,3,ii);
    out = X*beta;
    plot(t,out,t,Y);
    datetick('x', 'yyyy QQ');
    SSresid = sum((out - Y).^2);
    SStotal = (length(Y)-1)*var(Y);
    rsq = 1 - SSresid/SStotal;
    t = strcat(fnames{ii}, ': rsq: %f');
    t = sprintf(t, rsq);
    title(strrep(t, '_', '\_'));
    legend('regression using # deals', '$ total for deals');
    ylabel('$ total for VC deals');
    xlabel('quarters');
end

%% rolling window stuff
% runs rolling window analysis over window sizes of {12, 16, 20} quarters
% (3, 4, or 5 year periods)
% the weights for a given analysis are saved if the pctgoodThreshold (which
% is defined as the percent of windows whose regression R-squared values
% exceed rsqThreshold)
% graphs of weights whose variance across all iterations are less than
% varianceThreshold are also saved
% all graphs are saved in the Graphs directory
% the script is run with the values:
%         rsqThreshold = 0.5;
%         pctgoodThreshold = 0.8;
%         varianceThreshold = 1.2;

rsqThreshold = 0.5;
pctgoodThreshold = 0.8;
varianceThreshold = 1.2;
dirName = 'Data/';
graphDirName = 'Graphs/';
nasdaqFiles = dir(fullfile(dirName, 'nasdaq*'));
nasdaqNames = {nasdaqFiles.name}';
pwcFiles = dir(fullfile(dirName, 'PWC*'));
pwcNames = {pwcFiles.name}';
x = zeros(82,6*length(nasdaqNames));
xnames = repmat({'open', 'high', 'minimum', 'close index', 'swing', 'momentum'},1,length(nasdaqNames));
for ii=1:length(nasdaqNames)
    ind = (ii-1)*6+1;
    x(:,ind:ind+5) = load_nasdaq(strcat(dirName,nasdaqNames{ii}));
    for jj=ind:ind+5
        xnames(jj) = strcat(strrep(strrep(nasdaqNames{ii}, '.csv', ''), 'nasdaq-', ''), {' '}, xnames{jj});
    end
end

for year=[3 4 5]
    for ii=1:length(pwcNames)
        testx = x;
        testy = load_pwc(strcat(dirName,pwcNames{ii}));
        testy = testy(:,1);
        isGrangerCausal = zeros(1,size(testx,2));
        for jj=1:size(x,2)
            [F, c_v] = granger_cause(testx(:,jj),testy,0.05,4);
            isGrangerCausal(jj) = F > c_v;
        end
        causalInds = find(isGrangerCausal == 1);
        features = x(:,causalInds);
        featureNames = xnames(causalInds);
        lOnes = ones(1,size(features,2));
        features = multi_lags(features, lOnes);
        if (size(features,2)) < 1
            continue;
        end
        support = 13:(13+4*year); % start at Q1 1997
        numiter = 82-(13+4*year);
        onez = ones(length(support),1);
        weights = zeros(numiter, size(features,2) + 1);
        rsqs = zeros(numiter,1);
        if (size(features,2) > 4*year)
            continue
        end
        for jj=1:numiter
            X = [onez, features(support,:)];
            Y = testy(support,:);
            [beta] = mvregress(X,Y);
            weights(jj,:) = beta';
            out = X * beta;
            SSresid = sum((out - Y).^2);
            SStotal = (length(Y)-1)*var(Y);
            rsq = 1 - SSresid/SStotal;
            rsqs(jj) = rsq;
            support = support + 1;
        end

        pwcNames{ii}
        'rsqs values'
        rsqs'
        pctgood = length(find(rsqs > rsqThreshold))/numiter
        if pctgood > pctgoodThreshold    % overall 80% of all window regression must have rsq > 0.5
            seriesName = strrep(strrep(pwcNames{ii}, '_', '\_'), '.csv', '');
            seriesSaveName = strrep(seriesName, '\_', '-');
            actualWeights = weights(:,2:end);
            lowVarianceInd = [];
            for kk=1:size(actualWeights,2)
                if (var(actualWeights(:,kk))) < varianceThreshold
                    lowVarianceInd = [lowVarianceInd kk];
                end
            end
            if size(lowVarianceInd,2) > 0
                fig = figure;
                plot(1:numiter,actualWeights(:,lowVarianceInd));
                legend(featureNames(lowVarianceInd), 'Location', 'eastoutside');
                title(strcat(seriesName, {' '}, sprintf('%d year window, stable weights with variance of < %f', year, varianceThreshold)));
                xlabel('window iterations');
                ylabel('weight values');
                saveName = fullfile(graphDirName, strcat(seriesSaveName, sprintf('-%d-year-window-useful-weights', year), '.png'));
                saveas(fig, saveName);
            end
            fig = figure;
            plot(1:numiter,actualWeights);
            legend(featureNames, 'Location', 'eastoutside')
            title(strcat(seriesName, {' '}, sprintf('%d year window, lag 1 quarter', year)));
            ylabel('value of weights for each variable regression');
            xlabel('iterations');
            saveName = fullfile(graphDirName, strcat(seriesSaveName, sprintf('-%d-year-window-weights', year), '.png'));
            saveas(fig, saveName);
        end
    end
end
