%% plot with different group number, plot the value of the sums of the distance
%%to the centroids

%toggle true if one wants to generate a lot of details
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

%print
disp(D);

%The metrics allows us to use any number of clusters (yet not bigger than data number).
%There is two things we want to minimize : the sum of the point-to-centroid
%distance sums (considered as an error measurement) and the number of cluster
% (a big number gives a big complexity, until the preposterous case of k=6000)
%Regarding that, 3 was a good guess, but 2 and 4 could have been good enough. However,
%if we were based on a visual intuition, 3 is the best one without discusssion,c comparated to 2 and 4.
%%Last point
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
