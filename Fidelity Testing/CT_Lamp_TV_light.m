clear
clc




%Env parameters init

L0Source1=815;

L0SourceTV=400;

for i=0:16
    %distance between garbage and sound sensor
    disLightSource=i/4;
    lampList(i+1)=L0Source1/(4*pi*disLightSource*disLightSource);
    disUnauthLightSource=i/4;
    tvList(i+1)=L0SourceTV/(4*pi*disUnauthLightSource*disUnauthLightSource);
end

%csvwrite('All_Data/lamp_light.csv',lampList);

%disLightSource=i/4;
%lampList(i+1)=L0Source1/(4*pi*disLightSource*disLightSource);
%disUnauthLightSource=i/4;
%tvList(i+1)=L0SourceTV/(4*pi*disUnauthLightSource*disUnauthLightSource);

%csvwrite('tv_light.csv',tvList);








