

%Initial Temperature
t0 = 0*ones(1,N);

%Boundary Conditions
% tL=heatSourceDiffTemp;
% tR = 0;

parameters2 = [ovenDiffTemp,0,lambda];

%init
x02=t0;

%x01(1)=tL;


%%aboutsmoke
massOfSmoke=40; %mg/min
