function y = createLineWithBendPoint(t,p,y0,yP,yN)
% utility function to make a piecewise linear function with given
% parameters
%
% Created: Hannah D. Carey 
s1 = (yP - y0)./(t(p) - t(1));

s2 = (yN - yP)./(t(end) - t(p));
b2 = yN - s2*t(end);

y = NaN(size(t));
y(1:p) = s1.*t(1:p) + y0;
y(p:end) = s2.*t(p:end) + b2;


end