close all;
clc;
clear all;

load dataset_ERP.mat % 2400 features and 648 samples 
%cross-vaidation
%POINT 1
%sur 648 observation crée 10 sets
%contruis un objet c qui définie une partition aléatoire pour une
%10-fold-cv sur 648 samples la partition divise les samples en 10
%subsamples(folds) choisis de manière aléatoire mais de taille égale. 
%les folds peuvent voir leur taille varier de 1 si ils ne peuvent pas se
%diviser exactement 

subfeatures = features(:,1:5:300);


cp=cvpartition(648,'kfold',10); % Créée une REPARTITION de 10 boxes avec à chaque fois 10% de 1 (= test set) et 90% de 0 (= training)
                                   % On va ensuite appliquer cette
                                   % répartition à 'labels' pour avoir
                                   % vraiment des samples.

%affiche la répartition 
cp.disp;

%cp.test(i) renvoie un vecteur 648x1 de 1 et 0. Les index des 1 correspondent aux
%index des valeurs de subfe3atures qui sont présents dans le test_set(i)
%si on voulait les afficher on ferait : test_set = subfeatures(find(cp.test(i)==1),:);
% avec le code ci-dessous on vérifie combien d'objets de classe 1 et de
% classe 0 on trouve dans chaque fold. En gros tous les X, il choisit un
% sample qu'il labelle "1" et qui va servir dans le test set.

% for i=1:10
%    sum(labels(cp.test(i))==1)
% end

% ici dans chaque fold de 64 et 65 samples on trouve entre 48 et 56 samples
% de classe 1, cela varie

%comme au-dessus on construit un objet qui définie une partition aléatoire
%pour une 10 fold-cv sur 648 samples. Ici on prends un groupe en modèle
%labels et la méthode fait en sorte que dans chaque sous-sample la
%proportion de classe soit la meme que dans labels soit ici à chaque fois
%51 ou 52 objets de classe 1
cv=cvpartition(labels,'kfold',10); % Assure que la proportion est gardée
                                    % on appelle ça stratifié


%POINT 2

%On initialise une matrice vide qui va servir à stocker les 10 valeurs pour
%10-fold cv pour le classifier LINEAR
classiError_linear=zeros(1,10);
 
for k=1:10
    training_set = features(find(cv.training(k)==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(cv.test(k)==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1)); % Donnera la VRAIE classe (0 ou 1) des entités du test set..
    classiError_linear(1,k) =  sum(yhat~=labels_test)/yhatLine; % .. on les compare avec la valeur de classe des entités du test set d'après notre modèle de classificateur. 
                                % Chaque fois que la valeur de classe
                                % donnée par le modèle est différente de la
                                % VRAIE valeur de classe, on a un "1" qui
                                % sort de la comparaison. 
end

erreur_classi_linear = mean(classiError_linear); % Moyenne sur les 10 Erreur de classification, pas une métrique style Sdev...

%10-fold cv pour le classifier DIAGLINEAR
classiError_diagli=zeros(1,10);

%lance une boucle pour les 10 sous-groupes
for k=1:10
    %le training set est composé des subfeatures aux index renvoyé par la
    %cv (9/10 de 648)
    training_set = features(find(cv.training(k)==1),:);
    
    %le test set est composé du reste des subfeatures(1/10): 64 ou 65 samples 
    test_set = features(find(cv.test(k)==1),:);
   
    %on entraine le classifier sur le TRAINING SET
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'diaglinear');
    
    %on applique le modèle resultant sur le TEST SET
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_diagli(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diaglinear=mean(classiError_diagli);

%10-fold cv pour le classifier DIAGQUADRA
classiError_diagquadra=zeros(1,10);

%lance une boucle pour les 10 sous-groupes
for k=1:10
    %le training set est composé des subfeatures aux index renvoyé par la
    %cv (9/10 de 648)
    training_set = features(find(cv.training(k)==1),:);
    
    %le test set est composé du reste des subfeatures(1/10): 64 ou 65 samples 
    test_set = features(find(cv.test(k)==1),:);
   
    %on entraine le classifier sur le TRAINING SET
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'diagquadratic');
    
    %on applique le modèle resultant sur le TEST SET
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_diagquadra(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diagquadra=mean(classiError_diagquadra);

classiError_quadra=zeros(1,10);

for k=1:10
    training_set = features(find(cv.training(k)==1),:);
    test_set = features(find(cv.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'pseudoquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_quadra(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_quadra=mean(classiError_quadra);

bar(1,erreur_classi_linear,'b');
hold on;
bar(2,erreur_classi_diaglinear,'y');
hold on;
bar(3,erreur_classi_diagquadra,'m');
hold on;
bar(4,erreur_classi_quadra,'g');
set(gca,'xtick',[]);

%% POINT 3
disp("Leave-One-Out");
%leave-one out cross validation : k = N 
%même procédure qu'avant sauf qu'ici chaque sample sert de training set et
%le modèle résultant est teste sur un seul sample

cd=cvpartition(labels,'kfold',648); % partitionne 648 fois
cd.disp;

%on recommence les déclarations de matrices vides pour les erreurs

classiError_leave_one_lin=zeros(1,648);
erreur_classi_leave_one_linear=[];

for k=1:648
    training_set = features(find(cd.training(k)==1),:);
    test_set = features(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_lin(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_linear=mean(classiError_leave_one_lin);

classiError_leave_one_diaglin=zeros(1,648);
erreur_classi_leave_one_diaglin=[];
for k=1:648
    training_set = features(find(cd.training(k)==1),:);
    test_set = features(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_diaglin(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_diaglin=mean(classiError_leave_one_diaglin);

%DIAQUADRATIC

classiError_leave_one_diagquadri=[];
erreur_classi_leave_one_diagquadri=zeros(1,648);


for k=1:648
    training_set = features(find(cd.training(k)==1),:);
    test_set = features(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'diagquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_diagquadri(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_diagquadri=mean(classiError_leave_one_diagquadri);


%QUADRATIC

classiError_leave_one_quadri=zeros(1,648);
erreur_classi_leave_one_quadri=[];


for k=1:648
    training_set = features(find(cd.training(k)==1),:);
    test_set = features(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'pseudoquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_quadri(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_quadri=mean(classiError_leave_one_quadri);

%POINT 4

%Pour l'instant on a deux partitions : cd -> 10-fold et cv -> 648-fold
%leave one out. Pour les deux on crée une nouvelle version grâce à
%répartiionqui donne un nouvel objet de la même classe mais avec une
%répartition différentes des samples dans les set

classiError_linear_repartition=[];
cv_new=repartition(cv); % On lui passe en paramètre une distribution que l'on veut éviter (car on l'a déjà en l'occurence)

%on teste si les partitions sont bien différentes : retourne 0 si
%différents
isequal(test(cv,1),test(cv_new,1))

%et on recommence...

erreur_classi_linear_repartition=zeros(1,10);
for k=1:10
   
    training_set = features(find(cv_new.training(k)==1),:);
    test_set = features(find(cv_new.test(k)==1),:);
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_linear_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_linear_repartition=mean(classiError_linear_repartition);

classiError_diaglinear_repartition=zeros(1,10);
erreur_classi_diaglinear_repartition=[];

for k=1:10
   
    training_set = features(find(cv_new.training(k)==1),:);
    test_set = features(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_diaglinear_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diaglinear_repartition=mean(classiError_diaglinear_repartition);
%%
classiError_diagquadri_repartition=zeros(1,10);
erreur_classi_diagquadri_repartition=[];

for k=1:10
   
    training_set = features(find(cv_new.training(k)==1),:);
    test_set = features(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'diagquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_diagquadri_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diagquadri_repartition=mean(classiError_diagquadri_repartition);
%%

classiError_quadra_repartition=zeros(1,10);
erreur_classi_quadra_repartition=[];

for k=1:10
   
    training_set = features(find(cv_new.training(k)==1),:);
    test_set = features(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'pseudoquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_quadra_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_quadra_repartition=mean(classiError_quadra_repartition);



cd_new=repartition(cd);

classiError_leave_one_linear_new=zeros(1,648);
erreur_classi_leave_one_linear_new=[];

for k=1:648
    training_set = features(find(cd_new.training(k)==1),:);
    test_set = features(find(cd_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_linear_new(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_linear_new=mean(classiError_leave_one_linear_new);

classiError_leave_one_diaglinear_new=zeros(1,648);
erreur_classi_leave_one_diaglinear_new=[];
for k=1:648
    training_set = features(find(cd_new.training(k)==1),:);
    test_set = features(find(cd_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_diaglinear_new(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_diaglinear_new=mean(classiError_leave_one_diaglinear_new);

classiError_leave_one_diagquadri_new=[1,648];
erreur_classi_leave_one_diagquadri_new=[];

for k=1:648
    training_set = features(find(cd_new.training(k)==1),:);
    test_set = features(find(cd_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'diagquadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_diagquadri_new(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_diagquadri_new = mean(classiError_leave_one_diagquadri);

classiError_leave_one_quadri_new = zeros(1,648);

for k=1:648
    training_set = features(find(cd_new.training(k)==1),:);
    test_set = features(find(cd_new.test(k)==1),:);
   classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'pseudoquadratic')
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_quadri_new(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_leave_one_quadri_new = mean(classiError_leave_one_quadri);

%Si on regarde les variables qui contiennent les valeurs des erreurs on
%peut voir que l'erreur varie très peu en changeant les répartition avec
%les 10-fold cross-validation ce qui montre que les cross validation sont
%un bon moyen de valider le modèle. Pour les leave-one-out on a exactement
%la même erreur (sauf pour linear a 2.10E-04 près ce qui n'est pas normal)
%ce qui est logique puisqu'il n'y a qu'un seul sample par set on a beau
%changer la répartition c'est exactement la même chose. On voit aussi que
%l'erreur est bcp plus faible avec la leave one out mais la variance sera
%bcp plus grande. La LOOCV est péférable pour les set contenant peu de data
%comme ici

%on voit que le classifier le plus fiable est le diagquadratic puisque c'est
%avec lui qu'on a les erreurs les plus faibles. On prends donc celui-ci
%comme final classifier.

%Calcul confusion matrix qui nous renvoie les vrai/faux positifs et les 
%vrai/faux negatifs afin de déterminer la qualité d'un système de classification
%on utilise un training set et un test set selon la méthode du point 2
%qu'on crée en respectant les proportion de labels de l'échantillon total
%% Plots
figure;
subplot(2,3,1);
bar(1,erreur_classi_linear,'b');
hold on;
bar(2,erreur_classi_linear_repartition,'r');
set(gca,'xtick',[]);

subplot(2,3,2);
bar(1,erreur_classi_diaglinear,'b');
hold on;
bar(2,erreur_classi_diaglinear_repartition,'r');
set(gca,'xtick',[]);

subplot(2,3,3);
bar(1,erreur_classi_diagquadra,'b');
hold on;
bar(2,erreur_classi_diagquadri_repartition,'r');
set(gca,'xtick',[]);

% subplot(2,4,4);
% bar(1,erreur_classi_quadra,'b');
% hold on;
% bar(2,erreur_classi_quadra_repartition,'r');
% set(gca,'xtick',[]);

subplot(2,3,4);
bar(1,erreur_classi_leave_one_linear,'b');
hold on;
bar(2,erreur_classi_leave_one_linear_new,'r');
set(gca,'xtick',[]);

subplot(2,3,5);
bar(1,erreur_classi_leave_one_diaglin,'b');
hold on;
bar(2,erreur_classi_leave_one_diaglinear_new,'r');
set(gca,'xtick',[]);

subplot(2,3,6);
bar(1,erreur_classi_leave_one_diagquadri,'b');
hold on;
bar(2,erreur_classi_leave_one_diagquadri_new,'r');
set(gca,'xtick',[]);

% subplot(2,4,8);
% bar(1,erreur_classi_leave_one_quadri,'b');
% hold on;
% bar(2,erreur_classi_leave_one_quadri_new,'r');
% set(gca,'xtick',[]);
