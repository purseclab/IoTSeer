

%Initial Room Temperature
t0 = 0*ones(1,N);

%Boundary Conditions
% tL=heatSourceDiffTemp;
% tR = 0;

parameters3 = [dryerDiffTemp,0,lambda];

%init
x03=t0;

%x01(1)=tL;