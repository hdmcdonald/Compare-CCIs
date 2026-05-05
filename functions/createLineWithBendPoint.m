function y = createLineWithBendPoint(t,p,y0,yP,yN)
% utility function to make a piecewise linear function with given
% parameters
% 
% Inputs: 
%   - t = time vector
%   - p = time point where pieces join
%   - y0 = y intercept of function
%   - yP = value of y at t = p
%   - yN = value of y at y = N (end of time vector)
% Outputs: 
%   - y = piecewise linear function
%
% Created: 2024 Hannah D. Carey 
s1 = (yP - y0)./(t(p) - t(1));

s2 = (yN - yP)./(t(end) - t(p));
b2 = yN - s2*t(end);

y = NaN(size(t));
y(1:p) = s1.*t(1:p) + y0;
y(p:end) = s2.*t(p:end) + b2;


end