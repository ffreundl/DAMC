load spikes

idx = kmeans(spikesPCA,3)
gplotmatrix(spikesPCA,[],idx)
cluster1 = find(idx == 1) %find each neurons position in spikes PCA that belongs to cluster 1
cluster2 = find(idx==2)
cluster3 = find(idx==3)
mean1 = mean(spikes(cluster1,:))
mean2 = mean(spikes(cluster2,:))
mean3 = mean(spikes(cluster3,:))

figure; hold on
a1 = plot(mean1); M1 = 'Cluster 1';
a2 = plot(mean2); M2 = 'Cluster 2';
a3 = plot(mean3); M3 = 'Cluster 3';
legend([a1,a2,a3], M1, M2, M3)

figure;
subplot(2,3,1);
for i = cluster1(1):cluster1(size(cluster1)) 
    plot(spikes(i,:))
    hold on
end
subplot(2,3,2);
for i = cluster2(1):cluster2(size(cluster2)) 
    plot(spikes(i,:))
    hold on
end
i
subplot(2,3,3);
for i = cluster3(1):cluster3(size(cluster3)) 
    plot(spikes(i,:))
    hold on
end
i
subplot(2,3,4);
a1 = plot(mean1); M1 = 'Cluster 1';
hold on;

subplot(2,3,5);
a2 = plot(mean2); M2 = 'Cluster 2';
hold on;

subplot(2,3,6);
a3 = plot(mean3); M3 = 'Cluster 3';
hold on;
