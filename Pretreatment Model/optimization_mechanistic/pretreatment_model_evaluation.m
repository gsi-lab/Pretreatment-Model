%EVALUATION FUNCTION OF PRETREATMENT MODEL FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function y = pretreatment_model_evaluation(X)

addpath("../model_mechanistic")

[pars,x0] = initcond_pretreatment();

%% State variables
% 1. Temperature T
% 2. Concentration of sulfuric acid (H2SO4) ac
% other state variables are taken out of the vector
Temp = X(1);
time = X(2);
acid = X(3);

stats = [Temp, acid];

%% Time
% Time of residence
tspan = linspace(0,time,100);

%% Reaction
options = odeset('RelTol',1e-7,'AbsTol',1e-8);
[~,yend] = ode45(@pretreatment_kinetics,tspan,x0,options,pars,stats);

%% Output
y = yend(end,:);
y = y(2);

end

