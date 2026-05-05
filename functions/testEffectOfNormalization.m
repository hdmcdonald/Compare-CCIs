function normResults = testEffectOfNormalization(opts)
% Function to test effect of normalization choices on CCI. 
% The function "generateSyntheticEMG" generates 15 pairs of synthetic EMG
% in varying shapes using a defined maximum amplitude. Here, we call
% generateSyntheticEMG three times, one for each of three maximum
% amplitudes: 
%   - 1.4   representing non-normalized EMG
%   - 1     representing within-task normalized EMG
%   - 0.6   representing EMG normalized to a maximum contraction
% 
% Inputs:
%   - opts - options structure defined in script_MAIN_compareCCIs. Here we 
%            use opts.N to define the number of time points used when
%            generating synthetic EMG
% Ouptputs:
%   - normResults - 3x1 structure containing synthetic EMG and
%                  co-contraction results for each maximum amplitude
%                  (see outputs of generateSyntheticEMG and
%                  compareCCIsOnSyntheticEMG for explanation of columns)
%   - also generates many plots of all synthetic EMG generated
%
% Functions Called: 
%   - generateSyntheticEMG
%   - compareCCIsOnSyntheticEMG
%
% Created: Hannah D. Carey 01/09/2025

% CCI -> n scenarios/"trials" x n index x n max amps

maxAmps = 0.6:0.4:1.4;
N = length(maxAmps);

% generate synthetic EMG for different maximum amplitudes
% USE SAME MAXIMUM AMPLITUDE FOR BOTH MUSCLES - this plot was not included
% in the paper
for k = 1:N
    [M1{k,1},M2{k,1},t{k,1}] = generateSyntheticEMG(opts.N,maxAmps(k),0);
    [CCI(:,:,k),cc(:,:,k),maxCCI(:,:,k)] = compareCCIsOnSyntheticEMG(t{k,1},M1{k,1},M2{k,1},opts);
    sgtitle("Max Amp = "+string(num2str(maxAmps(k))))
end
% Uncomment this if you only want to see the plots for one muscle changing amplitude
% close all

% generate synthetic EMG for different maximum amplitudes
% USE MAXIMUM AMPLITUDE FOR MUSCLE 1 ONLY 
% max amplitude for muscle 2 is fixed at 1
for k = 1:N
    [M1_2{k,1},M2_2{k,1},t_2{k,1}] = generateSyntheticEMG(opts.N,maxAmps(k),1);
    [CCI_2(:,:,k),cc_2(:,:,k),maxCCI_2(:,:,k)] = compareCCIsOnSyntheticEMG(t_2{k,1},M1_2{k,1},M2_2{k,1},opts);
    sgtitle("V2: Max Amp = "+string(num2str(maxAmps(k))))
end
clear k
normResults = struct("M1",M1,"M2",M2,"CCI",CCI,"cc",cc,"maxCCI",maxCCI,...
    "M1_2",M1_2,"M2_2",M2_2,"CCI_2",CCI_2,"cc_2",cc_2,"maxCCI_2",maxCCI_2);

maxAmps = num2cell(maxAmps');
[normResults(:).maxAmps] = deal(maxAmps{:,:});

end