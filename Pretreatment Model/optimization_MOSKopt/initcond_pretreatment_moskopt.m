%INITIAL CONDITIONS FOR MOSKOPT OF PRETREATMENT MODEL FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

function x0 = initcond_pretreatment_moskopt(xu)

%% Initial concentrations
alpha = xu(1);
beta = xu(2);
gamma = 1 - alpha - beta;

x0(1) = alpha * 33.555;% 1 - Xylan (Xyn) 
x0(2) = 0;% 2 - Xylose (Xyl)
x0(3) = 40.74;% 3 - Cellulose (Cel)
x0(4) = 0;% 4 - Glucose (Glu)
x0(5) = beta * 33.555;% 5 - Arabinan (Arn) 
x0(6) = 0;% 6 - Arabinose (Ara)
x0(7) = gamma * 33.555;% 7 - Acetyls (Act) 
x0(8) = 0;% 8 - Formic Acid (Fac)
x0(9) = 0;% 9 - Acetic acid (Aac) 
x0(10) = 0;% 10 - 5-HMF (Hmf)
x0(11) = 0;% 11 - Furfural (Fur) 
x0(12) = 0;% 12 - Degradation products (Deg)


end

