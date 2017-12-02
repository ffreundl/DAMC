close all;
clear all;
clc
load('Data.mat')

% 'Data' description: on 'lines': 12862 time-windows of 50ms each, adding up to
% 643.1s, which means a total experiment time of 10.71 min in total.
% Each line corresponds to a 1s span beginning at t-950 ms, with all
% neurons (the 48) being documented about its state every
% 50ms (sampling rate = 20Hz : that means that if you take the first line
% which represents t0 = t set @ 0ms up to 643100ms,
% you have, on 'columns', N1@bin1ofTimet0, N2@bin1ofTimet0,...,N48@bin1ofTimet0, with N =
% Neuron and 1,2,...,48 being the neuron identifier and bin1 being the time
% separation from t0-1sec+50ms = t0-950ms (indeed, the sequential events
% make that a movement occurs AFTER the neural spiking, which at least is
% of a duration of 100ms and which occurs at least 50-100ms before the
% movement so we have to analyse, for a given position of the arm (X0,Y0),
% the events that have occured before, so we take the event time of the
% movement t0 and we deduce 1sec and then analyse the  course of neural
% events every 50ms). If you take the second line in 'Data' (t1), you have the
% same reasonning but with a time-shifting of +50ms, so that the new
% position (X1,Y1) results from events that have occured at t1-1s, so the
% new first bin corresponds to the second been from t0 (t1-1s+50ms =
% t1-950ms, and since t1 = t0+50ms, t1-950ms = t0-900ms etc...). So in the
% end you have on x features (48 neurons * 20 timebins fo 50ms = 960 features (adding up
% to a window of analysis of 1s)) over 6431000ms.

%% Partitioning the dataset: we take the FIRST 70% of the data as a training set
% and the 30% remaining as test set (70% means 9003 timesteps)

train_set = Data(1:9003,:);
test_set = Data(9004:12862,:);

[coeff,trScore,var,testScore,mu,sigma] =pca2(train_set,test_set,1);

% trScore = trainset projected on PCs and testScore is testset projected on the same PCs

% Training the regressor

Itr = ones(9003,1);
Ite = ones(3859, 1);
FMtr = trScore;
FMte = testScore;
Xtr = [Itr FMtr]; % Trainset used by the regressor
Xte = [Ite FMte]; % Test set used by the regressor


%% For position on X

xtr = PosX(1:9003); % Target to be regressed, train set
xte = PosX(9004:12862); % Target to be regressed, test set

bx = regress(xtr,Xtr);% Learning the regressor on the training set for X

Xregtr = Xtr*bx;
Xregte = Xte*bx;

% EMS = MSE = Mean Square Error
XtrainEMS = immse(xtr,Xtr*bx); % Assessing the regressor's performance
XtestEMS = immse(xte,Xte*bx); % Assessing the regressor's performance

%% For position on Y

ytr = PosY(1:9003); % Target to be regressed, train set
yte = PosY(9004:12862); % Target to be regressed, test set

by = regress(ytr,Xtr);% Learning the regressor on training set for y

Yregtr = Xtr*by;
Yregte = Xte*by;

YtrainEMS = immse(ytr,Xtr*by); % Assessing the regressor's performance
YtestEMS = immse(yte,Xte*by); % Assessing the regressor's performance

%% Plots

close all

% Plot the X position, predicted and real, on the training set
figure; 
subplot(1,2,1)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosX(300:400))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'310', '320', '330', '340', '350', '360', '370', '380', '390', '400'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Xregtr(300:400))
title('Plot of the true and regressed x-position for the training set', 'FontSize',16)
legend('True x-position','Predicted x-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('x-position', 'FontSize', 16)

% Plot the Y position, predicted and real, on the training set
subplot(1,2,2)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosY(300:400))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'310', '320', '330', '340', '350', '360', '370', '380', '390', '400'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Yregtr(300:400))
title('Plot of the true and regressed y-position for the training set', 'FontSize',16)
legend('True y-position','Predicted y-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('y-position', 'FontSize', 16)


% Plot the X position, predicted and real, on the test set
figure; 
subplot(1,2,1)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosX(10500 :10600))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'10510', '10520', '10530', '10540', '10550', '10560', '10570', '10580', '10590', '10600'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Xregte(1497:1597))
title('Plot of the true and regressed x-position for the test set', 'FontSize',16)
legend('True x-position','Predicted x-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('x-position', 'FontSize', 16)

% Plot the Y position, predicted and real, on the training set
subplot(1,2,2)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosY(10500:10600))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'10510', '10520', '10530', '10540', '10550', '10560', '10570', '10580', '10590', '10600'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Yregte(1497:1597))
title('Plot of the true and regressed y-position for the test set', 'FontSize',16)
legend('True y-position','Predicted y-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('y-position', 'FontSize', 16)

%% Second order regression

X2tr = [Itr FMtr FMtr.^2];
X2te = [Ite FMte FMte.^2];

% Training the regressors

bx2 = regress(xtr,X2tr); % Train X pos
by2 = regress(ytr, X2tr); % Train Y pos

%% On X

X2regtr = X2tr*bx2;
X2regte = X2te*bx2;

X2trainEMS = immse(xtr,X2regtr); % Assessing the regressor's performance on trainset
X2testEMS = immse(xte,X2regte); % Assessing the regressor's performance on testset

%% On Y

Y2regtr = X2tr*by2;
Y2regte = X2te*by2;

Y2trainEMS = immse(ytr,Y2regtr); % Assessing the regressor's performance on trainset
Y2testEMS = immse(yte,Y2regte); % Assessing the regressor's performance on testset

%% Plots

% Plot the X position, predicted and real, on the training set
figure; 
subplot(1,2,1)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosX(300:400))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'310', '320', '330', '340', '350', '360', '370', '380', '390', '400'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(X2regtr(300:400))
title('Plot of the true and 2nd-order regressed x-position for the training set', 'FontSize',14)
legend('True x-position','Predicted x-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('x-position', 'FontSize', 16)

% Plot the Y position, predicted and real, on the training set
subplot(1,2,2)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosY(300:400))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'310', '320', '330', '340', '350', '360', '370', '380', '390', '400'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Y2regtr(300:400))
title('Plot of the true and 2n-order regressed y-position for the training set', 'FontSize',14)
legend('True y-position','Predicted y-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('y-position', 'FontSize', 16)


% Plot the X position, predicted and real, on the test set
figure; 
subplot(1,2,1)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosX(10500 :10600))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'10510', '10520', '10530', '10540', '10550', '10560', '10570', '10580', '10590', '10600'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(X2regte(1497:1597))
title('Plot of the true and 2nd-order regressed x-position for the test set', 'FontSize',14)
legend('True x-position','Predicted x-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('x-position', 'FontSize', 16)

% Plot the Y position, predicted and real, on the training set
subplot(1,2,2)
hold on; grid on;
xlim([1 100])
% plot(smooth(PosX(300:400))) % Smooth oder nicht?
plot(PosY(10500:10600))
xticks([10 20 30 40 50 60 70 80 90 100])
xticklabels({'10510', '10520', '10530', '10540', '10550', '10560', '10570', '10580', '10590', '10600'})
% plot(smooth(Xregtr(300:400)))% Smooth oder nicht?
plot(Y2regte(1497:1597))
title('Plot of the true and 2nd-order regressed y-position for the test set', 'FontSize',14)
legend('True y-position','Predicted y-position');
xlabel('Time bin [\times50ms]', 'FontSize', 16);
ylabel('y-position', 'FontSize', 16)

%% Progressively increasing the number of features: 30 steps of 32 features
k = 0;
kvec = [];
X1errTrain = [];
X1errTest = [];
Y1errTrain = [];
Y1errTest = [];

X2errTrain = [];
X2errTest = [];
Y2errTrain = [];
Y2errTest = [];

while(k<=960)
    
    FMtr = trScore(:,1:k);
    FMte = testScore(:,1:k);
    
    Xtr = [Itr FMtr]; % Trainset used by the regressor
    Xte = [Ite FMte]; % Test set used by the regressor
    X2tr = [Itr FMtr FMtr.^2]; % Same for order 2
    X2te = [Ite FMte FMte.^2];
    k
    kvec = [kvec k];
    k = k+32;
    
    % First order regression
    bx = regress(xtr,Xtr);% Learning the regressor on the training set for X
    Xregtr = Xtr*bx;
    Xregte = Xte*bx;
    XtrainEMS = immse(xtr,Xtr*bx); % Assessing the regressor's performance
    XtestEMS = immse(xte,Xte*bx); % Assessing the regressor's performance

    by = regress(ytr,Xtr);% Learning the regressor on training set for y
    Yregtr = Xtr*by;
    Yregte = Xte*by;
    YtrainEMS = immse(ytr,Xtr*by); % Assessing the regressor's performance
    YtestEMS = immse(yte,Xte*by); % Assessing the regressor's performance
    
    % Second order regressor
    bx2 = regress(xtr,X2tr); % Train X pos
    by2 = regress(ytr, X2tr); % Train Y pos
    X2regtr = X2tr*bx2;
    X2regte = X2te*bx2;
    X2trainEMS = immse(xtr,X2regtr); % Assessing the regressor's performance on trainset
    X2testEMS = immse(xte,X2regte); % Assessing the regressor's performance on testse
    Y2regtr = X2tr*by2;
    Y2regte = X2te*by2;
    Y2trainEMS = immse(ytr,Y2regtr); % Assessing the regressor's performance on trainset
    Y2testEMS = immse(yte,Y2regte); % Assessing the regressor's performance on testset

    X1errTrain = [X1errTrain XtrainEMS];
    X1errTest = [X1errTest XtestEMS];
    Y1errTrain = [Y1errTrain YtrainEMS];
    Y1errTest = [Y1errTest YtestEMS];

    X2errTrain = [X2errTrain X2trainEMS];
    X2errTest = [X2errTest X2testEMS];
    Y2errTrain = [Y2errTrain Y2trainEMS];
    Y2errTest = [Y2errTest Y2testEMS];

end
%%
Xratio1 = X1errTrain./ X1errTest; % Error ratios
Xratio2 = X2errTrain./X2errTest;
Yratio1 = Y1errTrain./ Y1errTest;
Yratio2 = Y2errTrain./Y2errTest;

%% Plots for err!

figure;
subplot(1,2,1)
hold on;
plot(kvec, X1errTrain, 'r-x')
grid on
plot(kvec, X1errTest, 'b-x')
yyaxis right
plot(kvec, Xratio1, 'k-x')
yyaxis left
ylabel('Errors','FontSize',14)
plot(kvec, X2errTrain, 'r-o')
plot(kvec,X2errTest, 'b-o')
yyaxis right
ylabel('Error ratio train/test','FontSize',14)
plot(kvec,Xratio2,'k-o')
legend('Order 1 training error', 'Order 1 testing error', 'Order 2 training error','Order 2 testing error','Order 1 error ratio', 'Order 2 error ratio','FontSize','12')
title('Order 1 and 2 regression errors for x-position','FontSize',14 )

subplot(1,2,2)
hold on;
plot(kvec, Y1errTrain, 'r-x')
grid on
plot(kvec, Y1errTest, 'b-x')
yyaxis right
ylabel('Error ratio train/test','FontSize',14)
plot(kvec, Yratio1, 'k-x')
yyaxis left
ylabel('Errors','FontSize',14)
plot(kvec, Y2errTrain, 'r-o')
plot(kvec,Y2errTest, 'b-o')
yyaxis right
plot(kvec, Yratio2, 'k-o')
legend('Order 1 training error', 'Order 1 testing error','Order 2 training error','Order 2 testing error','Order 1 error ratio','Order 2 error ratio','FontSize','12')
title('Order 1 and 2 regression errors for y-position','FontSize',14)

%% Comparison of 1 to 5 orders of regression on 300 features

FMtr300 = trScore(:,1:300);
FMte300 = testScore(:,1:300);

% Order 1 to 5 and four sets
Xtr3 = [Itr FMtr300];
Xte3 = [Ite FMte300];
X2tr3 = [Itr FMtr300 FMtr300.^2];
X2te3 = [Ite FMte300 FMte300.^2];
X3tr3 = [Itr FMtr300 FMtr300.^2 FMtr300.^3];
X3te3 = [Ite FMte300 FMte300.^2 FMte300.^3];
X4tr3 = [Itr FMtr300 FMtr300.^2 FMtr300.^3 FMtr300.^4];
X4te3 = [Ite FMte300 FMte300.^2 FMte300.^3 FMte300.^4];
X5tr3 = [Itr FMtr300 FMtr300.^2 FMtr300.^3 FMtr300.^4 FMtr300.^5];
X5te3 = [Ite FMte300 FMte300.^2 FMte300.^3 FMte300.^4 FMte300.^5];

% Training the regressors
bx300 = regress(xtr,Xtr3); % Train X pos
by300 = regress(ytr,Xtr3); % Train Y pos

bx3002 = regress(xtr,X2tr3); % Train X pos
by3002 = regress(ytr, X2tr3); % Train Y pos4

bx3003 = regress(xtr,X3tr3); % Train X pos
by3003 = regress(ytr, X3tr3); % Train Y pos

bx3004 = regress(xtr,X4tr3); % Train X pos
by3004 = regress(ytr, X4tr3); % Train Y pos

bx3005 = regress(xtr,X5tr3); % Train X pos
by3005 = regress(ytr, X5tr3); % Train Y pos

% Regression

Xregtr3 = Xtr3*bx300;
Xregte3 = Xte3*bx300;
Yregtr3 = Xtr3*by300;
Yregte3 = Xte3*by300;

X2regtr3 = X2tr3*bx3002;
X2regte3 = X2te3*bx3002;
Y2regtr3 = X2tr3*by3002;
Y2regte3 = X2te3*by3002;

X3regtr3 = X3tr3*bx3003;
X3regte3 = X3te3*bx3003;
Y3regtr3 = X3tr3*by3003;
Y3regte3 = X3te3*by3003;

X4regtr3 = X4tr3*bx3004;
X4regte3 = X4te3*bx3004;
Y4regtr3 = X4tr3*by3004;
Y4regte3 = X4te3*by3004;

X5regtr3 = X5tr3*bx3005;
X5regte3 = X5te3*bx3005;
Y5regtr3 = X5tr3*by3005;
Y5regte3 = X5te3*by3005;

XtrEMS = immse(xtr,Xregtr3); % Assessing the regressor's performance on trainset
XteEMS = immse(xte,Xregte3); % Assessing the regressor's performance on testset
YtrEMS = immse(ytr,Yregtr3); % Assessing the regressor's performance
YteEMS = immse(yte,Yregte3); % Assessing the regressor's performance

XtrEMS2 = immse(xtr,X2regtr3); % Assessing the regressor's performance on trainset
XteEMS2 = immse(xte,X2regte3); % Assessing the regressor's performance on testset
YtrEMS2 = immse(ytr,Y2regtr3); % Assessing the regressor's performance
YteEMS2 = immse(yte,Y2regte3); % Assessing the regressor's performance

XtrEMS3 = immse(xtr,X3regtr3); % Assessing the regressor's performance on trainset
XteEMS3 = immse(xte,X3regte3); % Assessing the regressor's performance on testset
YtrEMS3 = immse(ytr,Y3regtr3); % Assessing the regressor's performance
YteEMS3 = immse(yte,Y3regte3); % Assessing the regressor's performance

XtrEMS4 = immse(xtr,X4regtr3); % Assessing the regressor's performance on trainset
XteEMS4 = immse(xte,X4regte3); % Assessing the regressor's performance on testset
YtrEMS4 = immse(ytr,Y4regtr3); % Assessing the regressor's performance
YteEMS4 = immse(yte,Y4regte3); % Assessing the regressor's performance

XtrEMS5 = immse(xtr,X5regtr3); % Assessing the regressor's performance on trainset
XteEMS5 = immse(xte,X5regte3); % Assessing the regressor's performance on testset
YtrEMS5 = immse(ytr,Y5regtr3); % Assessing the regressor's performance
YteEMS5 = immse(yte,Y5regte3); % Assessing the regressor's performance

XtrErrVec = [XtrEMS XtrEMS2 XtrEMS3 XtrEMS4 XtrEMS5];
XteErrVec = [XteEMS XteEMS2 XteEMS3 XteEMS4 XteEMS5];
YtrErrVec = [YtrEMS YtrEMS2 YtrEMS3 YtrEMS4 YtrEMS5];
YteErrVec = [YteEMS YteEMS2 YteEMS3 YteEMS4 YteEMS5];

x = [1 2 3 4 5];

%% Plots
figure;
hold on
grid on
plot(x, XtrErrVec, 'r-o')
plot(x, XteErrVec, 'b-o')
plot(x, YtrErrVec, 'r-x')
plot(x, YteErrVec, 'b-x')
legend('training error on X', 'testing error on X','training error on Y','testing error on Y')
title('Evolution on training and testing error w.r.t the order of regression','FontSize',18)
xlabel('Order of regression','FontSize',16)
ylabel('Error', 'FontSize', 16)