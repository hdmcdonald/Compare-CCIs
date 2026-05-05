function y = calcLineFromTriangleHeight(h,t,maxAmp)
% Function to generate a linear piecewise function where the triangle has a
% set area, given the triangle height. 
%
% Inputs: 
%   - h - triangle height
%   - t - time
% Outputs: 
%   - y - resulting function for triangle
%
% Created: Hannah D. Carey 11/2024


% for triangle with set area A 
A = 25*maxAmp;
b = round(2*A/h);
tb = t(end) - t(b); 

m = (h*100)/t(b);
c = m*tb;

y = m.*t - c;

y(y<0) = 0;

end