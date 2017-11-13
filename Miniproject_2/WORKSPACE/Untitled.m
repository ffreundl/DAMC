cv=cvpartition(labels,'kfold',10);

for i=1:10
   sum(labels(cv.test(i)))
end