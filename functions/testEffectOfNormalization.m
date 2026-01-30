function normResults = testEffectOfNormalization(opts, plotOpt)
% Function to test effect of normalization choices on CCI
% ...
%
% Inputs:
%   - ...
% Ouptputs:
%   - ...
% Created: Hannah D. Carey 01/09/2025
% 
% CCI -> n scenarios/"trials" x n index x n max amps
% maxAmps = 0.6:0.2:1.4;
maxAmps = 0.6:0.4:1.4;
N = length(maxAmps);
for k = 1:N
    [M1{k,1},M2{k,1},t{k,1}] = generateSyntheticEMG(opts.N,maxAmps(k),0);
    [CCI(:,:,k),cc(:,:,k),maxCCI(:,:,k)] = compareCCIsOnSyntheticEMG(t{k,1},M1{k,1},M2{k,1},opts);
    sgtitle("Max Amp = "+string(num2str(maxAmps(k))))
end
close all
%%
for k = 1:N
    [M1_2{k,1},M2_2{k,1},t_2{k,1}] = generateSyntheticEMG(opts.N,maxAmps(k),1);
    [CCI_2(:,:,k),cc_2(:,:,k),maxCCI_2(:,:,k)] = compareCCIsOnSyntheticEMG(t_2{k,1},M1_2{k,1},M2_2{k,1},opts);
    sgtitle("V2: Max Amp = "+string(num2str(maxAmps(k))))
end
clear k
%%
if plotOpt==1
    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        inds = j;
        nexttile
        plot(squeeze(CCI(inds,:,:)./maxCCI(inds,:,:))',"Marker",'.')
        if j == 1; legend(["FW";"Ru";"Un";"Th";"Tp"]); end
        xlim([0 N+1]);  xticks(1:N);  xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("normalized to theoretical max")
    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        nexttile
        inds = j;
        plot(squeeze(CCI(inds,:,:))',"Marker",'.')
        xlim([0 N+1]); xticks(1:N); xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("just CCI")
    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        nexttile
        inds = j;
        plot(squeeze(maxCCI(inds,:,:))',"Marker",'.')
        xlim([0 N+1]); xticks(1:N); xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("theoretical max CCI")

    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        inds = j;
        nexttile
        plot(squeeze(CCI_2(inds,:,:)./maxCCI_2(inds,:,:))',"Marker",'.')
        if j == 1; legend(["FW";"Ru";"Un";"Th";"Tp"]); end
        xlim([0 N+1]);  xticks(1:N);  xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("normalized to theoretical max v2")
    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        nexttile
        inds = j;
        plot(squeeze(CCI_2(inds,:,:))',"Marker",'.')
        xlim([0 N+1]); xticks(1:N); xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("just CCI v2")
    figure
    tiledlayout(5,3,"TileSpacing","compact","Padding","compact")
    for j = 1:size(CCI,1)
        nexttile
        inds = j;
        plot(squeeze(maxCCI_2(inds,:,:))',"Marker",'.')
        xlim([0 N+1]); xticks(1:N); xticklabels(maxAmps);
        ylim([0 inf])
    end
    clear j
    sgtitle("theoretical max CCI v2")
end
normResults = struct("M1",M1,"M2",M2,"CCI",CCI,"cc",cc,"maxCCI",maxCCI,...
    "M1_2",M1_2,"M2_2",M2_2,"CCI_2",CCI_2,"cc_2",cc_2,"maxCCI_2",maxCCI_2);

maxAmps = num2cell(maxAmps');
[normResults(:).maxAmps] = deal(maxAmps{:,:});

end