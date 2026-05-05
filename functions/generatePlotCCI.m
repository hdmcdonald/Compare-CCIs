function [CCI,cci] = generatePlotCCI(t,mus1, mus2, tileInd,opts)
% Function to plot a given pair of synthetic EMG data, calculate the CCIs,
% and plot CCIs in a bar plot
%
% Required external functions: 
%   - hatch fill: https://www.mathworks.com/matlabcentral/fileexchange/53593-hatchfill2
% 
% Inputs: 
%   - t - 1 x N time array
%   - mus1 & mus2 - 1 x N arrays of synthetic EMG signal for muscle 1 and
%                   muscle 2 respectively
%   - tileInd - subplot index to place the EMG plot (CCIs will go in
%               following plot)
%   - opts - structure with plotting options, including:
%       -> barOpt - 1: normal colored bars, 2: colored bars with black outline
%       -> barWidth - width of each bar
%       -> cciTitles - option to put CCIs in each figure title (1=yes)
%       -> colorsCCI - colors for each CCI
%       -> colorsEMG - colors for EMG plots 
%       -> norm - amplitude normalization option (1=within trial max,  0=default 100)
%       -> plotCCI - option to plot cci time series
%       -> plotColorLines - option to plot colored lines or just gray
%       -> plotOverThresh - option to highlight portions of each signal that are "active"
%       -> plotTotal - option to plot a line for total EMG (i.e., EMG1+EMG2)
%       -> xBar - x values for bar chart
%       -> yLabel
% Outputs: 
%   - M1 & M2:  M x N matrix containing synthetic EMG for muscle 1 and 
%               muscle 2 respectively (rows-"trial", columns-time)
%   - CCI:      M x W matrix of co-contraction indices for each trial and
%               formula (rows-"trial",columns-CCI formula)
%               Column order: Falconer | Rudolph | Unnithan | Thoroughman | Temporal | Simple Ratio
%   - cci:      M x N matrix of co-contraction over time from Rudolph's CCI
%               (rows-"trial", columns-time)
%
% Functions Called: 
%   - calcCCI
%
% Created: Hannah D. Carey 11/2024

% option to normalize to maximum within the "trial" data, or to a default value of 100
if opts.norm == 1
    mus1 = mus1./max(mus1);
    mus2 = mus2./max(mus2);
else
    mus1 = mus1./100;
    mus2 = mus2./100;
end

gMin = min([mus1, mus2]);
gMin = min(gMin,0);

minMus = min(mus1, mus2);
maxMus = max(mus1, mus2);

nexttile(tileInd)
hold on
xlim([0 100]); ylim([0 1]);

% Calculate temporal CCI and shade overlap in plots
thresh = 0.1;
inds1 = find(mus1>thresh);      % find where the signal is over the threshold 
inds2 = find(mus2>thresh);

% find the indices where both muscles are active
CC = calcTemporalCC(mus1, mus2, thresh);
if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
    CCt = 0;
else                % if overlap exists...
    CCt = t(CC(2)) - t(CC(1));   % length of overlap (# samples)
    CCt = CCt/length(mus1);  % convert to a percentage or proportion
end

% shade overlap from temporal EMG
if CCt ~=0
    xLimits = xlim; yLimits = ylim; 
    area(CC,[yLimits(2),yLimits(2)],"EdgeColor","none","FaceColor",[0.9 0.9 0.9],"FaceAlpha",0.5);
end

% plot EMG for each muscle
if opts.plotColorLines == 1
    plot(t,mus1,"Color",opts.colorsEMG(1,:),"LineWidth",2)
    plot(t,mus2,"Color",opts.colorsEMG(2,:),"LineWidth",2)
elseif opts.plotColorLines == 0
    plot(t,mus1,"Color",[0.7 0.7 0.7],"LineWidth",3)
    plot(t,mus2,"Color",[0 0 0],"LineWidth",2,"LineStyle",":")
end
% area(t,mus1,gMin,"FaceAlpha",0.1,"FaceColor",opts.colorsEMG(1,:)); % uncomment to shade area under muscle 1
% area(t,mus2,gMin,"FaceAlpha",0.1,"FaceColor",opts.colorsEMG(2,:)); % uncomment to shade area under muscle 2
area(t,minMus,gMin,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
title(trapz(minMus))
% Optional Section: plotting total EMG, CCI over time

% option to plot total EMG 
if opts.plotTotal == 1
    plot(t,mus1+mus2,'.',"Color","k","MarkerSize",10);
end

% calculate CCI over time from Rudolph et. al. and option to plot
cci = nan(size(mus1));
for k = 1:length(mus1)
    if maxMus(k) == 0
        cci(k) = 0;
    else
        cci(k) = (minMus(k)./maxMus(k)) .* (minMus(k) + maxMus(k));
    end
end; clear k
if opts.plotCCI == 1
    plot(t,cci)
end

% option to highlight portions of each signal that are "active"
if opts.plotOverThresh == 1
    scatter(t(inds1),mus1(inds1),'.')
    scatter(t(inds2),mus2(inds2),'.')
end

% Calculate all CCIs
% order: Falconer | Rudolph | Unnithan | Thoroughman | Temporal | Simple Ratio
% CCI = round([calcCCI(mus1, mus2, 1), calcCCI(mus1, mus2, 2)/100, calcCCI(mus1, mus2, 3),calcCCI(mus1, mus2, 4),CCt],1);
CCI = [calcCCI(mus1, mus2, 1), calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),calcCCI(mus1, mus2, 4),CCt,calcCCI(mus1, mus2, 5)];

% option to put CCIs in each figure title
if opts.cciTitles == 1
    pat = whitespacePattern;
    tempTitle = num2str(CCI.*100);
    tempTitle = replace(tempTitle,pat,' | ');
    title(tempTitle);
end
% if opts.yLabel==0 
if mod(tileInd,6) ~= 1
    yticklabels([]);
end
% end
% xticklabels([]);

% plot bar graphs of CCIs
indsReord = [6,1,4,2,3,5];
myXLabels = ["FW","Ru","Un","Th","Tp","SR"];
nexttile(tileInd+1)
hold on
barCCI = CCI(indsReord);           % temporary list of CCIs for plotting
% adjust for plotting huge or infinite bars
if isinf(barCCI(3))         % Thoroughman is in spot 3 now
    barCCI(3) = NaN;
elseif barCCI(3) > 1.2
    barCCI(3) = 1.3;
end


if opts.barOpt == 1
    b = bar(opts.xBar,barCCI,opts.barWidth,"EdgeColor","none","FaceColor","flat");
elseif opts.barOpt == 2
    b = bar(opts.xBar,barCCI,opts.barWidth,"EdgeColor","none","FaceColor","flat");
    bOutline = bar(opts.xBar,barMaxCCI,opts.barWidth,"EdgeColor",[0.5 0.5 0.5],"FaceColor","none","LineWidth",0.35);
elseif opts.barOpt == 3
    b = bar(opts.xBar,barCCI./barMaxCCI,opts.barWidth,"EdgeColor","none","FaceColor","flat");
elseif opts.barOpt == 4
    b = bar(opts.xBar,barCCI,opts.barWidth,"EdgeColor","none","FaceColor","flat");
    bar(opts.xBar,barMaxCCI,opts.barWidth,"EdgeColor",[0.5 0.5 0.5],"FaceColor","none","LineWidth",0.35);
    b2 = bar(opts.xBar+max(opts.xBar)+2,barCCI./barMaxCCI,opts.barWidth,"EdgeColor","none","FaceColor","flat");
    xline(max(opts.xBar)+1,"Color",[0.5 0.5 0.5]);
    % recolor bars
    for iBar = 1:length(CCI)
        b2.CData(iBar,:) = opts.colorsCCI(iBar,:);
    end
end
xlim([0 12])
if tileInd == 5 && opts.barOpt ~= 3
    ylim([0 2])
else
    ylim([0 1])
end
ax = gca;
ax.Clipping = "off";
box off
% recolor bars
for iBar = 1:length(CCI)
    b.CData(iBar,:) = opts.colorsCCI(iBar,:);
end

% add hatching for undefined Thoroughman bars
if isnan(barCCI(3))
    g = gca; Y = g.YLim(2);
    b2 = bar(opts.xBar(3), Y, "FaceColor","none");
    h2 = hatchfill2(b2);
    b2.EdgeAlpha = 0;
end
xticks(opts.xBar)
xticklabels(myXLabels(indsReord))
xtickangle(90)

% make title the annotation for Thoroughman & Shadmehr CCI if > 1
if CCI(4)>1
    if CCI(4)>1
        title(num2str(CCI(4)));
    end
end
end

