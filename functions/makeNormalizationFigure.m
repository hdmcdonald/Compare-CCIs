function makeNormalizationFigure(normResults, opts)
% redo this using an anonymous function to pull the nth row of each cell
M1_both = [normResults(1).M1(2,:);normResults(2).M1(2,:);normResults(3).M1(2,:)];
M2_both = [normResults(1).M2(2,:);normResults(2).M2(2,:);normResults(3).M2(2,:)];

inds = [2,11];
M1_one = {normResults(1).M1_2(inds,:);normResults(2).M1_2(inds,:);normResults(3).M1_2(inds,:)};
M2_one = {normResults(1).M2_2(inds,:);normResults(2).M2_2(inds,:);normResults(3).M2_2(inds,:)};

figure
tiledlayout(3,3)

trialInd = 2;
nexttile
hold on
for k = 1:3
    minMus = min(M2_both(k,:),M1_both(k,:));
    area(0:100,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(M1_both(k,:),"LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)
    plot(M2_both(k,:),"--k","LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)

end; clear k
title("\Delta Both Muscles")
nexttile(2)
indsCCI = [6,1,4];
tempCCI = squeeze(normResults(1).CCI(trialInd,indsCCI,:));
plot(tempCCI')
title("\Delta CCI: ratio class")
legend(["Ratio";"FW";"TH."],"Location","northwest")
xlim([0 4]); ylim([0 0.7]); xticks(1:3); 
xticklabels([]); ylabel("CCI")

nexttile(3)
indsCCI = 2:3;
tempCCI = squeeze(normResults(1).CCI(trialInd,indsCCI,:));
plot(tempCCI')
legend(["Ru";"Un"],"Location","northwest")
xlim([0 4]); ylim([0 0.7]); xticks(1:3); 
title("\Delta CCI: amp-driven class")
xticklabels([])


nexttile(4)
trialInd = 1;
plot(M2_one{1,1}(trialInd,:),"--k","LineWidth",1)
hold on
for k = 1:3
    minMus = min(M2_one{1,1}(trialInd,:),M1_one{k,1}(trialInd,:));
    area(0:100,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(M1_one{k,1}(trialInd,:),"LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)
    
end; clear k
title("\Delta M1: Inc & Dec")
nexttile
trialInd = 2;
indsCCI = [6,1,4];
tempCCI = squeeze(normResults(1).CCI_2(trialInd,indsCCI,:));
plot(tempCCI')
xlim([0 4]); ylim([0 0.7]); xticks(1:3); 
xticklabels([]); ylabel("CCI")
nexttile
indsCCI = [2:3];
tempCCI = squeeze(normResults(1).CCI_2(trialInd,indsCCI,:));
plot(tempCCI')
xlim([0 4]); ylim([0 0.7]); xticks(1:3); 
xticklabels([])

nexttile(7)
trialInd = 2;
plot(M2_one{1,1}(trialInd,:),"--k","LineWidth",1)
hold on
for k = 1:3
    minMus = min(M2_one{1,1}(trialInd,:),M1_one{k,1}(trialInd,:));
    area(0:100,minMus,"FaceAlpha",0.2,"FaceColor",opts.colorsEMG(3,:),"EdgeColor","none");  % shade overlap
    plot(M1_one{k,1}(trialInd,:),"LineWidth",1,"Color",[0.8 0.8 0.8]-0.15*k)
    
end; clear k
title("\Delta M1: Dec Only")
nexttile
trialInd = 11;
indsCCI = [6,1,4];
tempCCI = squeeze(normResults(1).CCI_2(trialInd,indsCCI,:));
plot(tempCCI')
xlim([0 4]); ylim([0 0.7])
xticks(1:3); xticklabels(num2str([0.6:0.4:1.4]'))
xlabel("max amplitude"); ylabel("CCI")
nexttile
indsCCI = [2:3];
tempCCI = squeeze(normResults(1).CCI_2(trialInd,indsCCI,:));
plot(tempCCI')
xlim([0 4]); ylim([0 0.7])
xticks(1:3);  xticklabels(num2str([0.6:0.4:1.4]'))
xlabel("max amplitude")

end