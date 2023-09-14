%PRETREATMENT MODEL VALIDATION FOR DILUTE ACIC PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clear; clc;
addpath("../experimental_data")

%% 1. Data & Initial conditions
%  Load data, segregate data according to CCD, load initial conditions

%  1.1 Load data
load("dataPTM",'Perc_Xyl','Temperature','time','acid')
load pretreatment_pars_iax

yexpr = Perc_Xyl;
Stats = [Temperature; time; acid]';

% 1.2 Load initial conditions
[par,x0] = initcond_pretreatment();

%% 2. Calculation of output
ycalc = [];
options = odeset('RelTol',1e-7,'AbsTol',1e-8,'Nonnegative',[1:12]);

for i=1:length(Stats)
    tspan = linspace(0,Stats(i,2),10);
    stats = [Stats(i,1),Stats(i,3)];
    [~,y] = ode15s(@pretreatment_kinetics,tspan,x0,options,par,stats);
    y=y(end,2);
    ycalc = [ycalc,y];
end

%% 3. Calculate metrics
cal = [3,8,10,13,14,15,16];
val = [4,9];

calR2 = 1 - sum((yexpr(cal) - ycalc(cal)).^2) / sum((yexpr(cal) - mean(yexpr(cal))).^2);
calRMSE = sqrt(mean((ycalc(cal) - yexpr(cal)).^2));

valR2 = 1 - sum((yexpr(val) - ycalc(val)).^2) / sum((yexpr(val) - mean(yexpr(val))).^2);
valRMSE = sqrt(mean((ycalc(val) - yexpr(val)).^2));
