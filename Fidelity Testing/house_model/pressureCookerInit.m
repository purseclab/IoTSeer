

%Initial Room Temperature
t0 = 0*ones(1,N);

%Boundary Conditions
% tL=heatSourceDiffTemp;
% tR = 0;

parameters4 = [pCookerDiffTemp,0,lambda];

%init
xPC=t0;

%x01(1)=tL;