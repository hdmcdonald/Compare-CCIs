function makeNormalizationFigure(normResults, opts)
% Function to make the amplitude normalization figure corresponding to
% Figure 9 in the paper
%
% Inputs: 
%   - norm results - structure output from testEffectOfNormalization
%   - opts - structure of plotting options defined in main script, used
%            here to define plot colors
% Outputs: none, but creates a figure
%
% Created: 2025 HDC (from previous versions)

t = 0:100;
% redo this using an anonymous function to pull the nth row of each cell
M1_both = [normResults(1).M1(2,:);normResults(2).M1(2,:);normResults(3).M1(2,:)];
M2_both = [normResults(1).M2(2,:);normResults(2).M2(2,:);normResults(3).M2(2,:)];

inds = [2,11];
M1_one = {normResults(1).M1_2(inds,:);normResults(2).M1_2(inds,:);normResults(3).M1_2(inds,:)};
M2_one = {normResults(1).M2_2(inds,:);normResults(2).M2_2(inds,:);normResults(3).M2_2(inds,:)};

M1A = repmat(M1_both(3,:),3,1);
M2A = [M2_one{1,1}(2,:);M1_both(1,:);M1_both(2,:)];

M1B = [M1_one{1,1}(1,:);M1_one{2,1}(1,:);M1_one{3,1}(1,:)];
M2B = repmat(M2_one{1,1}(1,:),3,1);

M1C = M1B;
M2C = repmat(M2_one{1,1}(2,:),3,1);


figure
tiledlayout(3,3)
nexttile
trialInd = 1;
plot(M2B(1,:)./100,"--k","LineWidth",1)
hold on
CCIB = nan(3,6);
for k = 1:3
    mus1 = M1B(k,:)./100;
    mus2 = M2B(k,:)./100;
    minMus = min(mus1,mus2);
    area(t,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(t, mus1,"LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)

     % Calculate CCIs
    CC = calcTemporalCC(mus1, mus2, 0.1);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = t(CC(2)) - t(CC(1));   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    % order: Simple Ratio | Falconer | Thoroughman | Rudolph | Unnithan | Temporal | 
    CCIB(k,:) = [calcCCI(mus1, mus2, 5),calcCCI(mus1, mus2, 1),calcCCI(mus1, mus2, 4),calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),CCt];

    xlim([0 100])
end; clear k
title("\Delta Muscle")
ylabel("EMG")

nexttile(2)
b1 = bar(CCIB',"FaceColor","flat");
for k = 1:3
    b1(k).CData = opts.colorsCCI;
end
clear k
ylim([0 1])
ylabel("co-contraction")

nexttile(4)
hold on
plot(t, M1A(1,:)./100,"LineWidth",1,"Color","k")
CCIA = nan(3,6);
for k = 1:3
    mus1 = M1A(k,:)./100;
    mus2 = M2A(k,:)./100;
    minMus = min(mus1,mus2);
    area(t,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(t, mus2,"--","LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)

    % Calculate CCIs
    CC = calcTemporalCC(mus1, mus2, 0.1);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = t(CC(2)) - t(CC(1));   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    % order: Simple Ratio | Falconer | Thoroughman | Rudolph | Unnithan | Temporal | 
    CCIA(k,:) = [calcCCI(mus1, mus2, 5),calcCCI(mus1, mus2, 1),calcCCI(mus1, mus2, 4),calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),CCt];

    xlim([0 100])
end; clear k
title("\Delta Smaller Muscle")
ylabel("EMG")

nexttile(5)
b2 = bar(CCIA',"FaceColor","flat");
for k = 1:3
    b2(k).CData = opts.colorsCCI;
end
clear k
ylim([0 1.5])
ylabel("co-contraction")

nexttile(7)
plot(t, M2C(1,:)./100,"--k","LineWidth",1)
hold on
CCIC = nan(3,6);
for k = 1:3
    mus1 = M1C(k,:)./100;
    mus2 = M2C(k,:)./100;
    minMus = min(mus1,mus2);
    area(t,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(t, mus1,"LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)

     % Calculate CCIs
    CC = calcTemporalCC(mus1, mus2, 0.1);
    if isnan(CC(1))     % check if any overlap exists, otherwise CCI = 0
        CCt = 0;
    else                % if overlap exists...
        CCt = t(CC(2)) - t(CC(1));   % length of overlap (# samples)
        CCt = CCt/length(mus1);  % convert to a percentage or proportion
    end
    % order: Simple Ratio | Falconer | Thoroughman | Rudolph | Unnithan | Temporal | 
    CCIC(k,:) = [calcCCI(mus1, mus2, 5),calcCCI(mus1, mus2, 1),calcCCI(mus1, mus2, 4),calcCCI(mus1, mus2, 2), calcCCI(mus1, mus2, 3),CCt];

    xlim([0 100])
end; clear k
title("\Delta Larger Muscle")
xlabel("time points"); ylabel("EMG")

nexttile(8)
b3 = bar(CCIC',"FaceColor","flat");
for k = 1:3
    b3(k).CData = opts.colorsCCI;
end
clear k b1 b2 b3
ylim([0 1])
xticklabels(["CCI_{SR}"; "CCI_{FW}"; "CCI_{TS}"; "CCI_R"; "CCI_{UF}"; "CCI_T"]);
xtickangle(60)
ylabel("co-contraction")
end