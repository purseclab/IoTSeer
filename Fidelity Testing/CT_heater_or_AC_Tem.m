clear
clc


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

temList=ans.Temp2;

 for nn=0: 1: 16
 temList2(:,nn+1)=temList(:);
end


 
cd('..')
%file name
% csvwrite('heater_temp.csv',temList2);