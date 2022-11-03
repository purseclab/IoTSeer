clear
clc


cd('house_model')



%Env parameters init
temperatureHumidityParametersInit;

%parameters of heater/AC
% heater2Init;
ACInit;

%inital temperature can be set here
initT=77;

startHeater=60;

sim('humidityModel_heater.mdl');

temList=ans.rh;

 for nn=0: 1: 16
 temList2(:,nn+1)=temList(:);
end


 
cd('..')
%file name
%csvwrite('heater_hum.csv',temList2);


%%

cd('house_model')

%Env parameters init
temperatureHumidityParametersInit;

%parameters of heater/AC
heater2Init;
%ACInit;

%inital temperature can be set here
initT=77;

startHeater=60;

sim('temp_heater.mdl');

cd('..')

temList=ans.Temp2;

 for nn=0: 1: 16
 temList2(:,nn+1)=temList(:);
 end

startAC = 60;
timeAC = 700;

%g/min
% REMOVE FOR HEATER
ACremove=-10;
m2=ACremove/roomSize/60;

for n=0:3600
    mw=initMW;
    if n>startAC+timeAC        
        mw=initMW+m2*timeAC;
    elseif n>startAC
            mw=initMW+m2*(n-startAC);
    end
 %   for n=0: 1: 16
    humAC(n+1,:)=calRH(mw,temToMWS(temList2(n+1,:)));
end


% csvwrite('AC_humidity.csv',humAC);



