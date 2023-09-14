% CALIBRATION OF GPR MODEL FOR DILUTE ACID PRETREATMENT OF WHEAT STRAW
% written by Nikolaus Vollmer, PROSYS, DTU, nikov@kt.dtu.dk, 26.03.2021

clear; clc;

addpath("../experimental_data")

% Import data
load("dataPTM",'Perc_Xyl','Temperature','time','acid')

% Fit GPR
X = array2table([Temperature;time;acid]');
y = Perc_Xyl';

myGPR  = fitrgp(X,y,'KernelFunction','exponential');
[ypred,ysd,yci] = predict(myGPR,X,'Alpha',0.05); % return 95% CI
objR2  = corr(y,ypred).^2
objRMSE = sqrt(mean((ypred-y).^2))


% plot predictions with 95%CI
xspan = linspace(1,17,17);
Y = [y ypred yci(:,1) yci(:,2)]; % Y=sortrows(Y,1,'ascend');
figure();
hold on;
plot(xspan,Y(:,1),'r.');
plot(xspan,Y(:,2));
plot(xspan,Y(:,3),'k:');
plot(xspan,Y(:,4),'k:');

% K-fold cross-validation
clear folds
nobs   = size(X,1); % number of observations
nfolds = 5; % number of folds
cvp    = cvpartition(nobs,'KFold',nfolds);

for f=1:nfolds
    f
    folds(f).X_train = X(cvp.training(f),:);
    folds(f).y_train = y(cvp.training(f),:);
    folds(f).X_test  = X(cvp.test(f),:);
    folds(f).y_test  = y(cvp.test(f),:);
    folds(f).GPR     = fitrgp(folds(f).X_train,folds(f).y_train);%,'OptimizeHyperparameters','all'); % ,'CategoricalPredictors','all', 'OptimizeHyperparameters','all'
    folds(f).trainR2 = corr(folds(f).y_train, predict(folds(f).GPR,folds(f).X_train)).^2;
    folds(f).testR2  = corr(folds(f).y_test,  predict(folds(f).GPR,folds(f).X_test)).^2;
    folds(f).trainRMSE = sqrt(mean((predict(folds(f).GPR,folds(f).X_train) - folds(f).y_train).^2));
    folds(f).testRMSE = sqrt(mean((predict(folds(f).GPR,folds(f).X_test) - folds(f).y_test).^2));    
end

fprintf('Mean training R2 over %d folds: %.4f\n',nfolds,mean([folds.trainR2]))
fprintf('Mean test R2 over %d folds: %.4f\n',nfolds,mean([folds.testR2]))
fprintf('Mean training RMSE over %d folds: %.4f\n',nfolds,mean([folds.trainRMSE]))
fprintf('Mean test RMSE over %d folds: %.4f\n',nfolds,mean([folds.testRMSE]))

save(sprintf("GPR"))