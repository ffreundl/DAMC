load dataset_ERP.mat % 2400 features and 648 samples 

% Sorting out two classes: unwillingly (label = 0) and willingly (label =
% 1) movements.

idx0 = find(labels==0)
idx1 = find(labels==1)

%% Point 1)
% Histograms of feature 310, similarily distributed for class 0 and 1
% NB: resembling/disembling features were found gropingly)

% Vector of similar features for class 0 and 1
s0 = features(idx0,310);
s1 = features(idx1,310);
% Vector of different features for class 0 and 1
d0 = features(idx0,365);
d1 = features(idx1,365);

figure('name','Histograms of feature #310, similarily distributed for class 0 and 1');
a1 = histogram(s0,'FaceColor','b')
hold on;
a2 = histogram(s1,'FaceColor','r')
legend('Class 0','Class 1')

%Histograms of feature 365, differently distributed for class 0 and 1

figure('name','Histograms of feature #365, diffeerently distributed for class 0 and 1')
a3 = histogram(d0,'FaceColor','b','Tag','Class 0')
hold on;
a4 = histogram(d1,'FaceColor','r')
legend('Class 0','Class 1')

%% Point 2) Boxplot of these features

% Similarily distributed feature (310)
figure('name','Boxplots for feature #310, similarily distributed for class 0 and 1');
subplot(1,2,1)
boxplot(s0); %class 0
title('Class 0')
grid on;
subplot(1,2,2)
boxplot(s1); %class 1
title('Class 1')
grid on;

% Differently distributed feature (365)
figure('name','Boxplots for feature #365, differently distributed for class 0 and 1');
subplot(1,2,1)
boxplot(d0); % class 0
title('Class 0')
grid on;
subplot(1,2,2)
boxplot(d1); % class 1
title('Class 1')
grid on;

%% Point 3) Boxplot of these features WITH NOTCH. The notch represent the 95% bilateral confidence interval,
% wihch means: 

% Similarily distributed feature (310)
figure('name','Notched boxplots for feature #310, similarily distributed for class 0 and 1');
subplot(1,2,1)
boxplot(s0,'Notch','on'); %class 0
title('Class 0')
grid on;
subplot(1,2,2)
boxplot(s1,'Notch','on'); %class 1
title('Class 1')
grid on;

% Differently distributed feature (365)
Fig4 = figure('name','Notched boxplots for feature #365, differently distributed for class 0 and 1');
subplot(1,2,1)
boxplot(d0,'Notch','on'); % class 0
title('Class 0')
grid on;
subplot(1,2,2)
boxplot(d1,'Notch','on'); % class 1
title('Class 1')
grid on;
saveas(gcf, 'test.svg')
saveas(gcf, 'test.jpg')


%%%^^^^^^^^^^^LABELLLSSS??

%% Point 4) ttest between similarily and dissimilarily distributed features 

% T-test for feature #310 (similarily distributed for class 0 and 1)
[Reject1,Pval1] = ttest2(s0,s1) % Equals tho writing it so:  [h1,p1] = ttest2(a1.Data,a2.Data), where a1 and a2 are the histogram objects
% T-test for feature #365 (differently  distributed for class 0 and 1)
[Reject2,Pval2] = ttest2(d0,d1)

