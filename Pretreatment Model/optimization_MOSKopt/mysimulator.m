%FUNCTION HANDLE
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function output = mysimulator(x,xu,pu,p)
%% input
addpath("../model_mechanistic")

x0 = initcond_pretreatment_moskopt(xu);

T = x(1);
t = x(2);
ac = x(3);


%% simulation
stats = [T ac];
tspan = linspace(0,t,100);

par = p.pars;
par(9:16) = pu;

options = odeset('RelTol',1e-7,'AbsTol',1e-8);
[~,y] = ode15s(@pretreatment_kinetics,tspan,x0,options,par,stats);


%% output

obj = y(end,2);

ccon = circlecon([x(1),x(2),x(3)]);

output = [-obj, y(end,9) - p.clims(1), y(end,11) - p.clims(2), ccon - p.clims(3)];

end

function ceq = circlecon(x)

ceq = abs(x(1)-173)/13 + abs(x(2)-18)/8 + abs(x(3)-1.25)/0.45;
end

