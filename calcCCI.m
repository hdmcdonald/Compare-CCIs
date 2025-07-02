function [CCI,cci] = calcCCI(mus1, mus2, method)
% This function calculates the co-contraction index between two EMG signals
% using a given formula
% 
% Created: Hannah D. Carey November 2024
%
% Inputs: 
%   - mus 1 & mus2 - EMG signals from muscle 1 and muscle 2 (1 x time arrays)
%   - method - flag for which calculation method to use
%       1 - Falconer & Winter
%       2 - Rudolph
%       3 - Unnithan and Frost
%       4 - Thoroughman & Shadmere
%       5 - Simple Ratio
% Outputs: 
%   - CCI - co-contraction index 
%   - cci - time series of Rudolph co-contraction

lowMus = min(mus1, mus2);    % needed for more than one method
hiMus = max(mus1,mus2);
totalEMG = mus1 + mus2;
intregralSmallerValue = trapz(lowMus);
if method==1
    integralTotal = trapz(totalEMG);
    CCI=2*intregralSmallerValue / integralTotal;
elseif method==2
    for t = 1:length(mus1)
        cci(t) = (lowMus(t)./hiMus(t)) .* (lowMus(t) + hiMus(t));
    end
    clear t
    % CCI = sum(cci,"omitmissing");
    cci(isnan(cci)) = 0;
    t = linspace(1,100,length(mus1));
    CCI = trapz(t,cci);

    
elseif method == 3
    
    CCI = mean(lowMus);
    % intregralSmallerValue = trapz(lowMus);
    % CCI = intregralSmallerValue/length(mus1);

elseif method == 4
    % Thoroughman & Shadmere
    effectiveContraction = hiMus - lowMus;
    wastedContraction = lowMus;
    pkEffective = max(effectiveContraction);
    CCI = mean(wastedContraction./pkEffective);
elseif method == 5
    % Simple Ratio (cite Seyedali et al?)
    intregralLargerValue = trapz(hiMus);
    CCI = intregralSmallerValue/intregralLargerValue;

end
end