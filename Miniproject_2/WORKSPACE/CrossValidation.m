%cross-vaidation
%POINT 1
%sur 648 observation cr�e 10 sets
%contruis un objet c qui d�finie une partition al�atoire pour une
%10-fold-cv sur 648 samples la partition divise les samples en 10
%subsamples(folds) choisis de mani�re al�atoire mais de taille �gale.
%les folds peuvent voir leur taille varier de 1 si ils ne peuvent pas se
%diviser exactement 

cp=cvpartition(648,'kfold',10);

%affiche la r�partition 
cp.disp;

%cp.test(i) renvoie un vecteur 648x1 de 1 et 0. Les index des 1 correspondent aux
%index des valeurs de subfeatures qui sont pr�sents dans le test_set(i)
%si on voulait les afficher on ferait : test_set = subfeatures(find(cp.test(i)==1),:);
% avec le code ci-dessous on v�rifie combien d'objets de classe 1 et de
% classe 0 on trouve dans chaque fold

% for i=1:10
%    sum(labels(cp.test(i))==1)
% end

% ici dans chaque fold de 64 et 65 samples on trouve entre 48 et 56 samples
% de classe 1, cela varie

%comme au-dessus on construit un objet qui d�finie une partition al�atoire
%pour une 10 fold-cv sur 648 samples. Ici on prends un groupe en mod�le
%labels et la m�thode fait en sorte que dans chaque sous-sample la
%proportion de classe soit la meme que dans labels soit ici � chaque fois
%51 ou 52 objets de classe 1
cv=cvpartition(labels,'kfold',10);


%POINT 2

%On initialise une matrice vide qui va servir � stocker les 10 valeurs pour
%10-fold cv pour le classifier LINEAR
classiError_linear=[];
 
for k=1:10
    training_set = subfeatures(find(cv.training(k)==1),:);
    test_set = subfeatures(find(cv.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_linear(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_linear = mean(classiError_linear);

%10-fold cv pour le classifier DIAGLINEAR
classiError_diagli=[];

%lance une boucle pour les 10 sous-groupes
for k=1:10
    %le training set est compos� des subfeatures aux index renvoy� par la
    %cv (9/10 de 648)
    training_set = subfeatures(find(cv.training(k)==1),:);
    
    %le test set est compos� du reste des subfeatures(1/10): 64 ou 65 samples 
    test_set = subfeatures(find(cv.test(k)==1),:);
   
    %on entraine le classifier sur le TRAINING SET
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'diaglinear');
    
    %on applique le mod�le resultant sur le TEST SET
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_diagli(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diaglinear=mean(classiError_diagli);


classiError_quadra=[];

for k=1:10
    training_set = subfeatures(find(cv.training(k)==1),:);
    test_set = subfeatures(find(cv.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv.training(k)==1),:), 'discrimtype', 'quadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv.test(k)==1));
    classiError_quadra(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_quadra=mean(classiError_quadra);

%POINT 3
%leave-one out cross validation : k = N 
%m�me proc�dure qu'avant sauf qu'ici chaque sample sert de training set et
%le mod�le r�sultant est teste sur un seul sample

cd=cvpartition(labels,'kfold',648);
cd.disp;

%on recommence les d�clarations de matrices vides pour les erreurs

classiError_leave_one_lin=[];
erreur_classi_leave_one_linear=[];

for k=1:648
    training_set = subfeatures(find(cd.training(k)==1),:);
    test_set = subfeatures(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_lin(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_linear=mean(classiError_leave_one_lin);

classiError_leave_one_diaglin=[];
erreur_classi_leave_one_diaglin=[];
for k=1:648
    training_set = subfeatures(find(cd.training(k)==1),:);
    test_set = subfeatures(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_diaglin(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_diaglin=mean(classiError_leave_one_diaglin);

classiError_leave_one_quadri=[];
erreur_classi_leave_one_quadri=[];


for k=1:648
    training_set = subfeatures(find(cd.training(k)==1),:);
    test_set = subfeatures(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd.training(k)==1),:), 'discrimtype', 'quadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd.test(k)==1));
    classiError_leave_one_quadri(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_quadri=mean(classiError_leave_one_quadri);

%POINT 4

%Pour l'instant on a deux partitions : cd -> 10-fold et cv -> 648-fold
%leave one out. Pour les deux on cr�e une nouvelle version gr�ce �
%r�partiionqui donne un nouvel objet de la m�me classe mais avec une
%r�partition diff�rentes des samples dans les set

classiError_linear_repartition=[];
cv_new=repartition(cv);

%on teste si les partitions sont bien diff�rentes : retourne 0 si
%diff�rents
isequal(test(cv,1),test(cv_new,1))

%et on recommence...

erreur_classi_linear_repartition=[];
for k=1:10
   
    training_set = subfeatures(find(cv_new.training(k)==1),:);
    test_set = subfeatures(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_linear_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_linear_repartition=mean(classiError_linear_repartition);

classiError_diaglinear_repartition=[];
erreur_classi_diaglinear_repartition=[];

for k=1:10
   
    training_set = subfeatures(find(cv_new.training(k)==1),:);
    test_set = subfeatures(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_diaglinear_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_diaglinear_repartition=mean(classiError_diaglinear_repartition);

classiError_quadra_repartition=[];
erreur_classi_quadra_repartition=[];

for k=1:10
   
    training_set = subfeatures(find(cv_new.training(k)==1),:);
    test_set = subfeatures(find(cv_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cv_new.training(k)==1),:), 'discrimtype', 'quadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cv_new.test(k)==1));
    classiError_quadra_repartition(1,k) =  sum(yhat~=labels_test)/yhatLine;
end

erreur_classi_quadra_repartition=mean(classiError_quadra_repartition);

cd_new=repartition(cd);

classiError_leave_one_linear_new=[];
erreur_classi_leave_one_linear_new=[];

for k=1:648
    training_set = subfeatures(find(cd_new.training(k)==1),:);
    test_set = subfeatures(find(cd.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'linear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_linear_new(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_linear_new=mean(classiError_leave_one_linear_new);

classiError_leave_one_diaglinear_new=[];
erreur_classi_leave_one_diaglinear_new=[];
for k=1:648
    training_set = subfeatures(find(cd_new.training(k)==1),:);
    test_set = subfeatures(find(cd_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'diaglinear');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_diaglinear_new(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_diaglinear_new=mean(classiError_leave_one_diaglinear_new);

classiError_leave_one_quadri_new=[];
erreur_classi_leave_one_quadri_new=[];

for k=1:648
    training_set = subfeatures(find(cd_new.training(k)==1),:);
    test_set = subfeatures(find(cd_new.test(k)==1),:);
   
    classifier = fitcdiscr(training_set, labels(find(cd_new.training(k)==1),:), 'discrimtype', 'quadratic');
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(cd_new.test(k)==1));
    classiError_leave_one_quadri_new(1,k) =  sum(yhat~=labels_test)/648;
end

erreur_classi_leave_one_quadri_new = mean(classiError_leave_one_quadri_new);

%Si on regarde les variables qui contiennent les valeurs des erreurs on
%peut voir que l'erreur varie tr�s peu en changeant les r�partition avec
%les 10-fold cross-validation ce qui montre que les cross validation sont
%un bon moyen de valider le mod�le. Pour les leave-one-out on a exactement
%la m�me erreur (sauf pour linear a 2.10E-04 pr�s ce qui n'est pas normal)
%ce qui est logique puisqu'il n'y a qu'un seul sample par set on a beau
%changer la r�partition c'est exactement la m�me chose. On voit aussi que
%l'erreur est bcp plus faible avec la leave one out mais la variance sera
%bcp plus grande. La LOOCV est p�f�rable pour les set contenant peu de data
%comme ici