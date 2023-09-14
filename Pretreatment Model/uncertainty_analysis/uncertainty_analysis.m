%UNCERTAINTY ANALYSIS FOR MECHANISTIC MODEL
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021
clear; clc;

addpath("../model_mechanistic")
addpath("../parameter_estimation_main")
addpath("../experimental_data")

%% Input Space Definition
[par,x0] = initcond_pretreatment;
load("cov_main")
load("dataPTM")

data = [Perc_Xyl; Perc_Glu; Perc_Ara; Perc_Fac; Perc_Aac; Perc_HMF; Perc_Fur]';

Stats = [Temperature; acid]';

time = time';
K = length(time);

clearvars Temperature acid

idy = [2,4,6,8,9,10,11];%3=Xyl, 5=Glu, 7=Ara, 9=Fac, 10=Aac, 11=HMF, 12=Fur
idx = [9,10,11,12,13,14,15,16];

epoints = [3,8,10,13,14,15,16];
nepoints = [1,2,4,5,6,7,9,11,12,17];

L=length(idx);
M=length(idy);


parmin = par(9:16);
pmin = parmin;
cov = CovPar;

lp = {'E_{XynXyl}', 'E_{CelGlu}', 'E_{ArnAra}', 'E_{ActAac}', ...
      'E_{GluHMF}', 'E_{HMFFac}', 'E_{Fur}', 'E_{Deg}'};

%% Input Space Sampling
N = 1000; %sampling number

mu = pmin;
sigma = cov;
sigma = (sigma + sigma.') / 2;
X = mvnrnd(mu,sigma,N); % multivariate random sampling with known covariance matrix.

[h ax] = plotmatrix(X);

%% Monte Carlo Sampling 

t = zeros(K,100,N);
y = zeros(K,100,length(idy),N);

for k=1:K
    temp = [];
    tempo = [];
    
    options=odeset('RelTol',1e-7,'AbsTol',1e-8,'Nonnegative',[1:12]);
    t0 = 0;tf = time(k); td=linspace(t0,tf,100);
    stats = Stats(k,:); % Temperature [K], Acid concentration [% m/m]

    parfor n=1:N
        parx = par;
        parx(idx) = X(n,:) ; % sample parameter space
        [tkn,ykn] = ode15s(@pretreatment_kinetics,td,x0,options,parx,stats);
        y(k,:,:,n) = ykn(:,idy);
        t(k,:,n) = tkn;
        disp(['the iteration number is : ',num2str(n)])
    end
end

%% Results
lx = {'Xylose [g/100 g]','Glucose [g/100 g]', 'Arabinose [g/100 g]', 'Formic Acid [g/100 g]',...
    'Acetic Acid [g/100 g]', '5HMF [g/100 g]', 'Furfural [g/100 g]'};
iy=[2,4,6,8,9,10,11];

yend = squeeze(y(:,end,:,:));

for m = 1:M
    figure
    hold on
    
    xlabel("Experimental Point")
    ylabel("Concentration [g/100 g biomass]")
    set(gca,'LineWidth',1,'FontSize',18)
    
    scatter(epoints, data(epoints,m), 'ro','MarkerFaceColor','r')
    scatter(nepoints, data(nepoints,m), 'ro')
    
    plot(1:K,prctile(yend(:,m,:),50,3),'b--',...
         1:K,prctile(yend(:,m,:),2.5,3),'k--',...
         1:K,prctile(yend(:,m,:),97.5,3),'k--')
     
    legend('estimated', 'not estimated', 'mean', '95%')
    
end