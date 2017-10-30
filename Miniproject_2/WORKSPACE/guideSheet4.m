close all
clear all

load('dataset_ERP.mat')
k=10;
n=30;
trainingError=zeros(n,k);
testingError=zeros(n,k);
partition =cvpartition(labels,'kfold',k);
for i =1:k
    trainingData=partition.training(i);
    discrimIndices=rankfeat(features,labels,'fisher');
    testingData=partition.test(i);
    for j=1:n
        trFeatures=features(trainingData,discrimIndices(1:j));
        classifier=fitcdiscr(trFeatures, labels(trainingData), 'discrimtype', 'diaglinear');
        yhat = predict(classifier,trFeatures);
        trainingError(j,i)=classerror(labels(trainingData),yhat);
        testFeatures=features(testingData,discrimIndices(1:j));
        test=predict(classifier,testFeatures);
        testingError(j,i)=classerror(labels(testingData),test);
    end
end
figure
ontos1=plot(trainingError,'b');
hold on
ontos2=plot(mean(trainingError,2),'b','LineWidth',2);
ontos3=plot(testingError,'r');
ontos4=plot(mean(testingError,2),'r','LineWidth',2);
title('cross-validation errors for different feature number');
ylabel('class error');
xlabel('number of features');
legend([ontos1(1),ontos2,ontos3(1),ontos4],'training error per fold','training error mean','testing error per fold','testing error mean');