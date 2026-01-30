function [M1,M2,t] = generateSyntheticEMG(N,maxAmp,diffMax)
% Function to generate the main set of synthetic EMG for comparing CCIs
% This function....
% 
% Inputs: 
%   - N:        number of timepoints in synthetic EMG signals
%   - maxAmp:   maximum EMG amplitude (default = 1)
%   - diffMax:  option for whether the two muscles should have the same
%               scaling. if 1 then maxAmp only applies to muscle 1, and
%               becomes 1 for muscle 2
% Outputs: 
%   - M1 & M2:  M x N matrix containing synthetic EMG for muscle 1 and 
%               muscle 2 respectively (rows-"trial", columns-time)
% 
% Created: Hannah D. Carey 01/09/2025

% t = linspace(0,100,N);
t = linspace(0,100,N);
N2 = round(N/2);

% --- define the synthetic emg signals ----------------
% createLineWithBendPoint(t,p,y0,yP,yN)
m1A = createLineWithBendPoint(t,N2,0,0,maxAmp*100);
m1B = maxAmp.*t;
m1C = createLineWithBendPoint(t,N2,0,10,0.6*maxAmp*100);
m1Max = 100.*maxAmp.*ones(size(t));
m1Flat1 = 50.*maxAmp.*ones(size(t));
if diffMax==1
    maxAmp = 1;
end

% keyboard
% muscle 2
m2A = createLineWithBendPoint(t,N2,maxAmp*100,0,0);
m2B = 100*maxAmp-maxAmp.*t;
m2C = m1C;
m2Max = m1Max;
% same geometric area
m2g1 = calcLineFromTriangleHeight(maxAmp*1,t,maxAmp);
m2g2 = calcLineFromTriangleHeight(maxAmp*14.491/20,t,maxAmp);
m2g3 = calcLineFromTriangleHeight(maxAmp*10/20,t,maxAmp);
% increasing amplitude
m2amp1 = (0.1*maxAmp).*t;
m2amp2 = (0.25*maxAmp).*t; 
m2amp3 = (0.5*maxAmp).*t;
m2amp4 = (0.75*maxAmp).*t;
% low level activation
y2 = 0.2.*t;
switchX = 56;
m2Low2 = createLineWithBendPoint(t,switchX,0.08*100,0.08*100,maxAmp*100);
m2Low1 = m2Low2;
m2Low1(1:switchX) = 0.02*100;

% mus2Orig = 1.5.*maxAmp.*t - 100*0.75*maxAmp;%mus2Orig(mus2Orig<0) = 0;
% mn2 = mus2Orig(switchX);
% m2Low1 = mus2Orig; m2Low1(1:switchX) = mn2/4;
% m2Low2 = mus2Orig; m2Low2(1:switchX) = mn2;
    
% concatinate signals for muscle 1 and 2
M1 = [m1A; m1B; m1Max; m1C; m1B; m1Flat1;...
    m1B; m1B; m1B;...
    m1B; m1B; m1C;...
    m1B; m1B; m1Flat1];

M2 = [m2A; m2B; m2Max; m2C; m1B; m2Low1;...
    m2g1; m2g2; m2g3;...
    m2amp1; m2amp2; y2;...
    m2amp3; m2amp4; m2Low2];


end
