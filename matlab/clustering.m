%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  function  [clusters, point2cluster] = clustering(p, maxdist)
%  purpose :    cluster pointcloud to isolate objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  input   arguments
%     p:               input pointcloud
%     maxdist:         Max. distace between two points of the same cluster (in meters)
%    
%  output   arguments
%     clusters:        coordinates of cluster centroids (3xC matrix, C = number of clusters)
%     point2cluster:   1xN vector, storing the assigned cluster number for each point
%
%   Author: Johan Lewenhaupt
%   MatrNr: 1624242
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [clusters, point2cluster] = clustering(p, maxdist)

%remove rows 4:6 in p, not needed and make further programming easier
p(4:6,:) = [];

%Get distance between points in pointcloud (they are already sampled in main file)
dist = ipdm(p(1:3,:)', 'metric',2);
distlog = dist < maxdist; %make matrix only have small enough distances


%create space for point2cluster
point2cluster = zeros(1,size(dist,1));

clusters = [];
clusterindex = 0;
thissum = 0;

while any(any(distlog)) %while we have points left to put in cluster
    clusterindex = clusterindex + 1; %which cluster we are at
    [this_row, this_col] = find(distlog); %index of the row we are at
    idx = find(distlog(this_row(1),:)); %indexes of the points in this cluster
    while numel(idx) ~= thissum %while points nearby this cluster
        thissum = numel(idx);   %update "checking value" if next iteration is to happen
        idx =(find(any(distlog(idx,:),1))); %find new indexes of the cluster points
    end
    point2cluster(idx) = clusterindex; %index the points to a cluster
    thissum = 0;
    distlog(idx,:) = 0;%delete points from matrix that are already clustered
    distlog(:,idx) = 0;%delete points from matrix that are already clustered
end

for i = 1:max(point2cluster)
    merge = p(1:3, find(point2cluster == i));
    merge_center = [(mean(merge(1,:))) mean(merge(2,:)) mean(merge(3,:))]'; 
    clusters = [clusters merge_center];
end
%clusters = clusters(:,all(~isnan(clusters)));

end

