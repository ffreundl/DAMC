
function [ output_args ] = comparaison(x)
load classOnePositions.m
load classZeroPositions.m
histogram(features(classZeroPositions,x),'Normalization','probability')
hold on 
histogram(features(classOnePositions,x),'Normalization','probability')

end

