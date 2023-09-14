%OPTIMIZATION WITH MECHANISTIC MODEL FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clear; clc;

%% Optimization using Multi-Start
lbs = [173,18,0.5];
ubs = [195,30,2.0];
x0 = [186, 26, 0.8];

fun = @(X) -pretreatment_model_evaluation(X);
cons = @circlecon;
opts = optimoptions('fmincon','Display','None','Algorithm','sqp');

problem  = createOptimProblem('fmincon','x0',x0,'lb',lbs,'ub',ubs,...
          'objective',fun,'nonlcon',cons,'options',opts);

ms       = MultiStart('UseParallel',false,'Display','none'); % 'UseParallel',true,'Display','none'
[x,fval,exitflag,output] = run(ms,problem,100)

%% Circle constraint
function [c,ceq] = circlecon(x)

c = abs((x(1)-173)/13) + abs((x(2)-18)/8) + abs((x(3)-1.25)/0.45) - 1.69;
ceq = [];

end