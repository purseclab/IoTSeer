function y = calSound(disSoundSource,configSoundSource)

dis0=configSoundSource(1);%distance in configuration
db0=configSoundSource(2);%db in configuration


y=db0-log2(disSoundSource/dis0)*6;
