clear all;
load dataset_ERP.mat;

%we choose to use a pre-selected subset of feature since the wrapper
%methods are very expensive 
subfeatures=features(:,1:100:2400);


cp = cvpartition(labels,'kfold',10);


% The forward feature selection start by selecting the best performing
% single feature in term of classification error. Then all pairwise
% combinations of the remaining features the already selected one are
% tested. The one with the best performance is selected. Then we add a
% third features that leads to best performance. 

%The function use a criterion to evaluate the performance of a feature
%combination and stop adding features when there is no more improvements in
%the prediction criterion.

%sequentials calls cv as a parameter for the valisdation method. It perform
%the inner-loop cross-validation to dermine the optimal number of features

%fun is the function that defines the criterion used to select features and
% to determine when to stop. un uses XTRAIN and ytrain to train or fit a model, 
%then predicts values for XTEST using that model, and finally returns some measure of distance,
% or loss, of those predicted values from ytest. X corresponds to samples
% and Y to the labels.
%In the cross validation calculation for a given candidate feature set,
%sequentialfs sums the values returned by fun and divides that sum by the
%total number of test observations.

fun = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','diaglinear'), xt)));


%We used a diaglinear classifier, options corresponds to the
%characteristics of the iterative sequential search algorithm. 100
%corresponds to the maximum number of iterations allowed.
opt = statset('Display','iter','MaxIter',100);

[sel, hst] = sequentialfs(fun,subfeatures,labels,'cv',cp,'options',opt);

%Forward feature selection is a wrapper method : we use a subset of
%features and train a model using them. Bases on the results from the
%previous model we decide to add or remove feature from your subset wheras
%in filter methods you don't use any machine learning algorithms. The
%features are selected on the basis of their scores in various statistical
%test as Fisher score method. For Fisher score method we use 
% a projection of the high-dimensional sample onto a one-dimensional space
% and we maximize a function representing the difference between the
% projected class means. This represent the intra-class similarity and
% inter-classe non similarity. Forward Feature selection select a model
% studying the classerror of feature  association itteratively.