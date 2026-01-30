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

% check for any muscles that are all nan
if all(isnan(mus1),"all") ||all(isnan(mus2),"all")
    CCI = NaN;
    cci = NaN(size(mus1));
else
    lowMus = min(mus1, mus2);    % needed for more than one method
    hiMus = max(mus1,mus2);
    totalEMG = mus1 + mus2;
    intregralSmallerValue = trapz(lowMus);
    if method==1
        integralTotal = trapz(totalEMG);
        CCI=2*intregralSmallerValue / integralTotal;
    elseif method==2
        try
            for n = 1:size(mus1,1)

                for t = 1:size(mus1,2)
                    cci(n,t) = (lowMus(n,t)./hiMus(n,t)) .* (lowMus(n,t) + hiMus(n,t));
                end
                clear t
                % CCI = sum(cci,"omitmissing");
                % cci(isnan(cci)) = 0;

                t = linspace(0,1,size(mus1,2));
                CCI(n,1) = trapz(t,cci(n,:));
            end
            clear n
        catch me
            keyboard
        end
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
end