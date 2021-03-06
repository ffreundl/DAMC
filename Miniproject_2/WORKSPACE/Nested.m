%% nested cross validation
close all
clear all

load('dataset_ERP.mat')
N=50;
Kin=4;
Kout=3;

%intermediate matrix needed for calculation, but useless for final
%assessment
testErrorIntermediate=zeros(N,Kout);
trainingError=zeros(N,Kin,Kout);
validationError=zeros(N,Kin,Kout);
testError=zeros(1,Kout);
optimalValidationError=zeros(Kin,Kout);
optimalTrainingError=zeros(Kin,Kout);

%number of features selected
Nsel=zeros(1,Kout);
outterPartition =cvpartition(labels,'kfold',Kout);

for i=1:Kout
    innerPartition=cvpartition(labels(outterPartition.training(i)),'kfold',Kin);
    testingSet=features(outterPartition.test(i),:);
    testingLabels=labels(outterPartition.test(i));
    for j = 1:Kin
        trainingSet=features(innerPartition.training(j),:);
        trainingLabels=labels(innerPartition.training(j));
        validationSet=features(innerPartition.test(j),:);
        validationLabels=labels(innerPartition.test(j));
        discrimIndices=rankfeat(trainingSet,trainingLabels,'fisher');
        
        for k=1:N
            trFeatures=trainingSet(:,discrimIndices(1:k));
            valFeatures=validationSet(:,discrimIndices(1:k));
            classifier=fitcdiscr(trFeatures, trainingLabels, 'discrimtype', 'diaglinear');
            predicted=predict(classifier,valFeatures);
            validationError(k,j,i)=classerror(validationLabels,predicted);
            yhat=predict(classifier,trFeatures);
            trainingError(k,j,i)=classerror(trainingLabels,yhat);
            
            %althoug we don't know yet the best model according to
            %validation, we store all possible test errors and we'll keep
            %only the true test error (the one for the best model)
            %afterwards. This is the best alternative to a vector of
            %classifier objects.
            testFeatures=testingSet(:,discrimIndices(1:k));
            predictedTest=predict(classifier,testFeatures);
            testErrorIntermediate(k,i)=classerror(testingLabels,predictedTest);
        end
        
    end
    meanValidation=mean(validationError(:,:,i),2);
    argmin=find(meanValidation==min(meanValidation));
    %if find return several values, it takes the smallest.
    Nsel(i)=argmin(1);
    testError(i)=testErrorIntermediate(Nsel(i),i);
    optimalValidationError(:,i)=(validationError(Nsel(i),:,i))';
    optimalTrainingError(:,i)=(trainingError(Nsel(i),:,i))';
    
    
    
end

disp(Nsel);
disp(mean(testError));
%"16 15 15 for an error of 0.2062"


%% boxplot
figure
hold on

%Matrix(:) convert the matrix into a column (or a row with')
optimalValidationErrorVec = min(optimalValidationError);
optimalTrainingErrorVec = optimalTrainingError(find(optimalValidationError == optimalValidationErrorVec));
toBePlotted=[testError';optimalValidationErrorVec';optimalTrainingErrorVec];
boxplotLabels=[ones(size(testError')); 2*ones(size(optimalValidationErrorVec'));3*ones(size(optimalTrainingErrorVec))];
            
ont=boxplot(toBePlotted,boxplotLabels);
title('Boxplot of errors over the 3 outer folds');
ylabel('Error');
xtix = {'test error','optimal validation error','optimal training error'};   % Your labels
xtixloc = [1 2 3];      % Your label locations

set(gca,'XTickMode','auto','XTickLabel',xtix,'XTick',xtixloc, 'FontSize',14);

hold off;

% NB: even if test_median is below trainig_median, we see that the
% MEANtestError seems to be slightly  higher than the MEAN trainingError, so
% that our model is stable and doesn't seem to overfit/underfit.


