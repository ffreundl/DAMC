close all
clear all

load('dataset_ERP.mat')
%max number of ranked features
N=50;
%different classifier method
type={'diaglinear','linear','diagquadratic'};
Kin=4;
Kout=10;
%number of models
Apo=N*numel(type);


%intermediate matrix needed for calculation, but useless for final
%assessment
testErrorIntermediate=zeros(Apo,Kout);
trainingError=zeros(Apo,Kin,Kout);
validationError=zeros(Apo,Kin,Kout);
testError=zeros(1,Kout);
optimalValidationError=zeros(Kin,Kout);
optimalTrainingError=zeros(Kin,Kout);

%number of features selected, and the type selected
Nsel=zeros(1,Kout);
typeSel=cell(1,Kout);
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
        
        for k=1:Apo
            %an intuitive idea would be to use matrix of hyperparaters,
            %but it leads to one extra for loop, the Idea here is to
            %transform the ideal matrix of N by numel(type) into a huge
            %vector of N*numel(type). We retrieve the different
            %hyperparameters using modulo algebra and truncated division.
            if(mod(k,N)==0)
                usedK=N;
            else
                usedK=mod(k,N);
            end
            
            usedType=type{fix((k-1)/50)+1};
            
            trFeatures=trainingSet(:,discrimIndices(1:usedK));
            valFeatures=validationSet(:,discrimIndices(1:usedK));
            classifier=fitcdiscr(trFeatures, trainingLabels, 'discrimtype', usedType);
            predicted=predict(classifier,valFeatures);
            validationError(k,j,i)=classerror(validationLabels,predicted);
            yhat=predict(classifier,trFeatures);
            trainingError(k,j,i)=classerror(trainingLabels,yhat);
            
            %althoug we don't know yet the best model according to
            %validation, we store all possible test errors and we'll keep
            %only the true test error (the one for the best model)
            %afterwards. This is the best alternative to a vector of
            %classifier objects.
            testFeatures=testingSet(:,discrimIndices(1:usedK));
            predictedTest=predict(classifier,testFeatures);
            testErrorIntermediate(k,i)=classerror(testingLabels,predictedTest);
        end
        
    end
    meanValidation=mean(validationError(:,:,i),2);
    argmin=find(meanValidation==min(meanValidation));
    %if find return several values, it takes the firs.
    Nsel(i)=argmin(1);
    
    typeSel{i}=type{fix((Nsel(i)-1)/50)+1};
    
    if(mod(Nsel(i),N)==0)
        Nsel(i)=N;
    else
        Nsel(i)=mod(Nsel(i),N);
    end
    
    
    
    testError(i)=testErrorIntermediate(Nsel(i),i);
    optimalValidationError(:,i)=(validationError(Nsel(i),:,i))';
    optimalTrainingError(:,i)=(trainingError(Nsel(i),:,i))';
    
    
    
end
%% result displaying

for i=1:Kout
    
    disp('the type used is');
    disp(typeSel{i});
    disp('with number of ranked features')
    disp(Nsel(i));
end
disp('mean test error is');
disp(mean(testError));



