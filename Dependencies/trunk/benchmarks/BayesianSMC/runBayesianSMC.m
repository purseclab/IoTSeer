clear;
phi = '!<>_[0,100] []_[0,1]a';
preds.str='a';
preds.A = [1 0];
preds.b = 0;
model='stochastic_bench_fuelsys_01';
alpha=1;
beta=1;
delta=0.05;
c=0.9;

[robustnessValues,nrTests,posteriorMean,confidenceInterval] = bayesianSMC(model,phi,preds,delta,c,alpha,beta)