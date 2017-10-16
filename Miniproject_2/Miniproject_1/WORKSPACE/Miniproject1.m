load spikes

idx = kmeans(spikesPCA,3)
gplotmatrix(spikesPCA,[],idx)
cluster1 = find(idx == 1) %find each neurons position in spikes PCA that belongs to cluster 1
cluster2 = find(idx==2)
cluster3 = find(idx==3)
mean1 = mean(spikes(cluster1,:))
mean2 = mean(spikes(cluster2,:))
mean3 = mean(spikes(cluster3,:))


figure;

subplot(2,3,1);
a1 = plot(mean1); M1 = 'Cluster 1';
title = 'Cluster 1';

subplot(2,3,2);
a2 = plot(mean2,'r'); M2 = 'Cluster 2';

subplot(2,3,3);
a3 = plot(mean3,'g'); M3 = 'Cluster 3';

subplot(2,3,4:6);
a1 = plot(mean1); M1 = 'Cluster 1';
hold on
a2 = plot(mean2,'r'); M2 = 'Cluster 2';
hold on;
a3 = plot(mean3,'g'); M3 = 'Cluster 3';

legend([a1,a2,a3], M1, M2, M3)

