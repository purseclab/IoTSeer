clear
clc


cd('house_model')

%[x y] means at distance x, the sound level will be y db

AC_configSoundSource=[1 62];

%TV - the speakers were at the backside, causing some errors.
TV_configSoundSource=[1 62];

%Washer
Washer_configSoundSource=[1 55];

%Garbage
Garbage_configSoundSource=[1 58];

%Dryer
Dryer_configSoundSource=[1 58];

%Lock
Lock_configSoundSource=[1 50];



for i=0:16
    %distance between device and sound sensor
    dis=i/4;
    soundList(i+1)=calSound(dis,Washer_configSoundSource);
end




cd('..')

%change file name...
% File names - AC_sound, TV_sound, Washer_sound, Dryer_sound, garbage_sound.


%csvwrite('All_Data/TV_sound.csv',soundList);