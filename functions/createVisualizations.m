function createVisualizations(opts)
% Function to create a visual overview of all co-contraction indices for
% manuscript...
% 
% Inputs: 
%   - opts...
% Ouptputs: none, but generates and saves a figure called XXXX
%
% Created: Hannah D. Carey 01/09/2025

lowColor = opts.colorsEMG(3,:);
highColor = opts.colorsCCI(3,:);
totalColor = [[127,162,81]./256 0.5];
randInds = randsample(30,3);
x = 0:0.01:4;
sd = 0.5; m = 2; 
coeff = (1/(sd*sqrt(2*pi)));
expCoeff = ((x-m)./sd).^2;
f = coeff.*exp(-0.5.*expCoeff);
Y1 = f + 0.1.*sin(3.*x) +0.05;
Y1(Y1<0) = 0;
expCoeff2 = ((x)./0.8).^2;
y = 0.4.*coeff.*exp(-0.5.*(((x-3.1)./0.8).^2));
y2 = 0.05.*coeff.*exp(-0.5.*(((x-2)./0.5).^2));
y3 = coeff.*exp(-0.5.*expCoeff2) ;
Y2 = y + y2 + y3;
opts.ylim = [0 1.1];
% figure
% hold on
% plot(x, Y1,'Color',opts.colorsEMG(1,:))
% plot(x,Y2)
% % plot(x,y,'Color',[0.8 0.8 0.8])
% plot(x,y2,'Color',[0.6 0.6 0.6])
% plot(x,y3,'Color',[0.4 0.4 0.4])

% area overlap
[minMus,minInds] = min([Y1;Y2]); maxMus = max(Y1,Y2);
minInds1 = find(minInds==1);

clear xMesh yMesh
[xMesh, yMesh] = meshgrid(x,0:0.05:2);
yMesh(yMesh> Y1+Y2) = NaN;

effectiveContraction = maxMus - minMus; 
wastedContraction = minMus;
pkEffective = max(effectiveContraction);
cciThSh = (wastedContraction./pkEffective);

% calculate rudolph CCI
for k = 1:length(Y1)
    if maxMus(k) == 0
        cci(k) = 0;
    else
        cci(k) = (minMus(k)./maxMus(k)) .* (minMus(k) + maxMus(k));
    end
end; clear k

opts.lineWidth = 1;
f = figure('Units','inches');
f.Position = [0.2,1,15,4];
tiledlayout(4,6,"TileSpacing","tight")

nexttile(1,[2,1])
hold on
% plot(x,max(Y1,Y2),"LineWidth",4,"Color",[opts.colorsCCI(3,:)])
plotDemoEMG(x,Y1,Y2,opts,"Simple Ratio",1,lowColor,highColor,totalColor)
title("Simple Ratio")

nexttile(2,[2,1])
plotDemoEMG(x,Y1,Y2,opts,"Falconer & Winter",1,lowColor,highColor,totalColor)
plot(x,Y1+Y2,"LineWidth",3,"Color",totalColor)

nexttile(3,[2,1])
plotDemoEMG(x,Y1,Y2,opts,"Thoroughman et al",2,lowColor,highColor,nan)
plot(x,effectiveContraction,"LineWidth",2,"Color",[highColor 0.5])

nexttile(4,[2,1])
hold on
plotDemoEMG(x,Y1,Y2,opts,"Frost & Unnithan",2,lowColor,highColor,totalColor)
yline(mean(minMus))

nexttile(5,[2,1])
plotDemoEMG(x,Y1,Y2,opts,"Rudolph et al",1,lowColor,highColor,totalColor)
plot(x,Y1+Y2,"LineWidth",3,"Color",totalColor)

nexttile(6,[2,1])
CC = calcTemporalCC(Y1, Y2, 0.1);
ccInds = find(minMus>=0.1);
yLimits = [0.96 1.04]; 
patch([x(CC),flip(x(CC))],[yLimits(1);yLimits';yLimits(2)],lowColor,"EdgeColor","none","FaceAlpha",0.3);

hold on
barh(1,x(end),0.08,"FaceColor","none")
plotDemoEMG(x,Y1,Y2,opts,"Temporal",0,lowColor,highColor,nan)
x1 = x(1:128);
xEnd = x(287:401);
minMus1 = minMus(1:128);
minMusEnd = minMus(287:401);
plot(x1(minMus1>0.1),minMus1(minMus1>0.1),"LineWidth",2,"Color",lowColor)
plot(xEnd(minMusEnd>0.1),minMusEnd(minMusEnd>0.1),"LineWidth",2,"Color",lowColor)
plot(x(128:287),minMus(128:287),"--","LineWidth",2,"Color",lowColor)
yline(0.1)

%% Slice plot of Simple Ration, Falconer, Thoroughman

figure
M2 = linspace(0,1,1000);
m1 = ones(size(M2));
for k = 1:length(M2)
    m2 = M2(k).*m1;
    ccFW(k) = calcCCI(m1,m2,1);
    ccSR(k) = calcCCI(m1,m2,5);
    ccTS(k) = calcCCI(m1,m2,4);
    
end

plot(M2,ccSR)
hold on
plot(M2,ccFW)
plot(M2,ccTS)
ylim([0 1])
xlim([0 1])
axis square; box off
legend(["SR";"FW";"TS"],Location="southeast")
title("Shape-based CCI for fixed EMG_{high}=1")
%% --- 3D Surface Plots --------------------
clear t CCi
myRange = [0 1];

colormap(flip(opts.corrColors(30:220,:)))
nexttile(13,[2,1])
fRatio = fsurf(@(m1,m2) min(m1,m2)./max(m1,m2),myRange,"EdgeColor","interp","FaceAlpha",0.6);
title("simple ratio")
xlabel("muscle 2")
ylabel("muscle1")
zlabel("CCI")
view(-21,18)
axis square

nexttile(14,[2,1])
fFW = fsurf(@(m1,m2) (2.*min(m1,m2))./(m1+m2),myRange,"EdgeColor","interp","FaceAlpha",0.6);
title("Falconer & Winter")
xlabel("muscle 2")
ylabel("muscle1")
zlabel("CCI")
axis square
view(-21,18)

nexttile(15,[2,1])
fTh = fsurf(@(m1,m2) min(m1,m2)./(max(m1,m2) - min(m1,m2)),myRange,"EdgeColor","interp","FaceAlpha",0.6);
zlim([0 10])
clim([0 10])
title("Thoroughman & Shadmehr")
xlabel("muscle 2")
ylabel("muscle1")
zlabel("CCI")
axis square
view(-21,18)

nexttile(16,[2,1])
fUn = fsurf(@(m1,m2) min(m1,m2),myRange,"EdgeColor","interp","FaceAlpha",0.6);
title("Frost")
xlabel("muscle 2")
ylabel("muscle1")
zlabel("CCI")
axis square
view(-21,18)


nexttile(17,[2,1])
fRu = fsurf(@(m1,m2) ((min(m1,m2)./max(m1,m2)).*(m1+m2)),myRange,"EdgeColor","interp","FaceAlpha",0.6);
title("Rudolph")
xlabel("muscle 2")
ylabel("muscle1")
zlabel("CCI")
axis square
view(-21,18)
exportgraphics(f,'myPlot.pdf','ContentType','vector')


end


function plotDemoEMG(x,Y1,Y2,opts,myTitle,colorFlag,lowColor,highColor,totalColor)
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