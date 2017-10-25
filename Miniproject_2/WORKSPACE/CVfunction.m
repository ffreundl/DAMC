function [error] = CVfunction(dataset,partition, str, labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for k=1:10
    training_set = dataset(find(partition.training(k)==1),:); % Assure que l'on prenne les samples pour le training corrects de subfeatures
    test_set = dataset(find(partition.test(k)==1),:); % pareil avec test
   
    classifier = fitcdiscr(training_set, labels(find(partition.training(k)==1),:), 'discrimtype', str);
    yhat = predict(classifier,test_set);
    [yhatLine,yhatCol] = size(yhat);
    
    labels_test= labels(find(partition.test(k)==1)); % Donnera la VRAIE classe (0 ou 1) des entités du test set..
    classiError_linear(1,k) =  sum(yhat~=labels_test)/yhatLine; % .. on les compare avec la valeur de classe des entités du test set d'après notre modèle de classificateur. 
                                % Chaque fois que la valeur de classe
                                % donnée par le modèle est différente de la
                                % VRAIE valeur de classe, on a un "1" qui
                                % sort de la comparaison. 
end

error = mean(classiError_linear);

end

