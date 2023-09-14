%PRETREATMENT MODEL SIMULATION FOR DILUTE ACIC PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

clear; clc;

%% OPERATIONAL VARIABLES, INITIAL CONDITIONS & PARAMETERS
T = 186;   % Temperature in degC [173,195]
t = 26;    % Reaction time in min  [18,30]
ac = 1;  % Acid load in wt% biomass/100  [0.5,2]

stats = [T,ac];

[pars,x0] = initcond_pretreatment();

%% SIMULATION
options = odeset('RelTol',1e-7,'AbsTol',1e-8);
tspan = linspace(0,t,100);
[~,y] = ode15s(@pretreatment_kinetics,tspan,x0,options,pars,stats);


