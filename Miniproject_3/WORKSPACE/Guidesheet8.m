close all;
clear all;
clc
load('Data.mat')

%% Partitioning the dataset: we take the FIRST 5% of the data as a training set
% and the 95% remaining as test set (5% means 643 timesteps)

train_set = Data(1:643,:);
test_set = Data(644:12862,:);

xtr = PosX(1:643); % Target to be regressed, train set
xte = PosX(644:12862); % Target to be regressed, test set
ytr = PosY(1:643); % Target to be regressed, train set
yte = PosY(644:12862); % Target to be regressed, test set

%% Lasso
lambda = logspace(-10,0,15);
[Bx, FitInfo_x] = lasso(train_set,xtr,'lambda',lambda);
[By, FitInfo_y] = lasso(train_set,ytr,'lambda',lambda);

figure;
subplot(1,2,1)
scatter(lambda,mean(Bx),12,'r','MarkerFaceColor','r')
set(gca,'xscale','log')
grid on;
title('Mean x-regression weights for lambda values','FontSize',14);
xlabel('Lambda values','FontSize',16)
ylabel('Mean weights','FontSize',16)
subplot(1,2,2)
scatter(lambda,mean(By),12,'r','MarkerFaceColor','r')
set(gca,'xscale','log')
grid on;
title('Mean y-regression weights for lambda values','FontSize',14);
xlabel('Lambda values','FontSize',16)
ylabel('Mean weights','FontSize',16)


figure;
subplot(1,2,1)
scatter(lambda,FitInfo_x.MSE,12,'b','MarkerFaceColor','b')
set(gca,'xscale','log')
grid on;
title('Mean Square Errors (MSE) on x for lambda values','FontSize',14);
xlabel('Lambda values','FontSize',16)
ylabel('MSE','FontSize',16)
subplot(1,2,2)
scatter(lambda,FitInfo_y.MSE,12,'b','MarkerFaceColor','b')
set(gca,'xscale','log')
grid on;
title('Mean Square Errors (MSE) on y for lambda values','FontSize',14);
xlabel('Lambda values','FontSize',16)
ylabel('MSE','FontSize',16)

%% Regress with lasso L1
% Find the lambda with minimal MSE (Mean Square Error)

idx = find(FitInfo_x.MSE == min(FitInfo_x.MSE)); % find minimal MSE
bestL = FitInfo_x.Lambda(idx); % find the corresponding lambda
bestIcept = FitInfo_x.Intercept(idx); % find the corresponding intercept
bestBx = Bx(:,idx); % find corresponding best weights vectors
XtestMSE = immse(xte,(test_set*bestBx+bestIcept));

idy = find(FitInfo_y.MSE == min(FitInfo_y.MSE)); % find minimal MSE
bestLy = FitInfo_y.Lambda(idy); % find the corresponding lambda
bestIcepty = FitInfo_y.Intercept(idy); % find the corresponding intercept
bestBy = By(:,idy); % find corresponding best weights vectors
YtestMSE = immse(yte,(test_set*bestBy+bestIcepty));
