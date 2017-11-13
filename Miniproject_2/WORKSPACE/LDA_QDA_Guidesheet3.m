close all

load dataset_ERP.mat % 2400 features and 648 samples 

% Selecting a subset of features that we will focus on:
subfeatures = features(:,1:5:300);


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

%% Point 1) Using our WHOLE 'subfeatures' dataset to train and predict

% Withour prior
% Linear
classifier = fitcdiscr(features, labels, 'discrimtype', 'linear')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError1 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError1 = 100-ClassifAccu

% Diaginear
classifier = fitcdiscr(features, labels, 'discrimtype', 'diaglinear')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError2 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError2 = 100-ClassifAccu

% quadratic
classifier = fitcdiscr(subfeatures, labels, 'discrimtype', 'quadratic')
yhat = predict(classifier,subfeatures);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct
% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError3 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError3 = 100-ClassifAccu

% Diagquadratic
classifier = fitcdiscr(features, labels, 'discrimtype', 'diagquadratic')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Computing the calssification error
% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError4 = 0.5*((missClass0/m0)+(missClass1/m1))


ClassifAccu = (Correct/labelsLine)*100;
ClassifError4= 100-ClassifAccu


%% With priors
% Linear
classifier = fitcdiscr(features, labels, 'discrimtype', 'linear','Prior','uniform')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct
% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError5 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError5 = 100-ClassifAccu

figure;
subplot(2,4,1);
bar(1,ClassError1,'b');
hold on;
bar(2,ClassifError1,'c');


% Diaglinear
classifier = fitcdiscr(features, labels, 'discrimtype', 'diaglinear','Prior','uniform')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError6 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError6 = 100-ClassifAccu

% quadratic
classifier = fitcdiscr(subfeatures, labels, 'discrimtype', 'quadratic','Prior','uniform')
yhat = predict(classifier,subfeatures);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError7 = 0.5*((missClass0/m0)+(missClass1/m1))


% Computing the calssification error

ClassifAccu = (Correct/labelsLine)*100;
ClassifError7 = 100-ClassifAccu


% Diagquadratic
classifier = fitcdiscr(features, labels, 'discrimtype', 'diagquadratic','Prior','uniform')
yhat = predict(classifier,features);

Correct = 0; % Will return the total number of well-classified samples
[labelsLine,labelsCol] = size(labels); % Returns dimensions of truly cl. as 0
for i = 1:labelsLine % Takes the first element of truly 0 samples...
    if(labels(i,1) == yhat(i,1))
       Correct = Correct +1;
    end
end
% returning the number of samples correctly classified
Correct

% Class Error
missClassified = labels - yhat
missClass1 = 0;
missClass0 = 0;
for i = 1:648

    if(missClassified(i,1) == 1)
        missClass1 = missClass1 +1;
    else if(missClassified(i,1) == -1)
            missClass0 = missClass0 +1;
        end
    end
end

% Computing the class error
ClassError8 = 0.5*((missClass0/m0)+(missClass1/m1))

% Computing the errors

ClassifAccu = (Correct/labelsLine)*100;
ClassifError8= 100-ClassifAccu

figure;
subplot(2,4,1);
bar(1,ClassError1,'b');
hold on;
bar(2,ClassError5,'r');
set(gca,'xtick',[]);

subplot(2,4,2);
bar(1,ClassError2,'b');
hold on;
bar(2,ClassError6,'r');
set(gca,'xtick',[]);

subplot(2,4,3);
bar(1,ClassError3,'b');
hold on;
bar(2,ClassError7,'r');
set(gca,'xtick',[]);

subplot(2,4,4);
bar(1,ClassError4,'b');
hold on;
bar(2,ClassError8,'r');
set(gca,'xtick',[]);

subplot(2,4,5);
bar(1,ClassifError1,'b');
hold on;
bar(2,ClassifError5,'r');
set(gca,'xtick',[]);

subplot(2,4,6);
bar(1,ClassifError2,'b');
hold on;
bar(2,ClassifError6,'r');
set(gca,'xtick',[]);

subplot(2,4,7);
bar(1,ClassifError3,'b');
hold on;
bar(2,ClassifError7,'r');
set(gca,'xtick',[]);

subplot(2,4,8);
bar(1,ClassifError4,'b');
hold on;
bar(2,ClassifError8,'r');
set(gca,'xtick',[]);
