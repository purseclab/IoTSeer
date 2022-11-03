    
%% Parameter Definition
%clear
%clc

%fixed step
fixedStep=1;

%initial temperature
initT=60;


%size m^3
roomSize=45;

%initial mw (g/m^3)
initMW=11.9;

%Maximum distance in the room, from the heat source.
% L = sqrt(2^2+6^2);
%Thermal diffusivity of the air
alpha = 2.2*10^-5;
%The mass specific of the air
c = 718;
%Air Density
rho = 1.225;
%Time (in seconds, a sample is taken per 10 seconds)
% t = [0:10:1000];
dt = fixedStep;
tmax = 100000;
t = 0:dt:tmax;

%Distance from the heat source
xmin = 0;
xmax = sqrt(3^2+5^2);
N = 100;
dx = (xmax-xmin)/(N-1);
xx = xmin:dx:xmax;

%Should be < 1/2 for stability
lambda = alpha*dt/dx^2;





% Our equations do not consider blowing heat. 

% x = [0:0.1:L];

%%
%Total time the heat source is open
timeOn = 600;



Inc = 60;

%tL=60;




%%
%     temp1=x;
%     
%         
%     
%              for i = 1:length(xx) % for space steps
%                 if i == 1
%                     temp1(i) = tL;
%                 elseif i == length(xx)
%                     temp1(i) = tR;
%                 else 
%                     temp1(i) = temp1(i)+lambda*(temp1(i+1)-2*temp1(i)+temp1(i-1));
%                 end
%             end
%     temp1(10)=temp1(10)+1;
%     
%         if j>timeOn
%             for i = 1:length(x) % for space steps
%                 if i == 1
%                     %Maybe just make it equal to i+1 instead.
%                     if temp1(i)>tL
%                         temp1(i) = temp1(i)-(P0/(c*rho));
%                     else
%                         temp1(i) = temp1(i+1); %tL
%                     end
%                 elseif i == length(x)
%                     temp1(i) = tR;
%                 else 
%                     temp1(i) = temp1(i)+lambda*(temp1(i+1)-2*temp1(i)+temp1(i-1));
%                 end
%             end
%         else
%             for i = 1:length(x) % for space steps
%                 if i == 1
%                     temp1(i) = temp1(i)+(P0/(c*rho));
%                 elseif i == length(x)
%                     temp1(i) = tR;
%                 else 
%                     temp1(i) = temp1(i)+lambda*(temp1(i+1)-2*temp1(i)+temp1(i-1));
%                 end
%             end
%         end
