close all
clear all
load('Data.mat');

trainingData=Data(1:643,:);
testData=Data(644:122862,:);
lambda =logspace(-10,0,15);
[beta,fitInf]=lasso(trainingData,PosX(1:643),'Alpha',0.01,'lambda',lambda);
beta0=fitInf.Intercept;
numbOfNonZeros=zeros(size(lambda));
for i=1:numel(lambda)
   numbOfNonZeros(i)=numel(find(beta(:,i)~=0));
   figure
   plot(PosX(1:643),'b');
   hold on
   plot(trainingData*beta(:,i)+beta0(i),'r');
   hold off
   
   
end
disp(min(fitInf.MSE));