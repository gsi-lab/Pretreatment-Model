%PRETREATMENT MODEL KINETICS FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function dydt = pretreatment_kinetics(t,y,par,stats)

R = 8.314e-3;
T = 273.15 + stats(1);
ac = stats(2);

% Reaction equations
% 1 - Xylan to Xylose
% 2 - Cellulose to Glucose
% 3 - Arabinan to Arabinose
% 4 - Acetyls to Acetic Acid
% 5 - Glucose to 5-HMF
% 6 - 5-HMF to Formic Acid
% 7 - Xylose to Furfural
% 8 - Xylose to further degradation products

r_Xyn_Xyl = par(1) * 1e10 * exp(- par(9)/(R*T)) * y(1)^2 * ac ^ par(17);
r_Cel_Glu = par(2) * 1e10 * exp(- par(10)/(R*T)) * y(3) * ac ^ par(18);
r_Arn_Ara = par(3) * 1e10 * exp(- par(11)/(R*T)) * y(5) * ac ^ par(19);
r_Act_Aac = par(4) * 1e10 * exp(- par(12)/(R*T)) * y(7) * ac ^ par(20);
r_Glu_HMF = par(5) * 1e10 * exp(- par(13)/(R*T)) * y(4) * ac ^ par(21);
r_HMF_Fac = par(6) * 1e10 * exp(- par(14)/(R*T)) * y(10) * ac ^ par(22);
r_Fur = par(7) * 1e10 * exp(- par(15)/(R*T)) * y(2) * ac * par(23);
r_Deg = par(8) * 1e10 * exp(- par(16)/(R*T)) * y(2) * ac * par(24);


% Variables & Derivatives
% definition of process variables:^1
% 1 - Xylan (Xyn) 2 - Xylose (Xyl)
% 3 - Cellulose (Cel) 4 - Glucose (Glu)
% 5 - Arabinan (Arn) 6 - Arabinose (Ara)
% 7 - Acetyls (Act) 8 - Formic Acid (Fac) 9 - Acetic Acid (Aac)
% 10 - 5HMF (HMF)  11 - Furfural (Fur)

dydt(1,1) = - r_Xyn_Xyl;
dydt(2,1) = 1.136 * r_Xyn_Xyl - r_Fur - r_Deg;
dydt(3,1) = - r_Cel_Glu;
dydt(4,1) = 1.111 * r_Cel_Glu - r_Glu_HMF;
dydt(5,1) = - r_Arn_Ara;
dydt(6,1) = 1.136 * r_Arn_Ara - r_Fur;
dydt(7,1) = - r_Act_Aac;
dydt(8,1) = r_HMF_Fac;
dydt(9,1) = 1.364 * r_Act_Aac;
dydt(10,1) = r_Glu_HMF - r_HMF_Fac;
dydt(11,1) = r_Fur;
dydt(12,1) = r_Deg;

