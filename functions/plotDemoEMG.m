function plotDemoEMG(x,Y1,Y2,opts,myTitle,colorFlag,lowColor,highColor)
% Function to plot example EMG for illustrating a co-contraction index.
% Given a "time" vector (x) and two EMG signals (Y1, Y2), plots the EMG in
% the current figure/subplot/tile and highlights low/high EMG etc.
% to indicate terms in a co-contraction index. 
%
% Inputs: 
%   - x - vector to use for plotting (x-axis, "time")
%   - Y1 - synthetic EMG 1
%   - Y2 - synthetic EMG 2
%   - opts - plot options structure defined in script_MAIN_compareCCIs
%   - myTitle - title for plot (e.g., "Falconer & Winter")
%   - colorFlag - options for color highlighting 
%          0 = no color highlighting
%          1 = highlight low and high EMG
%          2 = highlight only low EMG
%   - lowColor - RGB color to use for low EMG
%   - highColor - RGB color to use for high EMG
% Outputs: none, plots in the current figure/subplot
% 
% Created: Hannah D. Carey 01/09/2025

[minMus,minInds] = min([Y1;Y2]); maxMus = max(Y1,Y2);
hold on
if colorFlag == 0
    plot(x, Y1,"-k",'LineWidth',opts.lineWidth,"Color",0.3.*ones(1,3))
    plot(x,Y2,"--k",'LineWidth',opts.lineWidth,"Color",0.3.*ones(1,3))
elseif colorFlag == 1
    plot(x(1:128),minMus(1:128),"LineWidth",2,"Color",lowColor)
    plot(x(287:401),minMus(287:401),"LineWidth",2,"Color",lowColor)
    plot(x(128:287),minMus(128:287),"--","LineWidth",2,"Color",lowColor)
    plot(x(1:128),maxMus(1:128),"--","LineWidth",2,"Color",highColor)
    plot(x(128:287),maxMus(128:287),"-","LineWidth",2,"Color",highColor)
    plot(x(287:401),maxMus(287:401),"--","LineWidth",2,"Color",highColor)
else
    plot(x(1:128),minMus(1:128),"LineWidth",2,"Color",lowColor)
    plot(x(287:401),minMus(287:401),"LineWidth",2,"Color",lowColor)
    plot(x(128:287),minMus(128:287),"--","LineWidth",2,"Color",lowColor)
    plot(x(1:128),maxMus(1:128),"--","LineWidth",opts.lineWidth,"Color",0.3.*ones(1,3))
    plot(x(128:287),maxMus(128:287),"-","LineWidth",opts.lineWidth,"Color",0.3.*ones(1,3))
    plot(x(287:401),maxMus(287:401),"--","LineWidth",opts.lineWidth,"Color",0.3.*ones(1,3))
end
ylim(opts.ylim)
title(myTitle)
xticks([])
axis square
end