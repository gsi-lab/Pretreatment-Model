%COST FUNCTION FOR PARAMETER ESTIMATION
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function residuals = CostFun(Data,Stats,parmin,par,parindex,compindex,datindex)


addpath("../model_mechanistic")
% 1. Initialization
time = Stats(:,2);
stats = Stats(:,[1,3]);
par(parindex) = parmin;
[~,~,~,x0] = initcond_estimation_initial();
len = length(datindex);

% 2. Create linspaces for t for the ODE to solve
for i=1:len
    tspans(i,:) = linspace(0,time(datindex(i)),5);
end

% 3. Solve ODE
results = [];
options = odeset('RelTol',1e-7,'AbsTol',1e-8,'Nonnegative',(1:12));

for i=1:len
    [~,y] = ode15s(@pretreatment_kinetics,tspans(i,:),x0,options,par,stats(datindex(i),:));
    y=y(end,:);
    results = [results;y];
end

% 4. Calculate residuals
Error = results(:,compindex) - Data(datindex,:);

residuals = Error(:);

       
end

