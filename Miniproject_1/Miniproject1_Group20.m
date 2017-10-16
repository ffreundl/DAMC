load spikes;

%% Visualisation of 10 random spikes out of the total 6000 in order to see how many types there could be

i = [12 800 1555 2050 2800 3700 4000 4200 4900 5555];
figure('name','Firing spikes of 10 random samples')
for j = i
    plot(spikes(j,:));
    hold on;
end
title('10 random spikes')
xlabel('Time [ms]','Fontsize',10,'Color','k');
ylabel('Amplitude [\muV]','Fontsize',10,'Color','k');

%% Visualisation of histogram and boxplots of the three features 

figure('name','Features distributions');
subplot(2,3,1);
histogram(spikesPCA(:,1));
ylabel('Number of samples','Fontsize',12,'Color','k');
title('Feature #1')

subplot(2,3,2);
histogram(spikesPCA(:,2));
ylabel('Number of samples','Fontsize',12,'Color','k');
title('Feature #2')

subplot(2,3,3);
histogram(spikesPCA(:,3));
ylabel('Number of samples','Fontsize',12,'Color','k');
title('Feature #3')

subplot(2,3,4);
boxplot(spikesPCA(:,1));
grid on;
ylabel('Number of samples','Fontsize',12,'Color','k');

subplot(2,3,5);
boxplot(spikesPCA(:,2));
grid on;
ylabel('Number of samples','Fontsize',12,'Color','k');

subplot(2,3,6);
boxplot(spikesPCA(:,3));
grid on;
ylabel('Number of samples','Fontsize',12,'Color','k');


%% Calculations of the clusters using k-means
%[idx,Centroids] = kmeans(spikesPCA,3);% segregates spikes in 3 clusters, based on their features (spikesPCA)
opts = statset('Display','final');
[idx,Centroids] = kmeans(spikesPCA,3,'Distance','cityblock','Replicates',10,'Options',opts);
Centroids % displays the location of the centroids of the 3 clusters

%% Scatter plot of 3 clusters

figure;
plot(spikesPCA(idx==1,1),spikesPCA(idx==1,2),'r.','MarkerSize',12)
hold on
plot(spikesPCA(idx==2,1),spikesPCA(idx==2,2),'b.','MarkerSize',12)
plot(spikesPCA(idx==3,1),spikesPCA(idx==3,2),'g.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3)
hold on 
%plot(C(:,3),'kx','MarkerSize',15,'LineWidth',3)
legend('Cluster 1','Cluster 2','Cluster 3','Centroids','Location','NW')
title 'Cluster Assignments and Centroids'
hold off

%% spikesPCA plotmatrix and gplotmatrix

figure('name', 'spikesPCA plotmatrix');
plotmatrix(spikesPCA);
title('1-to-1 scatter plots of features');

figure('name', 'spikesPCA gplotmatrix');
gplotmatrix(spikesPCA,[],idx) % plots 3 pairs of histogram of features 1vs2, 2vs3 and 3vs1, to detect clusters from their distribution
title('Scatter plots after 3-clustering');

%% spikes segregation

cluster1 = find(idx == 1); % indexes every spikesPCA sample eliciting a signal classified as "cluster 1"
cluster2 = find(idx==2); % idem for cluster 2
cluster3 = find(idx==3); % idem for cluster 3
mean1 = mean(spikes(cluster1,:)); % calcuates the mean fire signal of all spikes idexed as belonging to cluster 1
mean2 = mean(spikes(cluster2,:)); % idem for cluster 2 
mean3 = mean(spikes(cluster3,:)); % idem for cluster 3

%% Figure of means of 3 clusters
figure('name','Mean of all spikes for each cluster');
subplot(2,3,1);
a1 = plot(mean1);
xlabel('Time [ms]','Fontsize',10,'Color','k');
ylabel('Amplitude [\muV]','Fontsize',10,'Color','k');
title('Cluster 1')

subplot(2,3,2);
a2 = plot(mean2);
xlabel('Time [ms]','Fontsize',10,'Color','k');
ylabel('Amplitude [\muV]','Fontsize',10,'Color','k');
title('Cluster 2')

subplot(2,3,3);
a3 = plot(mean3);
xlabel('Time [ms]','Fontsize',10,'Color','k');
ylabel('Amplitude [\muV]','Fontsize',10,'Color','k');
title('Cluster 3')

subplot(2,3,4:6);
a1 = plot(mean1); M1 = 'Cluster 1'; hold on;
a2 = plot(mean2); M2 = 'Cluster 2'; hold on;
a3 = plot(mean3); M3 = 'Cluster 3';
legend([a1,a2,a3], M1, M2, M3)
xlabel('Time [ms]','Fontsize',10,'Color','k');
ylabel('Amplitude [\muV]','Fontsize',10,'Color','k');

%% Investigating different K's:

% plot with different group number, plot the value of the sums of the distance
%to the centroids

%toggle prolix as true if one wants to generate a lot of details
prolix=false;
maxOfGroups=10;
K=[1:maxOfGroups];

%initializing the sum of sums-by-cluster of the point to centroid distance
D=linspace(0.0,0.0,maxOfGroups);

%initializing a label matrix (plot purpose)
%if 6000 is previously stocked in a variable, put this variable. Nicolas Freundler
IDX=zeros(6000,maxOfGroups);

%this iterator works because it goes by +1
for iter = K
  [IDX(:,iter),~,sums]=kmeans(spikesPCA,iter);
  D(iter)=sum(sums);
  if(prolix)
    figure;
    gplotmatrix(spikesPCA,[],IDX(:,iter));
  end
end

figure
plot(D);
xlabel('Number of clusters K','Fontsize',12,'Color','k');
ylabel('Sums of distances','Fontsize',12,'Color','k');
title('Within-cluster sum of point-to-centroid distances','Fontsize',12)

%print
disp(D);

%The metrics allows us to use any number of clusters (yet not bigger than data number).
%There is two things we want to minimize : the sum of the point-to-centroid
%distance sums (considered as an error measurement) and the number of cluster
% (a big number gives a big complexity, until the preposterous case of k=6000)
%Regarding that, 3 was a good guess, but 2 and 4 could have been good enough. However,
%if we were based on a visual intuition, 3 is the best one without discusssion,c comparated to 2 and 4.

%% Last point: evalclusters

%last part, finding the best number of groups regarding different criteria
%MATLAB documentation give four criteria
%CalinskiHarabasz
%Silhouette
%gap
%DaviesBouldin
names=['CalinskiHarabasz','Silhouette','Gap','DaviesBouldin'];
CalHar=evalclusters(spikesPCA,IDX,'CalinskiHarabasz');
Sil=evalclusters(spikesPCA,IDX,'Silhouette');
gap=evalclusters(spikesPCA,'kmeans','Gap','KList',K);
DavBou=evalclusters(spikesPCA,IDX,'DaviesBouldin');

optimalValues=[CalHar.OptimalK, Sil.OptimalK, gap.OptimalK, DavBou.OptimalK];
optimalValues
%The following definitions come from the MATLAB documentation
%CalinskiHarabasz is a criterion based on variances. The value to minimize is the ratio of overall 
%between-cluster variance and the overall within-cluster varance, times (N-k)/(k-1).
%With the silhouette criterion, one minimizes the value of the same name : S = (b-a)/max(a,b)
%For a point a is the average distance to the other points of the same cluster and b the minimum
%distance to another point from a different cluster (max(a,b) seems to be here to normalize the
%range from -1 to 1). For a high value, points are near each other within a clusters, but far away
%from other clusters, then the clustering is consistent. Else, a negative value will show inconsistency.
%(Does matlab compute the silhouette for every points ?!? that would explain chronophagy)
%Gap criterion maximizes the value Gap=Expatation(log(Wk))-log(Wk) where Wk is pooled within-cluster measurment
%Davies Bouldin criterion is based on difference between within-cluster and between-cluster disctance.
%DaviesBouldin value = 1/k sumOf_i=1_to_k max(Dij) i different to j)
%where Dij is (average points-to-centroids of ith cluster +  the same for the jth cluster) over the distance from centroid i to
%centroid j.

%First of all, we're not going to use the Gap criterion because we're not familiar with the underlying concept; Silhouette and DaviesBouldin
%are geomatrically based and CalinskiHarabasz is based on variance analysis, which we are familiar with. Moreover, Gap criterion needs to much
%time. The quickest ones are CalinskiHarabasz and DaviesBouldin. That was an a priori comment, all the optimalK are computed for afterwards critics.
%The results are 3,2,7,2. Gap criterion can definitely be considered as unreasonnable to use in this situation. The remaining ones look all suitable,
%but CalinskiHarabasz criterion is prefered for it comforts our visual intuition.

