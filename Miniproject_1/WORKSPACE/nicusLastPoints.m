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

%The following definitions come from the MATLAB documentation
%CalinskiHarabasz is a criterion based on variances. The value to minimize is the ratio of overall 
%between-cluster variance and the overall within-cluster varance, times (N-k)/(k-1).
%With the silhouette criterion, one minimizes the value of the same name : S = (b-a)/max(a,b)
%For a point a is the average distance to the other points of the same cluster and b the minimum
%distance to another point from a different cluster (max(a,b) seems to be here to normalize the
%range from -1 to 1). For a high value, points are near each other within a clusters, but far away
%from other clusters, then the clustering is consistent. Else, a negative value will show inconsistency.
%(Does matlab compute the silhouette for every points ?!? that would explain chronophagy)
%Gap criterion maximizes the value Gap=Expatation(log(Wk))-log(Wk) where Wk is pooled within-cluster measurment.
