%% part one : finding irrelevent feature with histogram comparison
classZeroPositions =find(labels==0);
classOnePositions = find(labels==1);

%la feature pour lesquelles les résultats sont similaires
similar=310;
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




%1005 and 300 are alike
% and 2200 are different
figure

subplot(2,2,1)
title('asdf')
boxplot(features(:,1005))
title('Histogram for 1005th features')
ylim([-8 8])

grid on
subplot(2,2,2)
boxplot(features(:,300))
title('Histogram for 300th features')
ylim([-8 8])


grid on
subplot(2,2,3)
boxplot(features(:,2200))
title('Histogram for 2200th features')
ylim([-8 8])
grid on



%feature avec distribution similaire : 310 / 301
%feature avec distribution non similaire : 365 / 528 /497
%observation des differents histogrammes pour essayer de trouver de maniere
%visuelle un threeshold adéquat

%recherche de threeshold pour non similaires
figure
subplot(1,3,1)
histogram(features(classZeroPositions,528),'Normalization','probability');
hold on
histogram(features(classOnePositions,528),'Normalization','probability')

subplot(1,3,2)
histogram(features(classZeroPositions,385),'Normalization','probability');
hold on
histogram(features(classOnePositions,385),'Normalization','probability')

subplot(1,3,3)
histogram(features(classZeroPositions,497),'Normalization','probability');
hold on
histogram(features(classOnePositions,497),'Normalization','probability')

threshold_497= (mean(features(classZeroPositions,497)) +  mean(features(classOnePositions,497)))/2

x = linspace(1,648,648);
y = zeros(1,648);

for i=1:648
    
    y(i) = threshold_497;
    
end

figure;
plot(features(classOnePositions,497),'b.');
hold on
plot(features(classZeroPositions,497),'r.');
line(x,y);
%on trace le threshold de 497

%retourne un vecteur contenant 1 si l'inégalité est vrai et 0 sinon
test_497=features(:,497) > threshold_497;

%on répertorie les idx des valeurs de features(:,497) qui sont au-dessus de
%threshold...

idx_true_497 = find(test_497==1);

%...et on les compare avec classZeroPositions

%a nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe
a_497=0;
for i=1:132
    for j=1:241
        if (classZeroPositions(i,1)==idx_true_497(j,1))
            a_497=a_497+1;
        end
    end
end


idx_false_497 = find(test_497==0);
%b nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe

b_497=0;
for i=1:516
    for j=1:407
        if (classOnePositions(i,1)==idx_false_497(j,1))
            b_496=b_497+1;
        end
    end
end


%calcul de l'erreur de classification

classification_error_497=(648-(a_497+b_497))/648;

%calcul de l'erreur de classe
class_error_497 = ((0.5*((516-362)/516))+ (0.5*((132-87)/132)))


%on veut maintenant utiliser pour deux features. On prends deux features
%statistiquement différents (ttest) 528 et 497
%on calcule le nouveau threshold
threshold_528= (mean(features(classZeroPositions,528)) +  mean(features(classOnePositions,528)))/2

test_528=features(:,528) > threshold_528;



%on répertorie les idx des valeurs de features(:,528) qui sont au-dessus de
%threshold...

idx_true_528 = find(test_528==1);

%...et on les compare avec classZeroPositions

%a nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe



idx_false_528 = find(test_528==0);

a_528=0;
for i=1:132
    for j=1:203
        if (classZeroPositions(i,1)==idx_true_528(j,1))
            a_528=a_528+1;
        end
    end
end


idx_false_528 = find(test_528==0);
%b nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe

b_528=0;
for i=1:516
    for j=1:445
        if (classOnePositions(i,1)==idx_false_528(j,1))
            b_528=b_528+1;
        end
    end
end

%calcul de l'erreur de classification

classification_error_528=(648-(a_528+b_528))/648;

%calcul de l'erreur de classe
class_error_528 = ((0.5*((516-404)/516))+ (0.5*((132-91)/132)))

