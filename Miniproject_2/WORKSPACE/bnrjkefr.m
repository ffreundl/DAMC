fun = @(xT,yT,xt,yt) length(yt)*(classerror(yt,predict(fitcdiscr(xT,yT,'discrimtype','diaglinear'), xt)));


%We used a diaglinear classifier, options corresponds to the
%characteristics of the iterative sequential search algorithm. 100
%corresponds to the maximum number of iterations allowed.
opt = statset('Display','iter','MaxIter',100);

[sel, hst] = sequentialfs(fun,subfeatures,labels,'cv',cp,'options',opt);