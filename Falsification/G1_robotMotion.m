clear
clc

cd('house_model')

motionSensorInit;
fixedStep=0.2;

%Env parameters init
robotDis=0.6;
startRobot=10;
timeRobot=20;

threshold=0;
phi = '[] p';
%phi = ['[]_[0,',num2str(checkTime),'] p'];

i=1;
Pred(i).str = 'p';
Pred(i).A = 1;
Pred(i).b = threshold;




model='motion_robot_fal';

time = 60;
cp_array = [1];
input_range = [0 60];
X00=[];

opt = staliro_options();
opt.runs = 1;
%opt.SimulinkSingleOutput=1;
opt.interpolationtype = {'const'};
opt.dim_proj = [1];
opt.optim_params.n_tests = 100;

results = staliro(model,X00,input_range,cp_array,phi,Pred,time,opt);

figure(1)
clf
[T1,XT1,YT1,IT1] = SimSimulinkMdl(model,X00,input_range,cp_array,results.run(1).bestSample,time,opt);
subplot(2,1,1)
plot(T1,YT1)
title('State trajectories')
grid on
subplot(2,1,2)
plot(IT1(:,1),IT1(:,2))
title('robot')
grid on


% sim('motion_robot.mdl');
% rob = dp_taliro(phi,Pred,ans.motion(:,1),ans.tout(:,1));
% disp(rob);
% 
%    
%     subplot(2,1,1)
% plot(ans.tout,ans.robotOn);
% title('dryer')
%  grid on
%  subplot(2,1,2)
% plot(ans.tout,ans.motion)
% title('motion')
%  grid on
 
 cd('..')