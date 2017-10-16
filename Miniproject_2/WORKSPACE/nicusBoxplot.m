%1005 and 300 are alike
% and 2200 are different
figure

subplot(2,2,1)
title('asdf')
boxplot(features(:,1005))
title('Histogram for 1005th features')
ylim([-8 8])

grid on
subplot(2,2,2)
boxplot(features(:,300))
title('Histogram for 300th features')
ylim([-8 8])


grid on
subplot(2,2,3)
boxplot(features(:,2200))
title('Histogram for 2200th features')
ylim([-8 8])
grid on