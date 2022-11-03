% This is a demo for using S-TALIRO with the Automatic Transmission
% Simulink Demo.
%
% This is a demo for falsifying the specification '!(<>r1 /\ <>r2)' which
% states that it is not the case that the vehicle speed (x1) should exceed
% 120 and that the engine speed should exceed 4500.
%
% The predicates r1 and r2 correspond to the sets R1 and R2 in the paper:
% Zhao, Q.; Krogh, B. H. & Hubbard, P. Generating Test Inputs for Embedded 
% Control Systems IEEE Control Systems Magazine, 2003, August, 49-57

% (C) G. Fainekos 2011 - Arizona State University

clear

cd('..')
cd('SystemModelsAndData')

disp(' ')
disp('This is an S-TaLiRo demo on a Simulink model of Modeling an Automatic Transmission Controller.')
disp('The goal is to find an input throttle such that:')
disp(' 1) Vehicle speed v exceeds 120km/hr')
disp(' 2) Engine speed w reaches 4500 rpm')
model = 'sldemo_autotrans_mod01';

disp(' ')
disp('The constraints on the initial conditions defined as a hypercube:')
init_cond = []

disp(' ')
disp('The constraints on the input signal defined as a range:')
input_range = [0 100]
disp(' ')
disp('The number of control points for the input signal:')
cp_array = 7

disp(' ')
disp('The specification:')
phi = '!(<>r1 /\ <>r2)' 

% Define the predicates

% x1 >= 120 
% which is represented as (-1) x1 + 0 x2 <= -120 
% or [-1 0] [x1; x2] <= -120
ii = 1;
preds(ii).str='r1';
preds(ii).A = [-1 0];
preds(ii).b = -120;

% x2 >= 4500 
% which is represented as 0 x1 + (-1) x2 <= -4500
% or [0 -1] [x1; x2] <= -4500
ii = ii+1;
preds(ii).str='r2';
preds(ii).A = [0 -1];
preds(ii).b = -4500;
preds(ii).loc = [1:7];

disp(' ')
disp('Total Simulation time:')
time = 30

disp(' ')
disp(' S-Taliro options: ')

% Create an staliro_options object with the default options:
opt = staliro_options();
% Execute only one run (experiment)
opt.runs = 1; 
% The number of tests (simulations) for the experiment
n_tests = 1000;
% Piecewise constant inputs
opt.interpolationtype = {'pconst'};
opt

disp(' ')
disp (' Select a solver to use ')
disp (' 1. Simulated Annealing Method. ')
disp (' 2. Cross Entropy Method. ' )
disp (' 3. Uniform Random Sampling. ')
disp (' 4. Genetic Algorithm (the Matlab Global Optimization Toolbox is required).')
disp (' ')
form_id = input ('Select an option (1-4): ');
if (form_id == 1)
    opt.optimization_solver = 'SA_Taliro';
else
    if (form_id == 2)
    opt.optimization_solver = 'CE_Taliro';
    else if (form_id == 3)
            opt.optimization_solver = 'UR_Taliro';
        else
            opt.optimization_solver = 'GA_Taliro';
        end
    end
end
opt.optim_params.n_tests = n_tests;

disp(' ')
disp('Running S-TaLiRo with chosen solver ...')
tic
results = staliro(model,init_cond,input_range,cp_array,phi,preds,time,opt);
runtime=toc;

runtime

disp('Displaying the results of the falsification process ...')
results.run(results.optRobIndex).bestRob

disp('Plotting the falsifying behavior ...')
figure
[T1,XT1,YT1,IT1] = SimSimulinkMdl(model,init_cond,input_range,cp_array,results.run(results.optRobIndex).bestSample(:,1),time,opt);
subplot(3,1,1)
plot(IT1(:,1),IT1(:,2))
title('Throttle')
subplot(3,1,2)
plot(T1,YT1(:,2))
hold on 
plot([0 30],[4500 4500],'r');
title('RPM')
subplot(3,1,3)
plot(T1,YT1(:,1))
hold on 
plot([0 30],[120 120],'r');
title('Speed')

cd('..')
cd('Falsification demos')


