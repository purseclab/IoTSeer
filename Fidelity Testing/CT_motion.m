clear
clc

cd('house_model')

motionSensorInit;
fixedStep=0.2;

%Env parameters init
robotDis=0.6;
%startRobot=10;
timeRobot=20;

threshold=0;
phi = '[] p';
%phi = ['[]_[0,',num2str(checkTime),'] p'];

i=1;
Pred(i).str = 'p';
Pred(i).A = 1;
Pred(i).b = threshold;

num=0;
i=0;
for startRobot=0:10:50
    sim('motion.mdl');
    i = i +1;
    robot(i) = max(ans.robotOn);
end

% disp(num);

% subplot(2,1,1)
% plot(ans.tout,ans.robotOn);
% title('vacuum')
% grid on
% subplot(2,1,2)
% plot(ans.tout,ans.motion)
% title('motion')
% grid on

cd('..')