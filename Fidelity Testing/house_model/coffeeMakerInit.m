

%Initial Room Temperature
t0 = 0*ones(1,N);

%Boundary Conditions
% tL=heatSourceDiffTemp;
% tR = 0;

parameters1 = [coffeeDiffTemp,0,lambda];

%init
x01=t0;

%x01(1)=tL;

%mass of vapor (g/min)
massOfVaporCoffee=10;