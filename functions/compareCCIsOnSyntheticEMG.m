function [CCI,CC,maxCCI] = compareCCIsOnSyntheticEMG(t,M1,M2,opts)
% Function to compare CCIs in different scenarios using synthetic EMG data.
% This function generates a set of synthetic EMG signals for two muscles,
% calculates CCIs for each scenario, and plots the EMG and their resulting
% CCIs. 
% 
% Inputs: 
%   - M1 & M2:  M x N matrix containing synthetic EMG for muscle 1 and 
%               muscle 2 respectively (rows-"trial", columns-time)
%   - opts:     structure containing plot settings
% Outputs: 
%   - CCI:      M x W matrix of co-contraction indices for each trial and
%               formula (rows-"trial",columns-CCI formula)
%               Column order: Falconer | Rudolph | ...
%   - CC:       X x X matrix of co-contraction over time from Rudolph's CCI
%               (rows-"trial", columns-time)
%   - maxCCI    M x W matrix containing the theoretical maximum CCI values 
%               for each "trial" (same structure as CCI, see paper text
%               for details)
%
% Created: Hannah D. Carey 01/09/2025

figure
W = 6;
tiledlayout(5,W,"TileSpacing","compact")

for k = 1:size(M1,1)
    if ~isnan(M1(k,1))
        [CCI(k,:),CC(k,:),~,maxCCI(k,:)] = generatePlotCCI(t,M1(k,:), M2(k,:), 2*k-1,opts);
    end
end
clear k

end