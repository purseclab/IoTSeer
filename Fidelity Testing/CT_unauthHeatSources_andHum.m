clear
clc

cd('house_model')

%Env parameters init
temperatureHumidityParametersInit;


coffeeDiffTemp=50;
ovenDiffTemp=30;
dryerDiffTemp=20;
pCookerDiffTemp=30;



%time
%time set
%startCoffee=0;
timeCoffee=3*60;

%startOven=20;
timeOven=10*60;

%startDryer=40;
timeDryer=30*60;

timePCooker=15*60;
timeWasher=25*60;

washerInit;
coffeeMakerInit;
 ovenInit;
dryerInit;
   pressureCookerInit
startCoffee=60;
startOven=60;
startDryer=60;
startPCooker=60;
startWasher=60;

sim('tempModel_agg_heatSource2.mdl');

cd('..')
%%
xxCoffee=ans.Temp1';

m2=massOfVaporCoffee/roomSize/60;

for n=0: 1: 16
    %distance between coffee maker and temperature sensor
    disCoffee=getDisPos(n/4,dx);
    yyCoffee(n+1,:)=xxCoffee(disCoffee+1,:);
end
zzCoffee=yyCoffee';

% csvwrite('coffee_temp.csv',zzCoffee);

for n=0:3600
    mw=initMW;
    if n>startCoffee+timeCoffee        
        mw=initMW+m2*timeCoffee;
    else if n>startCoffee
            mw=initMW+m2*(n-startCoffee);
        end
    end
 %   for n=0: 1: 16
    humCoffee(n+1,:)=calRH(mw,temToMWS(zzCoffee(n+1,:)+initT));
end

% csvwrite('coffee_humidity.csv',humCoffee);

xxOven=ans.Temp2';

for n=0: 1: 16
    disOven=getDisPos(n/4,dx);
    yyOven(n+1,:)=xxOven(disOven+1,:);
end
zzOven=yyOven';

%temperature difference
% csvwrite('oven_temp.csv',zzOven);
%humidity RH
% csvwrite('oven_humidity.csv',calRH(initMW,temToMWS(zzOven+initT)));

xxDryer=ans.Temp3';

for n=0: 1: 16
    disDryer=getDisPos(n/4,dx);
    yyDryer(n+1,:)=xxDryer(disDryer+1,:);
end
zzDryer=yyDryer';

% csvwrite('dryer_temp.csv',zzDryer);
%humidity RH
% csvwrite('dryer_humidity.csv',calRH(initMW,temToMWS(zzDryer+initT)));


xxCooker=ans.Temp4';

for n=0: 1: 16
    disCooker=getDisPos(n/4,dx);
    yyCooker(n+1,:)=xxCooker(disCooker+1,:);
end
zzCooker=yyCooker';

% csvwrite('cooker_temp.csv',zzCooker);
%humidity RH
% csvwrite('cooker_humidity.csv',calRH(initMW,temToMWS(zzCooker+initT)));

%washer
%for dishwasher, change parameters in 'washerInit'
m1=massOfVaporWasher/roomSize/60;

for n=0:3600
    mw=initMW;
    if n>startWasher+timeWasher       
        mw=initMW+m1*timeWasher;
    else if n>startWasher
            mw=initMW+m1*(n-startWasher);
        end
    end
    for mm=0: 1: 16
    humWasher(n+1,mm+1)=calRH(mw,temToMWS(initT));
    end
end

% csvwrite('washer_humidity.csv',humWasher);