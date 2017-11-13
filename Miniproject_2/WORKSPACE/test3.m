clear all;
load dataset_ERP.mat;



cm = cvpartition(labels,'kfold',2);


  
   
    
   labels_set1 = labels(find(cm.training(1)==1),:);

   training_set = features(find(cm.training(1)==1),:); 
 
   classifier = fitcdiscr(training_set, labels_set1, 'discrimtype', 'linear');
    
   yhat = predict(classifier,training_set);
    
   disp(classerror(labels_set1,yhat));
    