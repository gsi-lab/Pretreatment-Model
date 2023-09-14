%MOSKOPT SOLVER SCRIPT FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clc; clear; rng(0,'twister');

addpath("../parameter_estimation_main")
addpath("../model_mechanistic")

% Load covariance matrix for uncertainty data sampling
load cov_main
[par,~] = initcond_pretreatment();

% Optimization: Define an optimization problem structure p, and call the interface to the optimizer.
p        = struct;
p.lbs    = [173, 18, 0.5];    % minimum values of states (input variables: T, t, ac)
p.ubs    = [195, 30, 2.0];    % maximum values of states (-"-)
p.x0     = [186, 26, 0.8];
p.dim    = numel(p.x0);       % dimensionality
p.m      = 250;               % # of samples for MC-based uncertainty analysis.
p.k      = 5*p.dim;           % initial design size
Nmax     = 100;               % MaxFunEval (SK iterations) 
p.clims  = [3.7048, 0.5289, 1.69];          % upper bounds of constraints on Aac and Fur

p.pars   = par;
p.cov    = CovPar;

% InitialX
Xp = lhsdesign(p.k,p.dim);
for i=1:p.dim, InitialX(:,i) = unifinv(Xp(:,i),p.lbs(i),p.ubs(i)); end 

[InitialObjectiveObservations, InitialConstraintObservations] = nk_simulate(InitialX,p);
save(sprintf('INdata'), 'InitialObjectiveObservations', 'InitialConstraintObservations');

% Prepare variables and the objective function for SK optimization.
vars=[];
for i=1:p.dim
    eval(sprintf("x%d = optimizableVariable('x%d',[%d,%d]);",i,i,p.lbs(i),p.ubs(i)));
    eval(sprintf("vars = [vars x%d];",i));
end

fun = @(xx) myObj(xx,p); 
[x,fval,results] = MOSKopt(fun,vars,'Verbose',1,...
                            'SaveEachNiters',5,...
                            'MaxObjectiveEvaluations',Nmax,...
                            'NumSeedPoints',p.k,...
                            'NumRepetitions',p.m,...
                            'InitialX',array2table(InitialX),...                            
                            'InitialObjectiveObservations',InitialObjectiveObservations,...
                            'InitialConstraintObservations',InitialConstraintObservations,...
                            'NumCoupledConstraints',3,...
                            'CoupledConstraintTolerances',1e-3*ones(1,3),... % ones(1,n) with n = number of coupled constraints
                            'InfillCriterion','mcFEI',... % ['FEI', 'mcFEI', 'cAEI']
                            'InfillSolver','particleswarm',... %  [GlobalSearch, MultiStart]
                            'UncertaintyHedge','MeanPlusSigma') % [MeanPlusSigma, UCI95, Mean, PF80]

save(sprintf("simopt_mpss"))


function [f,g,UserData] = myObj(xx,p) 
    % Handle of the black-box simulation which returns the objective and
    % the constraints observations (each with m repititions). 
    % 
    % No user modifications needed.
    
    x=[];
    for i=1:p.dim
        eval(sprintf("x = [x ; xx.x%d];",i))
    end
    [f_observations, g_observations] = nk_simulate(x',p);
  
    % means
    f = nanmean(f_observations,2); 
    g = cellfun(@(X) nanmean(X,2), g_observations ,'UniformOutput',false); 
    
    UserData.ObjectiveObservations    = f_observations; % will be used for FVarTrain
    UserData.ConstraintObservations   = g_observations; % will be used for GVarTrain
end

