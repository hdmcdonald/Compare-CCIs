function res = checkCorrelationBetweenCCIs(opts, plotSampleOpt)
% Function to evaluate correlation between co-contraction indices (CCI).
% Generates 1000 sets of random synthetic EMG, calculates CCI using each
% different formula, then calculates correlation coefficient between each
% pair of CCI using Chatterjee's correlation coefficient
%
% Required external functions:
%   - Chatterjee's correlation from MATLAB file exchange:
%     https://www.mathworks.com/matlabcentral/fileexchange/112530-chaterjee-s-xi-correlation
%
% Inputs:
%   - opts - options structure, defines colormap for plot (if you want to
%            set as Nan, comment out line 222)
%   - plotSampleOpt - option for whether to plot some example random EMG
%                     and scatter plots for each "block" of random EMG 
%                     (i.e., 1st order, 2nd order, sinusoids)
%                     0 = don't plot example EMG and block scatters 
%                     1 = plot all
% Outputs:
%   - res - 6x6 matrix of correlation coefficients
%           column/row order:
%               1: Simple Ratio
%               2: Falconer & Winter
%               3: Thoroughman & Shadmehr
%               4: Frost & Unnithan
%               5: Rudolph
%               6: Temporal
%   - plots - scatter plots of each pair of CCI from random EMG, and
%              heatmap of correlations (plus minor plots if plotSampleOpt=1)
%
% Functions Called: 
%   - calcTemporalCC
%   - calcCCI
% 
% Created: 01/09/2025 HDC

%% randomly generated synthetic EMG
% linear functions

rng("default")
t = linspace(0,1,101);
thresh = 0.1;
if plotSampleOpt == 1
    figure
    tiledlayout(10,10,"TileSpacing","tight","Padding","tight")
end
M1 = []; M2 = [];
for k = 1:1000
    % generate random coefficients for 1st order polynomials
    p1 = [-1+2*rand(1), -1+2*rand(1)];
    p2 = [-1+2*rand(1), -1+2*rand(1)];
    mus1 = polyval(p1,t);
    mus2 = polyval(p2,t);

    % rectify any negative values
    mus1 = abs(mus1);
    mus2 = abs(mus2);

    % if any EMG values greater than 1, scale to within-trial max value (so
    % amplitude spans 0 to 1)
    if max(mus1)>1
        mus1 = mus1./max(mus1);
    end
    if max(mus2)>1
        mus2 = mus2./max(mus2);
    end

    M1 = [M1;mus1];  M2 = [M2;mus2];
    % find the indices where both muscles are active
    CC = calcTemporalCC(mus1, mus2, thresh);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = CC(2) - CC(1);   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    CCI_4(k,1:6) = [calcCCI(mus1, mus2, 1), calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),calcCCI(mus1, mus2, 4),CCt,calcCCI(mus1, mus2, 5)];
    if plotSampleOpt == 1
        if k<=100
            nexttile
            plot(t,mus1);
            hold on
            plot(t,mus2)
            ylim([0 1])
            axis square
        end
        sgtitle("1^{st} order polynomials")
    end
end
if plotSampleOpt == 1
    figure
    plotmatrix(CCI_4)
    sgtitle("1^{st} order polynomials")

    figure
    tiledlayout(10,10,"TileSpacing","tight","Padding","tight")
end

% 2nd order polynomials
for k = 1:1000
    % generate random coefficients for 2nd order polynomials
    p1 = [-1+2*rand(1) -1+2*rand(1), rand];
    p2 = [-1+2*rand(1) -1+2*rand(1), rand];
    mus1 = polyval(p1,t);
    mus2 = polyval(p2,t);

    % rectify any negative values
    mus1 = abs(mus1);
    mus2 = abs(mus2);

    % if any EMG values greater than 1, scale to within-trial max value (so
    % amplitude spans 0 to 1)
    if max(mus1)>1
        mus1 = mus1./max(mus1);
    end
    if max(mus2)>1
        mus2 = mus2./max(mus2);
    end

    M1 = [M1;mus1];  M2 = [M2;mus2];
    % find the indices where both muscles are active
    CC = calcTemporalCC(mus1, mus2, thresh);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = CC(2) - CC(1);   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    CCI_5(k,1:6) = [calcCCI(mus1, mus2, 1), calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),calcCCI(mus1, mus2, 4),CCt,calcCCI(mus1, mus2, 5)];
    if plotSampleOpt == 1
        if k<=100
            nexttile
            plot(t,mus1);
            hold on
            plot(t,mus2)
            ylim([0 1])
            axis square
        end
        sgtitle("2^{nd} order polynomials")
    end
end
if plotSampleOpt == 1
    figure
    plotmatrix(CCI_5)
    sgtitle("2^{nd} order polynomials")

    figure
    tiledlayout(10,10,"TileSpacing","tight","Padding","tight")
end

% sinusoids
for k = 1:1000
    % create the synthetic signals
    % generate random coefficients for sinusoids
    p1 = [ rand 10.*rand, rand(1), rand(1)];
    p2 = [ rand 10.*rand, rand(1), rand(1)];
    mus1 = p1(1).*sin(p1(2).*(t-p1(3)))+p1(4);
    mus2 = p2(1).*cos(p2(2).*(t-p2(3)))+p2(4);

    % rectify any negative values
    mus1 = abs(mus1);
    mus2 = abs(mus2);

    % if any EMG values greater than 1, scale to within-trial max value (so
    % amplitude spans 0 to 1)
    if max(mus1)>1
        mus1 = mus1./max(mus1);
    end
    if max(mus2)>1
        mus2 = mus2./max(mus2);
    end

    M1 = [M1;mus1];  M2 = [M2;mus2];
    % find the indices where both muscles are active
    CC = calcTemporalCC(mus1, mus2, thresh);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = CC(2) - CC(1);   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    CCI_6(k,1:6) = [calcCCI(mus1, mus2, 1), calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),calcCCI(mus1, mus2, 4),CCt,calcCCI(mus1, mus2, 5)];
    if plotSampleOpt == 1
        if k<=100
            nexttile
            plot(t,mus1);
            hold on
            plot(t,mus2)
            ylim([0 1])
            axis square
        end
        sgtitle("sinusoids")
    end
end
if plotSampleOpt == 1
    figure
    plotmatrix(CCI_6)
    sgtitle("sinusoids")
end
%% Main Figures
figure
CCI_ALL = [CCI_4;CCI_5;CCI_6];
tempCCI = [CCI_4;CCI_5;CCI_6];

% Reorder CCI columns
%            1 | 2  | 3  | 4  |  5   | 6  |
% original: FW | Ru | Un | TS | temp | SR |
% new:      SR | FW | TS | Un | Ru | temp |
reordCols = [6,1,4,3,2,5];
CCI_ALL = CCI_ALL(:,reordCols);
tempCCI = tempCCI(:,reordCols);
titleList = ["F & W"; "Rudolph"; "Frost"; "Thoroughman"; "Temporal";"Ratio"];
titleList = titleList(reordCols);
tiledlayout(6,6,"TileSpacing","tight","Padding","tight")
for k = 1:6     % CCI on x-axis
    for j = 1:6     % CCI on y-axis
        nexttile
        res(k,j) = xicor(CCI_ALL(:,k),CCI_ALL(:,j));
        if k == j
            % histogram(tempCCI(:,k))
            if k == 3
                histogram(CCI_ALL(:,k),"BinEdges",0:0.4:112);
                xlim([0 8]);
            else
                histogram(CCI_ALL(:,k),NumBins=20)
            end
            axis square
            ylim([0 2500])
        else

            scatter(CCI_ALL(:,k),CCI_ALL(:,j),1,"filled","MarkerEdgeColor","none","MarkerFaceColor",[0.2 0.2 0.2])
            axis square
            xlim([0 1]); ylim([0 1])

            if k==5; xlim([0 2]); end
            if j==5; ylim([0 2]); end

            if k == 3; xlim([0 8]); xticks(0:2:8);end
            if j == 3; ylim([0 8]); yticks(0:2:8);end

        end

        if k == 1
            title(titleList(j))
        end
        if j == 1
            ylabel([titleList(k);num2str(round(res(k,j),3))])
        else
            ylabel(num2str(round(res(k,j),3)))
        end
    end
    clear j

end
clear k

figure
h = heatmap(res());
colormap(flip(opts.corrColors(75:250,:)))
h.ColorLimits = [0 1];

end

