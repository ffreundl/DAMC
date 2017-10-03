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
D

%The metrics allows us to use any number of clusters (yet not bigger than data number).
%There is two things we want to minimize : the sum of the point-to-centroid
%distance sums (considered as an error measurement) and the number of cluster
% (a big number gives a big complexity, until the preposterous case of k=6000)
