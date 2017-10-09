%% part one : finding irrelevent feature with histogram comparison
classZeroPositions =find(labels==0);
classOnePositions = find(labels==1);

%la feature pour lesquelles les résultats sont similaires
similar=301;
%la feature pour laquelle les résultats sont différents
different=389;
figure
subplot(1,2,1)
%fait les histogramme de la première classe, feature similaire, j'ai essayé
%de normaliser au mieux
histogram(features(classZeroPositions,similar),'Normalization','probability');
hold on
histogram(features(classOnePositions,similar),'Normalization','probability');
title('')
subplot(1,2,2)
histogram(features(classZeroPositions,similar),'Normalization','probability');
hold on
histogram(features(classOnePositions,different),'Normalization','probability');
%doing a ttest to know wether they are likely similar or not
[h1,p1]=ttest2(features(classZeroPositions,similar),features(classOnePositions,similar))
[h2,p2]=ttest2(features(classZeroPositions,different),features(classOnePositions,different))

%%point 2 boxplot
figure
subplot(2,2,1)
boxplot(features(classZeroPositions,similar))


subplot(2,2,2)
boxplot(features(classOnePositions,similar))

subplot(2,2,3)
boxplot(features(classZeroPositions,different))
subplot(2,2,4)
boxplot(features(classZeroPositions,different))

%%point 3 boxplot with Notch
figure
subplot(2,2,1)
boxplot(features(classZeroPositions,similar),'Notch','on')


subplot(2,2,2)
boxplot(features(classOnePositions,similar),'Notch','on')

subplot(2,2,3)
boxplot(features(classZeroPositions,different),'Notch','on')
subplot(2,2,4)
boxplot(features(classZeroPositions,different),'Notch','on')



