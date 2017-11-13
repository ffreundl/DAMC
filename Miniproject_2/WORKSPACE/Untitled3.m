clear all;
load dataset_ERP.mat;

%training and testing error

cm = cvpartition(labels,'kfold',2);

%training error
   
    set1 = cm.training(1);
    set2 = cm.test(1);
    
    %on teste que les deux sets sont bien différents
    isequal(set1,set2);
    
    %point1 : on separe en deux sets de même tailles et on entraine un
    %classifier diaglinear
    
    training_set =features(find(set1==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set1==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diaglinear');
    testvar=sum(labels(find(set1==1))-labels(cm.training(1)));
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    training_error_diaglinear =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error, on train avec le set2 et on applique sur le set1
    
    training_set = features(find(set2==1),:); 
    test_set = features(find(set1==1),:); 
   
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'diaglinear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    testing_error_diaglinear =  sum(yhat~=labels_test)/yhatLine;
    
    %LINEAR
   
    %training error
    training_set = features(find(set1==1),:); 
    test_set = features(find(set1==1),:); 
    
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'linear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    training_error_linear =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error
    
    training_set = features(find(set2==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set1==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'linear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    testing_error_linear =  sum(yhat~=labels_test)/yhatLine;
    
    %DIAGQUADRATIC
    
     %training error
    training_set = features(find(set1==1),:); 
    test_set = features(find(set1==1),:); 
    
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    training_error_diagquadratic =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error
    
    training_set = features(find(set2==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set1==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set1==1));

    testing_error_diagquadratic =  sum(yhat~=labels_test)/yhatLine;
    
    %ON FAIT LA MEME CHOSE MAIS AVEC SET 2
    
     training_set =features(find(set2==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set2==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'diaglinear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    training_error_diaglinear_2 =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error, on train avec le set2 et on applique sur le set1
    
    training_set = features(find(set1==1),:); 
    test_set = features(find(set2==1),:); 
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diaglinear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    testing_error_diaglinear_2 =  sum(yhat~=labels_test)/yhatLine;
    
    %LINEAR
   
    %training error
    training_set = features(find(set2==1),:); 
    test_set = features(find(set2==1),:); 
    
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'linear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    training_error_linear_2 =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error
    
    training_set = features(find(set1==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set2==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'linear');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    testing_error_linear_2 =  sum(yhat~=labels_test)/yhatLine;
    
    %DIAGQUADRATIC
    
     %training error
    training_set = features(find(set2==1),:); 
    test_set = features(find(set2==1),:); 
    
    classifier = fitcdiscr(training_set, labels(find(set2==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    training_error_diagquadratic_2 =  sum(yhat~=labels_test)/yhatLine;
    
    %testing error
    
    training_set = features(find(set1==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set2==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));

    testing_error_diagquadratic_2 =  sum(yhat~=labels_test)/yhatLine;
    
    
    
    %final classifier confusion matrix
    
    training_set = features(find(set1==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set2==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));
    
    matrice = confusionmat(yhat,labels_test);
    
    disp(matrice);
    
    %calcul classification error
    
    %on fait une liste des erreurs, si on a 0 c'est que l'objet a bien 
    %été classé. Si 1 c'est un objet de classe 1 mal classé et si -1
    %un objet de classe 0 mal classé
    
   
  
    training_set = features(find(set1==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = features(find(set2==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(set1==1),:), 'discrimtype', 'diagquadratic');
     yhat = predict(classifier,test_set);
     [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(set2==1));
  
     nbr_class_zero = find(labels_test==0);
    [ZeroLine,ZeroCol]=size(nbr_class_zero);
    
    liste_error =labels_test - yhat;
    
    class_zero_misclassified = find(liste_error==-1);
    [Line0,Col0]=size(class_zero_misclassified);
    nbr_class_zero = find(labels_test==0);
    [ZeroLine,ZeroCol]=size(nbr_class_zero);
    
    class_one_misclassified=find(liste_error==1);
    [Line1,Col1]=size(class_one_misclassified);
    nbr_class_one = find(labels_test==1);
    [OneLine,OneCol]=size(nbr_class_one);
    
    final_class_error= 0.5*((Line1/OneLine)+(Line0/ZeroLine));
    
    final_classi_error=sum(yhat~=labels_test)/yhatLine;
    
    %on obtient l'erreur de classification à partir de la matrice de
    %confusion en additionnant le nombre de faux positif et faux négatif et
    %en divisant le tout par le nombre de sample. La matrice est plus
    %précise puisqu'elle nous indique directement les erreurs de classement
    %par classe. On a plusieurs classifier utilisé ici. La complexité de
    %chaque classifier peut être représenté par le nombre de paramètres
    %utilisés dans chaque méthode. Pour diaglinear on utilise 2 paramètres,
    %3 pour linear, 4 pour diagquadratic et 8 pour quadratic.
    % Si on veut donner plus de poids à une classe on peut simplement
    % utiliser prior probability pour déplacer la droite du classifier vers
    % une classe !