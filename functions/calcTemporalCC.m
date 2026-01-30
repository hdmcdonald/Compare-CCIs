function CC = calcTemporalCC(mus1, mus2, thresh)
% Function to calculate temporal co-contraction
%
% Inputs: 
%   - mus1 & mus2 - synthetic EMG for muscle 1 and muscle 2
%   - thresh - threshold over which to consider a muscle active
% Outputs
%   - CC - start and end indices of overlapping activity
%
% Created: Hannah D. Carey 11/2024

inds1 = find(mus1>thresh);
inds2 = find(mus2>thresh);

overlapInds = intersect(inds1,inds2);

if isempty(overlapInds)
    CC = [NaN,NaN];
else
    CC = [overlapInds(1), overlapInds(end)];
end

end