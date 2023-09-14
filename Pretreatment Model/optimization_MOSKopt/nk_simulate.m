%SIMULATION FILE FOR MOSKOPT
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
function [f_observations, g_observations] = rs_simulate(X,p)
% simulates the black-box m times and returns the values of objective and constraints in row vectors.
f  = @mysimulator;
k  = size(X,1); % # of design points
d  = size(X,2); % dim
m  = p.m;

if isfield(p,'seed'), rng(p.seed,'Twister'); end

% Create large matrices for vectorized MCS
lo = [0.75, 0.1];
hi = [0.8, 0.15];

Xu = lhsdesign(m,2);
Xu = lo + Xu.*(hi-lo);

% Uncertainty from estimated parameters
mu = p.pars(9:16);
sigma = p.cov;
sigma = (sigma + sigma.') / 2;
Pu = mvnrnd(mu,sigma,p.m);



%% Run simulations
for j = 1:k        
    x = X(j,:);       

    for i=1:p.m
        xu = Xu(i,:);
        pu = Pu(i,:);
        output = mysimulator(x,xu,pu,p);
        f_observations(j,i) = output(1);
        g1_observations(j,i) = output(2);
        g2_observations(j,i) = output(3);
        g3_observations(j,i) = output(4);

    end
end
g_observations={g1_observations, g2_observations, g3_observations};

end