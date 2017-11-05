%% nested cross validation
close all
clear all

load('dataset_ERP.mat')
N=50;
Kin=4;
Kout=3;
validationError=zeros(N,Kin,Kout);
%intermediate matrix needed for calculation, but useless for final
%assessment
testErrorIntermediate=zeros(N,Kout);
trainingError=zeros(N,Kin,Kout);
testError=zeros(1,Kout);
optimalValidationError=zeros(1,Kout);
optimalTrainingError=zeros(1,Kout);

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
            validationError(k,j)=classerror(validationLabels,predicted);
            
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
    meanValidation=mean(validationError,2);
    argmin=find(meanValidation==min(meanValidation));
    %if find return several values, it takes the smallest.
    Nsel(i)=argmin(1);
    testError(i)=testErrorIntermediate(Nsel(i),i);
    optimalValidationError(i)=min(meanValidation);
    optimalTrainingError(i)=
    
    
end

            


