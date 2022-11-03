clear
clc


cd('house_model')



%Env parameters init
temperatureHumidityParametersInit;
humidifier1Init;

startHumidifier=60;
timeLengthHumidifier=20*60;

sim('humidifier_humModel.mdl');

rhList=ans.rh;

 for nn=0: 1: 16
 rhList2(:,nn+1)=rhList(:);
end




 
 cd('..')
% csvwrite('humidifier_hum.csv',rhList2);