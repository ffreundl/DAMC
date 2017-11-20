

%% Guidesheet 6: 
close all;
clear all;
clc

%load('finalresultsGS5.mat') % Useful results from Guidesheet 5. This is a 
% big file, to be joined by the author. Since only the finalTestErrors
% vector is necessary here, it is provided as such in this code, and is
% identical as the one obtained from 'finalresultsGS5.mat'.

finalTestErrors = [0.2790    0.1625    0.1723    0.2115    0.0865    0.2019    0.1731    0.2500    0.1731 0.2029] % can be commented if you possess 'finalResultsGS5.mat'
mFTE = mean(finalTestErrors)
stdFTE=std(finalTestErrors)
%% What is the mean test error across outer folds? 
% What is the standard deviation of the test error across outer folds?

% ANS: These answer have been computed above in Guidesheet 5.

%% How do the test error values compare to the random level?

% ANS: The mean test error is of 0.1913 and is sufficiently away from the
% 0,5 random distribution, so that it might well be statistically
% different...

%% Do a t-test of the hypothesis that the test error values across outer
% folds come from a distribution with mean 50% ([h, p] = ttest(error,
% 0.5)). Is your p-value significant?

[h,p] = ttest(finalTestErrors, 0.5)

% ANS: The obtain p-value is of 1.67e-08, which means that if the
% null hypothesis Ho - "The samples come from a random distribution." - was
% true, then our distribution and any other distribution of the same size
% would have this 1.6703e-08 chance to exist or being even more divergent from
% the null hypothesis. Since we do have observed these results, it means
% that it is highly improbable that we got these 1.6703e-08 chance. So, it
% implies that the null hypothesis is to be rejected: our samples do not
% come from the sample distribution. (Simplier: p < 0.05 (5%), reject Ho).
% To confirm, h = 1 means "rejected" in this matlab function. 

%% The function ttest assumes that data are normally distributed.  Draw a histogram of the
% outer fold’s test error values.  Does it look normal?

a1=histogram(finalTestErrors,'FaceAlpha',0.7, 'FaceColor',[0.9100    0.4100    0.1700])
xlabel('Test errors of the 10 outer folds','FontSize',14,'FontWeight','bold','Color','k')
title('Distribution of the outer folds test-error values', 'FontSize', 16)

% ANS: The histogram looks not normally distributed...

%% To test if your data are normally distributed, perform a Kolmogorov-Smirnov test
% (Matlab function: h = kstest(x), where x is the standardized test error values
%(=(error - mean(error))/std(error))

% Calculating the standardised values:
% But first creates a vector of mean(finalTestErrors) of the same
% dimensions. If we don't we cannot apply
meanVect = [mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors) mean(finalTestErrors)]
stdFinalTestErrors = ((finalTestErrors - meanVect)/std(finalTestErrors))

[KSTest_Reject,KST_P] = kstest(stdFinalTestErrors)

[p_W, h_W] = signrank(stdFinalTestErrors, 0.5)

% ANS: The Kolgomorov-Smirnov test, that checks for the Ho hypothesis
% stating that samples could've come from a standard normal distribution
% N(0,1), does NOT reject that hypothesis (H =: KSTest_Reject = 0). So our
% finalTestErrors distribution is, indeed, normally distributed.
% Furthermore, the Wilcoxon-Mann-Whitney [p_W, h_W] test, that checks for
% the Ho hypothesis stating that the data in the vector X come from a 
% distribution thats median (and mean, if it exists) is zero, does NOT
% reject that hypothesis. However, this test seems pointless here. 

%% THE FINAL CLASSIFIER: A design.

