close all
clear all
load('Data.mat');

trainingData=Data(1:643,:);
testData=Data(644:12862,:);
lambda =logspace(-10,0,15);
[beta,fitInf]=lasso(trainingData,PosX(1:643),'Alpha',0.5,'lambda',lambda);
beta0=fitInf.Intercept;

[betaY,fitInfY]=lasso(trainingData,PosY(1:643),'Alpha',0.5,'lambda',lambda);
beta0Y=fitInfY.Intercept;
numbOfNonZeros=zeros(size(lambda));
for i=1:numel(lambda)
   numbOfNonZeros(i)=numel(find(beta(:,i)~=0));
 
   
   
end
disp('training data for regressing PosX');
disp(min(fitInf.MSE));
disp(find(fitInf.MSE==min(fitInf.MSE)));

%it returns 1 lambda very short

errorOnX=zeros(size(lambda));
errorOnY=errorOnX;
for i=1:numel(lambda)

    xpredicted=testData*beta(:,i)+beta0(i);
    ypredicted=testData*betaY(:,i)+beta0Y(i);
    errorOnX(i)=immse(PosX(644:12862),xpredicted);
    errorOnY(i)=immse(PosY(644:12862),ypredicted);
end
figure
title('MSE in function of \lambda with an \alpha = 0.5')
hold on
ontos1=plot(errorOnX,'b');

ontos2=plot(errorOnY,'r');
xlabel('\lambda');
ylabel('Mean squared error');
legend([ontos1 ontos2],'x position','y position');
hold off



disp('training data for regressing PosY');
disp(min(fitInf.MSE));
disp(find(fitInf.MSE==min(fitInf.MSE)));
%still returns 1
figure
title('regression of X and Y from \lambda from the best testing error')
subplot(1,2,1)
plot(PosX(644:12862))
hold on;
plot(testData*beta(:,11)+beta0(11),'r');
subplot(1,2,2)
plot(PosY(644:12862))
hold on;
plot(testData*betaY(:,11)+beta0Y(11),'r');
hold off

%%  alpha tuning with small training sets with a cross validation (yeeeeaaah !!!!!) cauz it doesn't like alpha as a vector

partition=cvpartition(numel(Data(:,1)),'KFold',20);
%we will invert the testing and training set in order to have
%problematicly small training sets as in the previous part

alpha=logspace(-10,0,15);
testErrorOnX=zeros(0,20);
testErrorOnY=zeros(1,20);
meanErrorOnX=zeros(1,numel(alpha));
meanErrorOnY=meanErrorOnX;
stdErrorOnX=meanErrorOnY;
stdErrorOnY=stdErrorOnX;

for a=1:numel(alpha)
    for i=1:20
        trainingData=Data(partition.test(i),:);
        testData=Data(partition.training(i),:);
        trainingX=PosX(partition.test(i));
        trainingY=PosY(partition.test(i));
        testX=PosX(partition.training(i));
        testY=PosY(partition.training(i));
        [betaX,fitInfX]=lasso(trainingData,trainingX,'Alpha',alpha(a),'lambda',lambda);
        [betaY,fitInfY]=lasso(trainingData,trainingY,'Alpha',alpha(a),'lambda',lambda);
        beta0X=fitInfX.Intercept;
        beta0Y=fitInfY.Intercept;
        
        xpredicted=testData*betaX(:,a)+beta0X(a);
        ypredicted=testData*betaY(:,a)+beta0Y(a);
        
        testErrorOnX(i)=immse(testX,xpredicted);
        testErrorOnY(i)=immse(testY,ypredicted);
        

    end
    meanErrorOnX(a)=mean(testErrorOnX);
    meanErrorOnY(a)=mean(testErrorOnY);
    stdErrorOnX(a)=std(testErrorOnX);
    stdErrorOnY(a)=std(testErrorOnY);
    
    
    
end

minErrorOnX=min(meanErrorOnX);
%5.9138e-4
find(meanErrorOnX==minErrorOnX);
%13
%alpha(13)=0.0373, std=1.677e-5
minErrorOnY=min(meanErrorOnY);
%3.4142e-04
%also 13, std=6.1347e-6

%% better hyper Parameters tuning

% we have enough data to perform a split
alpha=logspace(-10,0,15);
TrainingSet=Data(1:10290,:);
ValidationSet=Data(10291:10933,:);
TestSet=Data(10934:12862,:);

validationErrors=zeros(numel(lambda),numel(alpha));
trainingErrors=validationErrors;
testErrors=trainingErrors;
for i=1:numel(lambda)
    for j=1:numel(alpha)
        
        [betaX,fitInfX]=lasso(TrainingSet,PosX(1:10290),'Alpha',alpha(j),'lambda',lambda(i));
        [betaY,fitInfY]=lasso(TrainingSet,PosY(1:10290),'Alpha',alpha(j),'lambda',lambda(i));
        beta0X=fitInfX.Intercept;
        beta0Y=fitInfY.Intercept;
        validationErrors(i,j)=immse(PosX(10291:10933),ValidationSet*betaX+beta0X);
        trainingErrors(i,j)=immse(PosX(1:10290),TrainingSet*betaX+beta0X);
        testErrors(i,j)=immse(PosX(10934:12862),TestSet*betaX+beta0X);
        
    end
    
end


