close all
clear all
load('dataset_ERP')
selectedFeatures=[513 1730 512 681 682 683];
selectedMethod='diagquad';

numberofPCs=numel(selectedFeatures);
Kout=10;
Kin=10;
outer=cvpartition(labels,'kfold',Kout);

newFeat=zscore(features(:,selectedFeatures));
output=[2,Kout];
validationErrors=zeros(numberofPCs);

for i=1:Kout
    inner=cvpartition(labels(outer.training(i)),'kfold',Kin);
    bestValidationError=1.1;
    bestNumber=numberofPCs+1;
    
    
    
    for j=1:Kin
        trainingFeatures=newFeat(inner.training(j),:);
        trainingLabels=labels(inner.training(j));
        [coeff,score]=pca(trainingFeatures);
        
        valFeatures=newFeat(inner.test(j),:);
        valLabels=labels(inner.test(j));
        valScore=valFeatures*coeff;
        

        
        
        for k=1:numberofPCs
            classifier=fitcdiscr(score(:,1:k),trainingLabels,'discrimtype',selectedMethod);
            valhat=predict(classifier,valScore(:,1:k));
            valError=classerror(valLabels,valhat);
            validationErrors(j)=validationErrors(j)+valError;
            
        end
        validationErrors(j)=validationErrors(j)/Kin;
        
        if
        
    end
end

