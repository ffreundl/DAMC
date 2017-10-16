



%feature avec distribution similaire : 310 / 301
%feature avec distribution non similaire : 365 / 385 /497
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

threshold= (mean(features(classZeroPositions,497)) +  mean(features(classOnePositions,497)))/2

x = linspace(1,648,648);
y = zeros(1,648);

for i=1:648
    
    y(i) = threshold;
    
end

figure;
plot(features(:,497));
hold on
plot(features(:,528));
line(x,y);
%on trace le threshold de 497

%retourne un vecteur contenant 1 si l'inégalité est vrai et 0 sinon
test=features(:,497) > threshold;

%on répertorie les idx des valeurs de features(:,497) qui sont au-dessus de
%threshold...

idx_true = find(test==1);

%...et on les compare avec classZeroPositions

%a nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe
a=0;
for i=1:132
    for j=1:241
        if (classZeroPositions(i,1)==idx_true(j,1))
            a=a+1;
        end
    end
end


idx_false = find(test==0);
%b nous retourne le nombre de samples au dessus du threshold qui
%correspondent avec leur classe

b=0;
for i=1:516
    for j=1:407
        if (classOnePositions(i,1)==idx_false(j,1))
            b=b+1;
        end
    end
end


%calcul de l'erreur de classification

classification_error=(648-(a+b))/648;

%calcul de l'erreur de classe
class_error = ((0.5*((516-362)/516))+ (0.5*((132-87)/132)))


