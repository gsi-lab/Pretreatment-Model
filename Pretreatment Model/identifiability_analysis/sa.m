%LOCAL SENSITIVITY ANALYSIS FOR IDENTIFIABILITY ANALYSIS FOR DILUTE ACID PRETREATMENT MODEL OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function [t, y, dydpc,dydpf,dydpb] = sa(td,x0,ps,idx,pert,stats)

n=length(td);			% number of data points
m=length(idx);			% number of parameters

 if nargin < 4
	pert = 0.001*ones(m,1); %default perturbation 10-3
 end
 
% perform reference simulations
options=odeset('RelTol',1e-7,'AbsTol',1e-8);
%%%[t,y] = ode45(@nitmod,td,x0,options,ps);
[t,y]  =ode45(@pretreatment_kinetics,td,x0,options,ps,stats);
p=ps; %reference parameter set
[it iy]=size(y);
dydpc=zeros(n,iy,m); dp=zeros(m,1); dydpf=zeros(n,iy,m); dydpb=zeros(n,iy,m);         % initialize dydp to Zero

for j=1:m; %for each parameter
i=idx(j);
    dp(i) = pert(j) * abs(ps(i));  % parameter perturbation
    p(i)   = ps(i) + dp(i);	      % perturb parameter p(i)
    %%%[t1,y1] = ode45(@nitmod,td,x0,options,p);
    [t1,y1] = ode45(@pretreatment_kinetics,td,x0,options,p,stats);
    p(i) = ps(i) - dp(i); %backward simulation
    %%%[t2,y2] = ode45(@nitmod,td,x0,options,p);
    [t2,y2] = ode45(@pretreatment_kinetics,td,x0,options,p,stats);
    dydpc(:,:,j) = (y1-y2) ./ (2 .* dp(i));
    dydpf(:,:,j) = (y1-y) ./ dp(i);
    dydpb(:,:,j) = (y-y2) ./ dp(i);
    p(i)=ps(i); % reset parameter to its reference value
end

