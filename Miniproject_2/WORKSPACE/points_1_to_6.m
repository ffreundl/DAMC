close all

load dataset_ERP.mat % 2400 features and 648 samples 

% Sorting out two classes: unwillingly (label = 0) and willingly (label =
% 1) movements.

idx0 = find(labels==0);
idx1 = find(labels==1);

%% Point 1)
% Histograms of feature 310, similarily distributed for class 0 and 1
% NB: resembling/disembling features were found gropingly)

% Vector of similar features for class 0 and 1
s0 = features(idx0,310);
s1 = features(idx1,310);
% Vector of different features for class 0 and 1
d0 = features(idx0,497);
d1 = features(idx1,497);

figure('name','Histograms of feature #310, similarily distributed for class 0 and 1');
a1 = histogram(s0,'FaceColor','b', 'Normalization', 'probability')
hold on;
a2 = histogram(s1,'FaceColor','r', 'Normalization', 'probability')
legend('Class 0','Class 1')

%Histograms of feature 497, differently distributed for class 0 and 1

figure('name','Histograms of feature #497, diffeerently distributed for class 0 and 1')
a3 = histogram(d0,'FaceColor','b','Tag','Class 0', 'Normalization', 'probability')
hold on;
a4 = histogram(d1,'FaceColor','r', 'Normalization', 'probability')
legend('Class 0','Class 1')

% %Histograms of feature 385, differently distributed for class 0 and 1
% 
% figure('name','Histograms of feature #385, diffeerently distributed for class 0 and 1')
% a3 = histogram(features(idx0,385),'FaceColor','b','Tag','Class 0', 'Normalization', 'probability')
% hold on;
% a4 = histogram(features(idx1,385),'FaceColor','r', 'Normalization', 'probability')
% legend('Class 0','Class 1')

%% Point 2) Boxplot of these features

simGroup = [ones(size(s0));2*ones(size(s1))];
difGroup = [ones(size(s0));2*ones(size(s1))];
figure('name','Boxplots for features #310 (similar distribution for both classes) and #497 (dissimilar distribution for both classes)')
subplot(1,2,1)
boxplot([s0;s1], simGroup,'Labels',{'Class 0','Class1'})
title('Boxplots for feature #310');
grid on;
subplot(1,2,2)
boxplot([d0;d1], difGroup,'Labels',{'Class 0','Class 1'})
title('Boxplots for feature #497');
grid on;


%% Point 3) Boxplot of these features WITH NOTCH. The notch represent the 95% bilateral confidence interval,
% which means: 

simGroup = [ones(size(s0));2*ones(size(s1))];
difGroup = [ones(size(s0));2*ones(size(s1))];
figure('name','Notched boxplots for features #310 (similar distribution for both classes) and #497 (dissimilar distribution for both classes)')
subplot(1,2,1)
boxplot([s0;s1], simGroup,'Labels',{'Class 0','Class1'},'Notch','on')
title('Boxplots for feature #310');
grid on;
subplot(1,2,2)
boxplot([d0;d1], difGroup,'Labels',{'Class 0','Class 1'},'Notch','on')
title('Boxplots for feature #497');
grid on;

%% Point 4) ttest between similarily and dissimilarily distributed features 

% T-test for feature #310 (similarily distributed for class 0 and 1)
[Reject1,Pval1] = ttest2(s0,s1) % Equals tho writing it so:  [h1,p1] = ttest2(a1.Data,a2.Data), where a1 and a2 are the histogram objects
% T-test for feature #497 (differently  distributed for class 0 and 1)
[Reject2,Pval2] = ttest2(d0,d1)

%%%% ANSWEEER WHY THE THE TTEST ISNT OR IS APLICABLE AND ANSWER POINT 6
% We cannot use the t-test for all features, since the classes need to be
% independant from each other. We cannot be sure that the classes 1 and 0
% are idependent regarding every feature. Furthermore, they must be
% normally distributed. The features we chose satisfy this criterion, but
% again, we cannot be sure that every features are normally for both
% classes. QUESTION 6: so if we apply a t-test to compare all of our
% features for both classes, and find one that allows a significant
% discrimination, that doesn't necessarily mean that the two classes are
% different: that would simply mean that the distribution of ONE feature is
% not the same, but that could happen some times in a 2400 features list
% without however modifying the overall profile of the classes to the point
% that they look very similar or unsimilar.

%% Point 7): for a feature that is different for both classes, class histograms
% can help us set a threshold VISUALLY and from the means.

% For FEATURE 497: Sorting out values above or under the threshold

thresh = (mean(features(idx0,497))+mean(features(idx1,497)))/2 % we will use this threshold

% vectors for a line
x = linspace(1,648,648);
y = zeros(1,648);
for i=1:648
    
    y(i) = thresh;
    
end

figure('name','');
plot(features(:,497),'b.');
hold on
plot(features(:,528),'r.');
hold on
line(x,y,'Color','black','LineStyle','--')
legend('feature #497', 'feature #528','thresh. feat. #497','Location','NW')
% Counting samples classified as class 0 (above threshold following the
% correponding histogram of feature 497) and class 1 (under threshold
% following the correponding histogram of feature 497)

test = features(:,497) > thresh; % If the sample has a 497 feature above thresh, assigns 1 to that sample, 0 if not

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

%% Doing the same computation as for feat. 497 on feat. 528, which also reject the null hypothesis
% and eliciting two classes based on the TWO features (all-or-nothing:
% either the 2 features test give a good classification, either at least
% one of the features gives a false classification and the 2D consideration
% is false: only one correct feature classification is not enough and
% counts as a wrong classification.) 
thresh528 = (mean(features(idx0,528))+mean(features(idx1,528)))/2 % we will use this threshold

% Counting samples classified as class 0 (above threshold following the
% correponding histogram of feature 497) and class 1 (under threshold
% following the correponding histogram of feature 497)

test528 = features(:,528) > thresh528; % If the sample has a 528 feature above thresh, assigns 1 to that sample, 0 if not

idxAbove528 = find(test528==1); % Lists the index of every sample above threshold for feat 528
idxUnder528 = find(test528==0); % Lists the index of every sample under threshold for feat 528

% Compare the classification with regard to our method with the real
% classes

Correct0_528 = 0; % Will return the total number of well-classified samples
[AboveLine528, AboveCol528] = size(idxAbove528); % Returns dimensions of cl. as 0 with our method
for i = 1:idx0Line % Takes the first element of truly 0 samples...
    for j = 1:AboveLine528
        if(idx0(i,1) == idxAbove528(j,1))
            Correct0_528 = Correct0_528 +1;
        end
    end
end
% returning the number of samples correctly classified as 0
Correct0_528 

Correct1_528 = 0; % Will return the total number of well-classified samples
[UnderLine528, UnderCol528] = size(idxUnder528); % Returns dimensions of cl. as 0 with our method
for i = 1:idx1Line % Takes the first element of truly 0 samples...
    for j = 1:UnderLine528
        if(idx1(i,1) == idxUnder528(j,1))
            Correct1_528 = Correct1_528 +1;
        end
    end
end
% returning the number of samples correctly classified as 1
Correct1_528

% Computing the calssification error for feat. 528 only:

ClassifAccu528 = ((Correct0_528 + Correct1_528)/(idx0Line + idx1Line))*100
ClassifError528 = 100-ClassifAccu528

ClassError528 = (0.5*(((idx0Line-Correct0_528)/idx0Line)+((idx1Line-Correct1_528)/idx1Line)))*100

% %% taking both features 497 and 528 at once: 
% 
% Correct0both = 0; % Will return the total number of well-classified samples
% for i = 1:idx0Line % Takes the first element of truly 0 samples...
%     for j = 1:AboveLine
%         for k = 1:AboveLine528
%          if((idx0(i,1) == idxAbove(j,1)) &&(idx0(i,1) == idxAbove528(k,1)))
%             Correct0both = Correct0both +1;
%         end
%     end
%     end
% end
% % returning the number of samples correctly classified as 0
% Correct0both 
% 
% Correct1 = 0; % Will return the total number of well-classified samples
% [idx1Line,idx1Col] = size(idx1); % Returns dimensions of truly cl. as 0
% [UnderLine, UnderCol] = size(idxUnder); % Returns dimensions of cl. as 0 with our method
% for i = 1:idx1Line % Takes the first element of truly 0 samples...
%     for j = 1:UnderLine
%         if(idx1(i,1) == idxUnder(j,1))
%             Correct1 = Correct1 +1;
%         end
%     end
% end
% % returning the number of samples correctly classified as 1
% Correct1

%% Point 11) Plotting class error and classification error in function of threshold values (for feature 497 in this case)

% Defining the min and max value of feature 497 over the 648 samples as
% boundaries of min and max thresholds
max497 = max(features(:,497));
min497 = min(features(:,497));
functionalMax497 = max497+0.0001; % plus a little epsilon in order to avoid the samples to be ON the threshold
functionalMin497 = min497+0.0001;

ClassErrorVect = [];
ClassifErrorVect = [];

threshVals = linspace(functionalMin497, functionalMax497,648); % creates as many thresholds as there are samples
figure('name', 'SeveralThreshforFeat497')
for t=threshVals% = functionalMin497:functionalMax497
   test = features(:,497) > t; % If the sample has a 497 feature above thresh, assigns 1 to that sample, 0 if not

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

ClassifAccu = ((Correct0 + Correct1)/(idx0Line + idx1Line))*100;
ClassifError = 100-ClassifAccu;

ClassError = (0.5*(((idx0Line-Correct0)/idx0Line)+((idx1Line-Correct1)/idx1Line)))*100;

ClassErrorVect = [ClassErrorVect ClassError];
ClassifErrorVect = [ClassifErrorVect ClassifError];
end
plot(threshVals, ClassErrorVect, 'b')
hold on
plot(threshVals, ClassifErrorVect,'r')

minClassError = find(ClassErrorVect == min(ClassErrorVect));% Returns the best threshold, which corresponds to the initially chosen one since we took a threshold being exactly the same distance to class 0 mean as to class 1 mean
BestThresh = threshVals(minClassError)

%% Scaling up to 2 features at once

% Vector of different features for class 0 and 1 for feature 528 which is
% also discriminant (we already have d0 and d1 for feature 497)
d0_528 = features(idx0,528);
d1_528 = features(idx1,528);

figure('name','Feature 497 as a function of feat. 528, for class 0 and 1')
plot(d0,d0_528,'b.') % Class 0, 2 features
hold on
plot(d1,d1_528,'r.')
legend('Class 0', 'Class 1','Location','NW')
% We could imagin using a linear discriminant function or even use a kmeans
% clustering in order to separate the 2 classes, but we see that the
% two classes are not well separated enough. Moreover, event if we could
% separate the 2 classes using a linear discriminant in 2D (using two
% features at once), the complexity would have to be increased too much for
% higher dimensions (up to 2400), which let us suppose that features
% thresholding reaches a limit quickly.

%% Generalising for all features

[h,p] = ttest2(features(idx0,:),features(idx1,:));
relevantFeatures = find(h == 1); % Finds the features for which the null hypothesis is rejected (h = 1), i.e. features allowing separation of classes

