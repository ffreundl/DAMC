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
    discrimIndices=rankfeat(features(trainingData,:),labels(trainingData,:),'fisher');
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
title('cross-validation errors for different feature number and fisher score');
ylabel('class error');
xlabel('number of features');
legend([ontos1(1),ontos2,ontos3(1),ontos4],'training error per fold','training error mean','testing error per fold','testing error mean');

hold off

fisherOptimum =find(mean(testingError,2)==min(mean(testingError,2)));
%fisherOptimum2=find(mean(trainingError,2)==min(mean(trainingError,2)));

disp('best perf for diaglinear')
disp(fisherOptimum);
disp(min(mean(testingError,2)));

%%with fisher method
trainingError2=zeros(n,k);
testingError2=zeros(n,k);
for i =1:k
    trainingData=partition.training(i);
    discrimIndices=rankfeat(features(trainingData,:),labels(trainingData,:),'corr');
    testingData=partition.test(i);
    for j=1:n
        trFeatures=features(trainingData,discrimIndices(1:j));
        classifier=fitcdiscr(trFeatures, labels(trainingData), 'discrimtype', 'diaglinear');
        yhat = predict(classifier,trFeatures);
        trainingError2(j,i)=classerror(labels(trainingData),yhat);
        testFeatures=features(testingData,discrimIndices(1:j));
        test=predict(classifier,testFeatures);
        testingError2(j,i)=classerror(labels(testingData),test);
    end
end


figure
ontos1=plot(trainingError,'b');
hold on
%ontos are just plots, this allows to choose the color of the legends
ontos2=plot(mean(trainingError2,2),'b','LineWidth',2);
ontos3=plot(testingError2,'r');
ontos4=plot(mean(testingError2,2),'r','LineWidth',2);
title('cross-validation errors for different feature number and correlation score');
ylabel('class error');
xlabel('number of features');
legend([ontos1(1),ontos2,ontos3(1),ontos4],'training error per fold','training error mean','testing error per fold','testing error mean');

hold off


corrOptimum =find(mean(testingError2,2)==min(mean(testingError2,2)));
%corrOptimum2=find(mean(trainingError2,2)==min(mean(trainingError2,2)));


%%test different models : linear, quadratic, diagquadratic


trainingErrorLinear=zeros(n,k);
testingErrorLinear=zeros(n,k);
for i =1:k
    trainingData=partition.training(i);
    discrimIndices=rankfeat(features(trainingData,:),labels(trainingData,:),'fisher');
    testingData=partition.test(i);
    for j=1:n
        trFeatures=features(trainingData,discrimIndices(1:j));
        classifier=fitcdiscr(trFeatures, labels(trainingData), 'discrimtype', 'linear');
        yhat = predict(classifier,trFeatures);
        trainingErrorLinear(j,i)=classerror(labels(trainingData),yhat);
        testFeatures=features(testingData,discrimIndices(1:j));
        test=predict(classifier,testFeatures);
        testingErrorLinear(j,i)=classerror(labels(testingData),test);
    end
end

disp('best perf for linear')
linearOptimum =find(mean(testingErrorLinear,2)==min(mean(testingErrorLinear,2)));
disp(linearOptimum);
disp(min(mean(testingErrorLinear,2)));

%pseudoquadratic
trainingErrorQuad=zeros(n,k);
testingErrorQuad=zeros(n,k);
for i =1:k
    trainingData=partition.training(i);
    discrimIndices=rankfeat(features(trainingData,:),labels(trainingData,:),'fisher');
    testingData=partition.test(i);
    for j=1:n
        trFeatures=features(trainingData,discrimIndices(1:j));
        classifier=fitcdiscr(trFeatures, labels(trainingData), 'discrimtype', 'pseudoquadratic');
        yhat = predict(classifier,trFeatures);
        trainingErrorQuad(j,i)=classerror(labels(trainingData),yhat);
        testFeatures=features(testingData,discrimIndices(1:j));
        test=predict(classifier,testFeatures);
        testingErrorQuad(j,i)=classerror(labels(testingData),test);
    end
end

disp('best performance for pseudoquad')
quadOptimum =find(mean(testingErrorQuad,2)==min(mean(testingErrorQuad,2)));
disp(quadOptimum);
disp(min(mean(testingErrorQuad,2)));

%diagonal quadratic
trainingErrorDiagquad=zeros(n,k);
testingErrorDiagquad=zeros(n,k);
for i =1:k
    trainingData=partition.training(i);
    discrimIndices=rankfeat(features(trainingData,:),labels(trainingData,:),'fisher');
    testingData=partition.test(i);
    for j=1:n
        trFeatures=features(trainingData,discrimIndices(1:j));
        classifier=fitcdiscr(trFeatures, labels(trainingData), 'discrimtype', 'diagquadratic');
        yhat = predict(classifier,trFeatures);
        trainingErrorDiagquad(j,i)=classerror(labels(trainingData),yhat);
        testFeatures=features(testingData,discrimIndices(1:j));
        test=predict(classifier,testFeatures);
        testingErrorDiagquad(j,i)=classerror(labels(testingData),test);
    end
end

diagquadOptimum =find(mean(testingErrorDiagquad,2)==min(mean(testingErrorDiagquad,2)));
disp('best perf for diagquad');
disp(diagquadOptimum);
disp(min(mean(testingErrorDiagquad,2)));


%% random classifier
randomMeanError=zeros(1000,n);
for t=1:1000
    
    
    testingErrorRandom=zeros(n,k);
    for i =1:k
        
        %random classifier does not use the ranked feat, let's ignore that
        %for time-saving purpose
        testingData=partition.test(i);
        for j=1:n
            %training part is eliminated (random classifier does not use it
            %at all


            testFeatures=features(testingData,1);
            test=bernoulliGenerator(0.5,size(testFeatures,1) );
            testingErrorRandom(j,i)=classerror(labels(testingData),test);
        end
    end
    
    randomMeanError(t,:)=mean(testingErrorRandom,2);
end

figure
plot(randomMeanError','bx');
hold on
axis([0 31 0.30 0.70])
ylabel('error');
xlabel('number of features');
title('random classifier mean error');
hold off;
disp('best performance of random classifier is ')
disp(min(randomMeanError(:)));
%disp('the best performance for random classifier over 1000 times is');
%disp(bestPerf);


%draft of results (because it is long !!!)
%the best number of features is 20 for a perf of 0.1906 (fisher
%the best for correlation is 18 for a perf of 0.1876
%for linear: 23 0.1944
%pseudoquad: 19 0.1340
%diagquad: 17 0.1783
%the best performance of random is 0.3991