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
    trainingSet(1,i) = idx0(i,1);
end

for j = 1:(m0/2)
    testSet(1,j) = idx0(((m0/2)+j),1);
end
    
for i = 1:(m1/2)
    trainingSet(1,(m0/2)+i) = idx1(i,1);
end

for j = 1:(m1/2)
    testSet(1,(m0/2)+j) = idx1(((m1/2)+j),1);
end

% "0/1" Classes Ratio of our sets:

training0 = m0/2
testSet0 = m0/2
training1 = length(trainingSet)-m0/2
testSet1 = length(testSet)-m0/2
trainingClRatio = training0/training1 % Class ratio of trainingSet
testSetClRatio = testSet0/testSet1 % " " " testSet
totalSetClRatio = idx0Line/idx1Line % Ratio of the total set

%% Finding the optimal threshold on our training set, using feature 497

% subthresholding to the features of our training set only

trainingFeats = features(trainingSet,:);

% Defining the min and max value of feature 497 over the 648 samples as
% boundaries of min and max thresholds
max497 = max(trainingFeats(:,497));
min497 = min(trainingFeats(:,497));
functionalMax497 = max497+0.0001; % plus a little epsilon in order to avoid the samples to be ON the threshold
functionalMin497 = min497+0.0001;

ClassErrorVect = [];
ClassifErrorVect = [];

threshVals = linspace(functionalMin497, functionalMax497,648); % creates as many thresholds as there are samples
figure('name', 'SeveralThreshforFeat497')
for t=threshVals% = functionalMin497:functionalMax497
   test = trainingFeats(:,497) > t; % If the sample has a 497 feature above thresh, assigns 1 to that sample, 0 if not

    idxAbove = find(test==1); % Lists the index of every sample above threshold
    idxUnder = find(test==0); % Lists the index of every sample under threshold

% Compare the classification with regard to our method with the real
% classes

Correct0 = 0; % Will return the total number of well-classified samples
[idx0Line,idx0Col] = size(idx0); % Returns dimensions of truly cl. as 0
[AboveLine, AboveCol] = size(idxAbove); % Returns dimensions of cl. as 0 with our method
for i = 1:idx0Line % Takes the first element of truly 0 samples...
    for j = 1:AboveLine
        if(idx0(i,1) == idxAbove(j,1))
            Correct0 = Correct0 +1;
        end
    end
end
% returning the number of samples correctly classified as 0
Correct0;

Correct1 = 0; % Will return the total number of well-classified samples
[idx1Line,idx1Col] = size(idx1); % Returns dimensions of truly cl. as 0
[UnderLine, UnderCol] = size(idxUnder); % Returns dimensions of cl. as 0 with our method
for i = 1:idx1Line % Takes the first element of truly 0 samples...
    for j = 1:UnderLine
        if(idx1(i,1) == idxUnder(j,1))
            Correct1 = Correct1 +1;
        end
    end
end
% returning the number of samples correctly classified as 1
Correct1;

% Computing the calssification error for feat. 497 only:

ClassifAccu = ((Correct0 + Correct1)/(training0 + training1))*100;
ClassifError = 100-ClassifAccu;

ClassError = (0.5*(((training0-Correct0)/training0)+((training1-Correct1)/training1)))*100;

ClassErrorVect = [ClassErrorVect ClassError];
ClassifErrorVect = [ClassifErrorVect ClassifError];
end
plot(threshVals, ClassErrorVect, 'b')
hold on
plot(threshVals, ClassifErrorVect,'r')

minClassError = find(ClassErrorVect == min(ClassErrorVect));% Returns the best threshold, which corresponds to the initially chosen one since we took a threshold being exactly the same distance to class 0 mean as to class 1 mean
BestThresh = threshVals(minClassError) % it will return a vector since there are 3 same minimal class error.

%% See the use of training thresh on the test set

testFeats = features(testSet,:);

test = testFeats(:,497) > min(BestThresh); % We take the minimal threshold arbitrarily

idxAbove = find(test==1); % Lists the index of every sample above threshold
idxUnder = find(test==0); % Lists the index of every sample under threshold

% Compare the classification with regard to our method with the real
% classes

Correct0 = 0; % Will return the total number of well-classified samples
[idx0Line,idx0Col] = size(idx0); % Returns dimensions of truly cl. as 0
[AboveLine, AboveCol] = size(idxAbove); % Returns dimensions of cl. as 0 with our method
for i = 1:idx0Line % Takes the first element of truly 0 samples...
    for j = 1:AboveLine
        if(idx0(i,1) == idxAbove(j,1))
            Correct0 = Correct0 +1;
        end
    end
end
% returning the number of samples correctly classified as 0
Correct0 

Correct1 = 0; % Will return the total number of well-classified samples
[idx1Line,idx1Col] = size(idx1); % Returns dimensions of truly cl. as 0
[UnderLine, UnderCol] = size(idxUnder); % Returns dimensions of cl. as 0 with our method
for i = 1:idx1Line % Takes the first element of truly 0 samples...
    for j = 1:UnderLine
        if(idx1(i,1) == idxUnder(j,1))
            Correct1 = Correct1 +1;
        end
    end
end
% returning the number of samples correctly classified as 1
Correct1

% Computing the calssification error for feat. 497 only:

ClassifAccu = ((Correct0 + Correct1)/(idx0Line + idx1Line))*100
ClassifError = 100-ClassifAccu

ClassError = (0.5*(((idx0Line-Correct0)/idx0Line)+((idx1Line-Correct1)/idx1Line)))*100
