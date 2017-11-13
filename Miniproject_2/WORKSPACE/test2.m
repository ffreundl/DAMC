clear all;

load dataset_ERP.mat;


cv = cvpartition(labels,'kfold',2);

set_1 = features(find(cv.training(1)==1),:);

set_2 = features(find(cv.training(1)==1),:);

labels_set_1 = labels(find(cv.training(1)==1));


classifier = fitcdiscr(set_1, labels_set_1, 'discrimtype', 'linear');
yhat_set1 = predict(classifier,set_1);


disp(classerror(labels_set_1,yhat_set1));

