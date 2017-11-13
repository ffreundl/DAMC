close all
clear all
clc

load('dataset_ERP.mat')

%% Point 1)

[coeff, score, variance] = pca(features);

covFeat = cov(features);
covScore = cov(score);

figure;
subplot(2,1,1)
imshow(covFeat);
subplot(2,1,2)
var1 = plot(diag(covFeat)); % Plots the VARIANCE - diag of the covariance matrix - for each feature


figure; 
subplot(2,1,1)
imshow(covScore);
subplot(2,1,2)
var1 = plot(diag(covScore));

%% Compare the diagonal elements of the two covariance matrices: 
% We observe that the 

%% Point 2) 

%% Point 3)
totalVar = cumsum(variance)/sum(variance); % Stocks the values of total variance

above90 = find(totalVar > 0.9); % Stocks all numbers of PC's for which we achieve 90% of the total variance
minimalFeat = above90(1)

figure;
plot(totalVar)
grid on
hold on
x = [44 44 44 44 44 44 44 44 44 44 44];
y = [0:0.1:1];
plot(x,y,'r--')
%% Point 4)
errorRatio = 0;
i = 1; % Index for errorRatioVect
N=80 % Number of PC (scores) to be tested. CANNOT be >647
cv=cvpartition(labels,'kfold',10); % Creates 10 partitions with respected proportions
errorRatioVect = zeros(N);
for n=1:N
    
    new_PC = score(:,1:n);
    testErrorVect=[];
    trainingErrorVect = []; 

    
   for k=1:10
    training_set = new_PC(cv.training(k),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = new_PC(cv.test(k),:); % pareil avec test
    
    training_labels = labels(cv.training(k),1);
    test_labels = labels(cv.test(k),1);
    
    classifier = fitcdiscr(training_set, labels(cv.training(k),:), 'discrimtype', 'diaglinear');
    yhat_training = predict(classifier, training_set);
    yhat_test = predict(classifier, test_set);
    
    training_error = classerror(training_labels, yhat_training);
    test_error = classerror(test_labels, yhat_test);
  
    testErrorVect = [testErrorVect test_error];
    trainingErrorVect = [trainingErrorVect training_error];
    
end

meanTrainError = mean(trainingErrorVect);
meanTestError = mean(testErrorVect);

errorRatio = meanTrainError/meanTestError; 
errorRatioVect(i) = errorRatio;
N = N+1;
i = i+1;
end
figure;
plot(errorRatioVect,'k--')
grid on;

i
N

%% Point 5) Using zscore before 

zfeat = zscore(features);

[coeffBefore, scoreBefore, varianceBefore] = pca(zfeat);

coeffAfter = zscore(coeff);
scoreAfter = zscore(score);
varianceAfter = zscore(variance);

figure;
imshow(covScore)
figure;
imshow(cov(scoreBefore))
figure;
imshow(cov(scoreAfter))
% Normalising before = no change because:
% Normalising after = changes because: 

%% Part2. Point 6-7)

%we choose to use a pre-selected subset of feature since the wrapper
%methods are very expensive 
subfeatures=features(:,1:24:2400); % Selects 100 features


cp = cvpartition(labels,'kfold',10);


% The forward feature selection start by selecting the best performing
% single feature in term of classification error. Then all pairwise
% combinations of the remaining features the already selected one are
% tested. The one with the best performance is selected. Then we add a
% third features that leads to best performance. 

%The function use a criterion to evaluate the performance of a feature
%combination and stop adding features when there is no more improvements in
%the prediction criterion.

%sequentials calls cv as a parameter for the valisdation method. It perform
%the inner-loop cross-validation to dermine the optimal number of features

%fun is the function that defines the criterion used to select features and
% to determine when to stop. un uses XTRAIN and ytrain to train or fit a model, 
%then predicts values for XTEST using that model, and finally returns some measure of distance,
% or loss, of those predicted values from ytest. X corresponds to samples
% and Y to the labels.
%In the cross validation calculation for a given candidate feature set,
%sequentialfs sums the values returned by fun and divides that sum by the
%total number of test observations.

fun = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','diaglinear'), xt)));


%We used a diaglinear classifier, options corresponds to the
%characteristics of the iterative sequential search algorithm. 100
%corresponds to the maximum number of iterations allowed.
opt = statset('Display','iter','MaxIter',100);

[sel, hst] = sequentialfs(fun,subfeatures,labels,'cv',cp,'options',opt);

%Forward feature selection is a wrapper method : we use a subset of
%features and train a model using them. Bases on the results from the
%previous model we decide to add or remove feature from your subset wheras
%in filter methods you don't use any machine learning algorithms. The
%features are selected on the basis of their scores in various statistical
%test as Fisher score method. For Fisher score method we use 
% a projection of the high-dimensional sample onto a one-dimensional space
% and we maximize a function representing the difference between the
% projected class means. This represent the intra-class similarity and
% inter-classe non similarity. Forward Feature selection select a model
% studying the classerror of feature  association itteratively.

%% Part 3) Point 8) PCA + Rank

% 1) Normalisation to avoid the fact that the PCA, that's based on variance, takes too much into account few particular features that exhibit a largest variance w.r.t the others. 
% Indeed, the PCA enhances the variance and hence we would lose perhaps precious features for our model. 
% zfeat is normalised so we already have it.
% 
% 2) Ranking:

discrimIndices = rankfeat(zfeat, labels, 'fisher'); % Ranks the normalized features from best to worse 
s = 100; % Number of selected features
selectedFeatures = zfeat(:,discrimIndices(1:s)); % Selects the best s selected features

[coeffRank, scoreRank, varianceRank] = pca(selectedFeatures);

totalVarRank = cumsum(varianceRank)/sum(varianceRank); % Stocks the values of total variance

above90Rank = find(totalVarRank > 0.9); % Stocks all numbers of PC's for which we achieve 90% of the total variance
minimalFeat = above90Rank(1)

figure;
plot(totalVarRank)
grid on
hold on
x = [9 9 9 9 9 9 9 9 9 9 9];
y = [0:0.1:1];
plot(x,y,'r--')

% We obtain 49 minimal features for 90% of the total variance, following
% the total 2400 features

%% Point 9) Nestd + FFS + ClassifierSelection
subfeatures20 = features(:,1:120:2400); % Selects 20 features why not rank ??
outer = cvpartition(labels,'kfold',4);

opt = statset('Display','iter','MaxIter',100);

funLin = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','linear'), xt)));
funDiagLin = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','diaglinear'), xt)));
funDiagQuadra = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','diagquadratic'), xt)));

validationErrorVect = zeros(3,4);
modelHype=false(3,20,4);
testError=zeros(3,4);
for i=1:4
    %train
    cp_in = cvpartition(labels(outer.training(i)),'kfold',10);
    [selLin, hstLine] = sequentialfs(funLin, subfeatures20(outer.training(i), :), labels(outer.training(i)), 'cv', cp_in, 'options',opt);
    [selDiagLin, hstDiagLin] = sequentialfs(funDiagLin, subfeatures20(outer.training(i), :), labels(outer.training(i)), 'cv', cp_in, 'options',opt);
    [selDiagQuadra, hstDiagQuadra] = sequentialfs(funDiagQuadra, subfeatures20(outer.training(i), :), labels(outer.training(i)), 'cv', cp_in, 'options',opt);
    validationErrorVect(1,i) = hstLine.Crit(end);
    modelHype(1,:,i)=selLin;
    validationErrorVect(2,i) = hstDiagLin.Crit(end);
    modelHype(2,:,i)=selDiagLin;
    validationErrorVect(3,i) = hstDiagQuadra.Crit(end);
    modelHype(3,:,i)=selDiagQuadra;
    
    %test (everything, we'll keep the 4 errors of best model per 4 folds at
    %the end
    
    classifierLin=fitcdiscr(subfeatures20(outer.training(i),modelHype(1,:,i)),labels(outer.training(i)),'discrimtype','linear');
    classifierDiaglin=fitcdiscr(subfeatures20(outer.training(i),modelHype(2,:,i)),labels(outer.training(i)),'discrimtype','diaglinear');
    classifierDiagquad=fitcdiscr(subfeatures20(outer.training(i),modelHype(3,:,i)),labels(outer.training(i)),'discrimtype','diagquadratic');
    
    yhatLin=predict(classifierLin,subfeatures20(outer.test(i),modelHype(1,:,i)));
    testData=labels(outer.test(i));
    testError(1,i)=classerror(testData,yhatLin);
    
    yhatDiaglin=predict(classifierDiaglin,subfeatures20(outer.test(i),modelHype(2,:,i)));
    testError(2,i)=classerror(testData,yhatDiaglin);
    
    yhatDiagquad=predict(classifierDiagquad,subfeatures20(outer.test(i),modelHype(3,:,i)));
    testError(3,i)=classerror(testData,yhatDiagquad);
end

testErrorLin=mean(testError(1,:));
testErrorDiaglin=mean(testError(2,:));
testErrorDiagQuadra=mean(testError(3,:));
%% final step
finalTestErrors=zeros(1,4);
for u=i:4
    bestModel=find(validationErrorVect(:,u)==min(validationErrorVect(:,u)));
    finalTestErrors(u)=testError(bestModel,u);
end


    
    