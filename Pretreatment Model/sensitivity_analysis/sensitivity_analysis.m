%SENSITIVITY ANALYSIS FOR MECHANISTIC MODEL
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

clear; clc;

addpath("../model_mechanistic")
addpath("../easyGSA")

%% Parameters, Input Space

[par,x0] = initcond_pretreatment;
idy = [2,4,6,8,9,10,11];
K=length(idy);

N=2000; %sampling number
M=3;    %input number

% LHS Uniform Sampling
names = ["T","t","ac"];
lo = [173, 18, 0.5];
hi = [195, 30, 2.0];

InputSpace = {'ParNames',names,'LowerBounds',lo,'UpperBounds',hi};

%% Alternative
Silist = zeros(K,M);
STilist = zeros(K,M);

for k=1:K
    [Si,STi,results] = easyGSA(@(X) pretreatment_model_evaluation_sa(X,k),...
                               N, ...
                               InputSpace{:}, ...
                               'UseParallel',true,...
                               'Verbose',true)
    Silist(k,:) = Si;
    STilist(k,:) = STi;
    
end


