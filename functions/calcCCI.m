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

% check for any muscles that are all nan, set CCI to NaN
if all(isnan(mus1),"all") ||all(isnan(mus2),"all")
    CCI = NaN;
    cci = NaN(size(mus1));
else
    lowMus = min(mus1, mus2);    % needed for more than one method
    hiMus = max(mus1,mus2);
    totalEMG = mus1 + mus2;
    % define a time vector for integration
    tVec = linspace(0,1,size(mus1,2));

    intregralSmallerValue = trapz(tVec,lowMus);
    
    if method==1   % Falconer & Winter CCI
        integralTotal = trapz(tVec,totalEMG);
        CCI=2*intregralSmallerValue / integralTotal;
    elseif method==2  % Rudolph's CCI (amplitude-driven)
        try
            for n = 1:size(mus1,1)  

                % calculate Rudolph CCI at each time point
                for t = 1:size(mus1,2)
                    if hiMus(n,t) == 0 % if both muscles are 0 
                        cci(n,t) = 0;  % define CCI = 0 at that timepoint 
                    else
                        cci(n,t) = (lowMus(n,t)./hiMus(n,t)) .* (lowMus(n,t) + hiMus(n,t));
                    end
                end
                clear t
                
                CCI(n,1) = trapz(tVec,cci(n,:));
            end
            clear n
        catch me
            keyboard
        end
    elseif method == 3  % Frost & Unnithan

        CCI = mean(lowMus);     

    elseif method == 4  % Thoroughman & Shadmere
        effectiveContraction = hiMus - lowMus;
        wastedContraction = lowMus;
        pkEffective = max(effectiveContraction);
        if pkEffective == 0
            CCI = 0;
        else
            CCI = mean(wastedContraction./pkEffective);
        end
    elseif method == 5  % Simple Ratio 
        intregralLargerValue = trapz(tVec,hiMus);
        CCI = intregralSmallerValue/intregralLargerValue;

    end
end

end