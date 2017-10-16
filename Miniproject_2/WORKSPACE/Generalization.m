close all

load dataset_ERP.mat % 2400 features and 648 samples 

% Sorting out two classes: unwillingly (label = 0) and willingly (label =
% 1) movements.

idx0 = find(labels==0);
[m0,n0] = size(idx0);
idx1 = find(labels==1);
[m1,n1] = size(idx1);

% In order to creat training and test sets that respect the proportions (ratio) of
% class 0 and class 1 samples, we distribute 50% of class 0 indexes to each
% set, and 50% of class 1 indexes to each class also:

% Training set = 66 samples from class 0 and 258 samples from class 1, same
% for the test set (total = 324 samples).

trainingSet = zeros(1,324);
testSet = zeros(1,324);

% EXPLAIN THAT FUCKIN CLASSIFICATION!!!!!!!!

for i = 1:(m0/2)
    trainingSet(1,i) = idx0(i,1)
end

for j = 1:(m0/2)
    testSet(1,j) = idx0(((m0/2)+j),1)
end
    
for i = 1:(m1/2)
    trainingSet(1,(m0/2)+i) = idx1(i,1)
end

for j = 1:(m1/2)
    testSet(1,(m0/2)+j) = idx1(((m1/2)+j),1)
end