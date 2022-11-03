clear
clc
cd('house_model')

fixedStep=0.2;

%Env parameters init
%startLightSource=10;
timeLightSource=20;
L0Source1=815;

disLightSource=1.4;

%startUnauthSource=15;
timeUnauthSource=30;
L0SourceTV=400;

disUnauthLightSource=1.2;

threshold=50;

phi = '[] !(!p1 /\ p2)';
%phi = ['[]_[0,',num2str(checkTime),'] p'];

i=1;
Pred(i).str = 'p1';
Pred(i).A = [-1 0];
Pred(i).b = -threshold;

i=i+1;
Pred(i).str = 'p2';
Pred(i).A = [0 -1];
Pred(i).b = -threshold;

% sim('tempModel.mdl');
model='light_luminance_fal';



time = 60;
cp_array = [1 1];
input_range = [0 60;0 60];
X00=[];

opt = staliro_options();
opt.runs = 1;
%opt.SimulinkSingleOutput=1;
opt.interpolationtype = {'const'};
opt.dim_proj = [];
opt.optim_params.n_tests = 100;

results = staliro(model,X00,input_range,cp_array,phi,Pred,time,opt);

figure(1)
clf
[T1,XT1,YT1,IT1] = SimSimulinkMdl(model,X00,input_range,cp_array,results.run(1).bestSample,time,opt);
subplot(3,1,1)
plot(T1,YT1)
title('State trajectories')
grid on
subplot(3,1,2)
plot(IT1(:,1),IT1(:,2))
title('Lamp')
grid on
subplot(3,1,3)
plot(IT1(:,1),IT1(:,3))
title('TV')
grid on



% 
% comp=[ans.lampLight,ans.totLight];
% rob = dp_taliro(phi,Pred,comp,ans.tout(:,1));
% 
% disp(rob);
% 
% 
% 
% subplot(2,1,1)
% plot(ans.tout,ans.LampOn);
% title('lightSource')
% grid on
% subplot(2,1,2)
% plot(ans.tout,ans.totLight)
% title('luminance')
% grid on

cd('..')