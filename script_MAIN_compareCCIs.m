%% Script to Compare Co-contraction Indices Using Synthetic EMG Data
% This script...
%
% Required external functions: 
%   - Chatterjee's correlation from MATLAB file exchange: 
%     https://www.mathworks.com/matlabcentral/fileexchange/112530-chaterjee-s-xi-correlation
%   - Scientific color maps: https://zenodo.org/records/8409685 or www.fabiocrameri.ch/colourmaps)
%     
% Created: 01/09/2025 HDC (from previous versions)

clear
%% Setup Options
% Define some options for number of data points and plot settings
repoFolder = "C:\Users\hanna\repos\legendary-pancake\utility\";
colors = loadSomeColorData(repoFolder+"colors\ScientificColourMaps8\");  % Change path depending on where color data is stored 
opts.colorsEMG = [colors.imola50(32,:); colors.romaO50(45,:); [145 165 200]./256;];
opts.colorsCCI = colors.lipariS([4,6,3,5,7,1],:); %[145 165 200]./256;
opts.corrColors = colors.oslo;
opts.N = 101; % number of datapoints
opts.norm = 0;  % whether to normalize synthetic EMG data... maybe take this out
opts.diffMax = 1;
N2 = 56;
% --- plot settings ---------------------
opts.yLabel = 1;  
opts.plotTotal = 0;     
opts.plotOverThresh = 0;
opts.plotCCI = 0;
opts.cciTitles = 0;
opts.barOpt = 1;            % 1: normal colored bars, 2: colored bars with black outline, 3: bars as proportion of max CCI, 4: test both
opts.xBar = linspace(1,8,6);
opts.barWidth = 0.6;
opts.plotColorLines = 0;
% ---------------------------------------

%% (1) Characterize behavior of each formula: generate surface plots
createVisualizations(opts)

%% (2) Check correlation between indices
c = checkCorrelationBetweenCCIs(opts);

%% (3) Check effects of amplitude normalization 
normResults = testEffectOfNormalization(opts,0);
makeNormalizationFigure(normResults,opts)

%% (4) Compare CCIs on synthetic data - for proposals
% Investigating ranges and values under different scenarios
% CCI = NaN(1,1,1)
for k = 1:length(opts.N)
    if isscalar(opts.N)
        [M1,M2,t] = generateSyntheticEMG(opts.N(k),1,0);
        [CCI(:,:,k),cc,maxCCI] = compareCCIsOnSyntheticEMG(t,M1,M2,opts);
    else
        [M1{k,1},M2{k,1},t{k,1}] = generateSyntheticEMG(opts.N(k),1,0);
        [CCI(:,:,k),cc,maxCCI] = compareCCIsOnSyntheticEMG(t{k,1},M1{k,1},M2{k,1},opts);
    end
    
end

%% --- LOCAL FUNCTIONS ----------------------------------------------------
function myColors = loadSomeColorData(colorFolder)
load(colorFolder+"corkO\DiscretePalettes\corkO50.mat")
load(colorFolder+"imola\DiscretePalettes\imola50.mat")
load(colorFolder+"lipari\CategoricalPalettes\lipariS.mat")
load(colorFolder+"managua\DiscretePalettes\managua50.mat")
load(colorFolder+"navia\DiscretePalettes\navia50.mat")
load(colorFolder+"romaO\DiscretePalettes\romaO50.mat")
load(colorFolder+"oslo\oslo.mat")
myColors = struct("corkO50",corkO50,"imola50",imola50,"lipariS",lipariS,"managua50",managua50,"navia50",navia50,"romaO50",romaO50,"oslo",oslo);

end