%PARAMETER ESTIMATION FOR INITIAL ESTIMATION WITH ALL PARAMETERS (BEFORE IDENTIFIABILITY ANALYSIS)
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clear; clc;

addpath("../experimental_data")
addpath("../model_mechanistic")

%% 1. Data & Initial conditions
%  1.1 Load data
load dataPTM

Data = [Perc_Xyl; Perc_Glu; Perc_Ara; Perc_Fac; Perc_Aac; Perc_HMF; Perc_Fur]';
Stats = [Temperature; time; acid]';

clearvars Perc_Xyl Perc_Fur Perc_Ara Perc_Aac Perc_Glu Perc_HMF Perc_Fac  Temperature time acid

[parinit, parlo, parhi, x0] = initcond_estimation_initial();
par = parinit;

%%
parindex = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24];
compindex = [2,4,6,8,9,10,11];
datindex = [3,8,10,13,14,15,16]; % only central and starpoints for quartersphere



%% 3. Estimation of Parameters
%  Set options for solvers, run estimation for all parameters
opt = optimoptions('lsqnonlin', 'display', 'iter', 'tolfun', 1.0e-09, 'tolx', 1.0e-8, 'maxfunevals', 10000,'UseParallel',true);
parmin = par(parindex);
parlo = parlo(parindex);
parhi = parhi(parindex);

[parmin,SSE,residual,~,~,~,jacobi] = lsqnonlin(@(parmin)CostFun(Data,Stats,parmin,par,parindex,compindex,datindex),parmin,parlo,parhi,opt);

par(parindex) = parmin;

%% 4. Uncertainty estimation
Jacobian(:,:) = full(jacobi);
% parmin = parmin(parindex);
% Jacobian = Jacobian(:,parindex);

%  Calculation of degrees of freedom
n = length(residual);
p = length(parindex);
dof = n - p;

%  Statistics
var = SSE/dof;                          % Variance of errors
CovPar = var*pinv(Jacobian'*Jacobian);   % Covariance of parameter estimators
stdev = sqrt(diag(CovPar));             % Standard deviation of parameter estimators
CorrPar = CovPar./(stdev*stdev');       % Correlation matrix for parameters

alpha = 0.025;                           % Significance level
tcr = tinv((1-alpha),dof);              % Critical t-dist value at alpha
ConfIntvP95 = [parmin' - stdev*tcr, parmin' + stdev*tcr]; % +-95% confidence intervals

%  Display results
sigma = stdev';
p95_lo = ConfIntvP95(:,1)';
p95_hi = ConfIntvP95(:,2)';
statistics = table(parmin',sigma',p95_lo',p95_hi')

disp('Correlation Matrix')
disp(CorrPar)

% save("pretreatment_pars_ia",'par')
% save("pretreatment_cov_ia",'CovPar')

%% Model evaluation & confidence intervals on model output
% options = odeset('RelTol',1e-7,'AbsTol',1e-8); % Set options for ODE-solver
 
time = Stats(:,2);
stats = Stats(:,[1,3]);
 
results =[];
doe = length(time);

for i =1:doe
    tspans(i,:) = linspace(0,time(i),100);
end

options = odeset('RelTol',1e-7,'AbsTol',1e-8,'Nonnegative',[1:12]);
for i=1:doe
    [~,y] = ode15s(@pretreatment_kinetics,tspans(i,:),x0,options,par,stats(i,:));
    y=y(end,:);
    results = [results;y];
end
results = results(:,compindex);


% ModelCov = Jacobian * CovPar * Jacobian';
% ModelStdev = sqrt(diag(ModelCov));
% ModelStdevreshaped = reshape(ModelStdev,doe,length(datindex));
% ModelConfIntv = [results(:,datindex) - ModelStdevreshaped*tcr,...
%                  results(:,datindex) + ModelStdevreshaped*tcr];

save("pars_initial",'pars')
save("covpar_initial",'CovPar')