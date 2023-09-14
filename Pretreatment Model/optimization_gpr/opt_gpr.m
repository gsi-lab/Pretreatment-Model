%OPTIMIZATION WITH GPR MODEL FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clear; clc;

addpath("../model_gpr")
load("GPR.mat",'myGPR')

%% Optimization using Genetic Algorithm
lb = [173,18,0.5];
ub = [195,30,2.0];

[x,fval,exitflag,output] = ga(@(X) -predict(myGPR,X),3,[],[],[],[],lb,ub,@circlecon)
 
%% Circle constraint
function [c,ceq] = circlecon(x)

c = (x(1)-173)/13 + (x(2)-18)/8 + (x(3)-1.25)/0.45 - 1.69;
ceq = [];

end
