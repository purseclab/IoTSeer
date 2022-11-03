% This is a demo for using S-TALIRO with Simulink models and Cross Entropy
% as an optimization solver.
%
% Demo requirements: 
% 1. Optimization Toolbox

% (C) Georgios Fainekos 2011 - Arizona State University
% (C) Sriram Sankaranarayanan 2011 - University of Colorado, Boulder

clear

cd('..')
cd('SystemModelsAndData')

disp(' ')
disp('This is an S-TaLiRo demo on a Simulink model of 3rd order Delta-Sigma Modulator.')
disp('The goal is to find state trajectories that might reach the saturation threshold.')
disp('That is, we require that -1<=x_i<=1, for i = 1,2,3.')
disp(' ')
disp(' This demo requires a license for: ')
disp('    1. Optimization Toolbox ')
disp(' ')
disp(' Two runs will be performed using the Cross-Entropy optimization method for a maximum of 100 tests each. ')
disp(' ')
disp(' Press any key to continue ... ')

model = 'modulator_3rd_order';

disp(' ')
disp('The constraints on the input signals defined as a hypercube:')
init_cond = [-.2 .2;-.2 .2;-.2 .2] %#ok<*NOPTS>

disp(' ')
disp('The constraints on the input signal defined as a range:')
input_range = [-.5 .5]
disp(' ')
disp('The number of control points for the input signal:')
cp_array = 10

disp(' ')
disp('The specification:')
phi = '[]a';

preds.str='a';
preds.A = [1 0 0; -1 0 0; 0 1 0; 0 -1 0; 0 0 1; 0 0 -1];
preds.b = [1 1 1 1 1 1]';

disp(' ')
disp('Total Simulation time:')
time = 9

disp(' ')
disp('Create an staliro_options object with the default options:')
opt = staliro_options()
disp(' ')
disp('Change options:')

disp ('Set optimization solver to cross entropy')
opt.optimization_solver = 'CE_Taliro'
opt.runs = 2;

opt.optim_params.n_tests = 1000;
opt.optim_params.num_subdivs = 25;
opt.optim_params.num_iteration = 20;
opt.spec_space='X';

disp('Note: In this example, the specification is with respect to the state ')
disp('space of the model and not the output space. Thus we change the spec_space')
disp('property from "Y" to "X"')
opt

disp(' ')
disp('Running S-TaLiRo with CrossEntropy ...')
tic
[results, history] = staliro(model,init_cond,input_range,cp_array,phi,preds,time,opt);
toc

disp(' ')
display(['Minimum Robustness found in Run 1 = ',num2str(results.run(1).bestRob)])
display(['Minimum Robustness found in Run 2 = ',num2str(results.run(2).bestRob)])

disp(' ')
disp('Displaying trajectories in Figures 1 and 2 ...')

figure(1)
clf
[T1,XT1,YT1,IT1] = SimSimulinkMdl(model,init_cond,input_range,cp_array,results.run(1).bestSample,time,opt);
subplot(2,1,1)
plot(T1,XT1)
title('State trajectories')
subplot(2,1,2)
plot(IT1(:,1),IT1(:,2))
title('Input Signal')

figure(2)
clf
[T2,XT2,YT2,IT2] = SimSimulinkMdl(model,init_cond,input_range,cp_array,results.run(2).bestSample,time,opt);
subplot(2,1,1)
plot(T2,XT2)
title('State trajectories')
subplot(2,1,2)
plot(IT2(:,1),IT2(:,2))
title('Input Signal')

disp(' ')
disp('Displaying Simulink model for visualization. ')
open(model)

cd('..')
cd('Falsification demos')

