function y = calcLineFromTriangleHeight(h,t,maxAmp)
% Function to generate a linear piecewise function where the triangle has a
% set area, given the triangle height. 
%
% Inputs: 
%   - h - triangle height
%   - t - time
% Outputs: 
%   - y - resulting function, triangle has area = 25
%
% Created: Hannah D. Carey 11/2024


% for triangle with set area A 
A = 25*maxAmp;
b = round(2*A/h);
try
    tb = t(end) - t(b); 
catch me
    keyboard
end

m = (h*100)/t(b);
c = m*tb;

y = m.*t - c;

y(y<0) = 0;

end