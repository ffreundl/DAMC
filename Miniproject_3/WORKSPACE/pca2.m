function [coeff,trScore,var,testScore,mu,sigma] =pca2(trSet,testSet,normalization)

mu=mean(trSet);
sigma=std(trSet);

% centering
trSet = trSet-mu;
testSet=testSet -mu; %mu should be feature wise

if(normalization)
trSet=trSet./sigma;
testSet=testSet./sigma;
end



[coeff,trScore,var]= pca(trSet);

testScore=testSet*coeff;


end