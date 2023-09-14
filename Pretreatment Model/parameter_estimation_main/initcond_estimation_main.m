%INITIAL CONDITIONS FOR PARAMETER ESTIMATION FOR MAIN ESTIMATION WITH IDENTIFIED PARAMETERS (AFTER IDENTIFIABILITY ANALYSIS)
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function [parinit, parlo, parhi, x0] = initcond_estimation_main()
% Loading parameter boundaries and initial values plus
% initial concentrations to parameter estimation

A_Xyn_Xyl = 7.2492e1; %1/s
A_Cel_Glu = 8.3404e-9; %1/s
A_Arn_Ara = 2.8249e-5; %1/s
A_Act_Aac = 1.8263e-7; %1/s
A_Glu_HMF = 6.6523e-5; %1/s
A_HMF_Fac = 1.7066e-7; %1/s
A_Fur = 2.1498e-9; %1/s
A_Deg = 2.914e-8; %1/s

E_Xyn_Xyl = 100; %kJ/mol
E_Cel_Glu = 100; %kJ/mol
E_Arn_Ara = 100; %kJ/mol
E_Act_Aac = 100; %kJ/mol
E_Glu_HMF = 100; %kJ/mol
E_HMF_Fac = 100; %kJ/mol
E_Fur = 100; %kJ/mol
E_Deg = 100; %kJ/mol

n_Xyn_Xyl = 1.3029; %-
n_Cel_Glu = 0.4594; %-
n_Arn_Ara = 0.772; %-
n_Act_Aac = 0.9038; %-
n_Glu_HMF = 0.4437; %-
n_HMF_Fac = 1.2807; %-
n_Fur = 0.043; %-
n_Deg = 0.4632;


%% Parameters
parinit = [A_Xyn_Xyl, A_Cel_Glu, A_Arn_Ara, A_Act_Aac, A_Glu_HMF, A_HMF_Fac, A_Fur, A_Deg,...
           E_Xyn_Xyl, E_Cel_Glu, E_Arn_Ara, E_Act_Aac, E_Glu_HMF, E_HMF_Fac, E_Fur, E_Deg,...
           n_Xyn_Xyl, n_Cel_Glu, n_Arn_Ara, n_Act_Aac, n_Glu_HMF, n_HMF_Fac, n_Fur, n_Deg];

parlo=[1e-9 1e-9 1e-9 1e-9 1e-9 1e-9 1e-9 1e-9,...
       30 30 30 30 30 30 10 30,...
       0 0 0 0 0 0 0 0];      
   
parhi=[1e2 1e-2 1e2 1e2 1e5 1000 100 100,...
       150 150 150 150 150 150 150 150,...
       3 3 3 3 3 3 3 3];
   
   
%% Initial concentrations
x0(1) = 0.8 * 33.555;% 1 - Xylan (Xyn) 
x0(2) = 0;% 2 - Xylose (Xyl)
x0(3) = 40.74;% 3 - Cellulose (Cel)
x0(4) = 0;% 4 - Glucose (Glu)
x0(5) = 0.1 * 33.555;% 5 - Arabinan (Arn) 
x0(6) = 0;% 6 - Arabinose (Ara)
x0(7) = 0.1 * 33.555;% 7 - Acetyls (Act) 
x0(8) = 0;% 8 - Formic Acid (Fac)
x0(9) = 0;% 9 - Acetic acid (Aac) 
x0(10) = 0;% 10 - 5-HMF (Hmf)
x0(11) = 0;% 11 - Furfural (Fur) 
x0(12) = 0;% 12 - Degradation products (Deg)
x0(12) = 0;% 12 - Degradation products (Deg)


end

