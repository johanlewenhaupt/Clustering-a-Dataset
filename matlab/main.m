%===================================================
% Machine Vision and Cognitive Robotics (376.054)
% Exercise 5: Clustering
% Daniel Wolf, 2015
% Automation & Control Institute, TU Wien
%
% Tutors: machinevision@acin.tuwien.ac.at
%
% MAIN SCRIPT - DO NOT CHANGE CODE EXCEPT FOR THE PARAMETER SETTINGS
%===================================================
clear all; close all;
%%%%%%%% SELECT POINTCLOUD FILE %%%%%%%%
pointcloud_idx = 0;            % 0-9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% CHANGE RANSAC PARAMETERS HERE %%%%
inlier_margin = 0.02;      % in meters
min_sample_dist = 0.1;     % in meters
fitting_confidence = 0.99;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% CHANGE CLUSTERING PARAMETERS HERE %%
subsamplerate = 10;
maxdist = 0.1;           % in meters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PART 1: RANSAC

% path to load pcd file function
addpath matpcl;

% load point cloud from file
p = double(loadpcd(sprintf('pointclouds/image%03d.pcd',pointcloud_idx)));
% rearrange point cloud
p = reshape(p, size(p,1)*size(p,2),size(p,3))';
% delete all [0;0;0] entries
idx = (all(p(1:3,:) == zeros(3,size(p,2))));
p = p(:,~idx);

figure(1);
plotPointCloud(p);
title(sprintf('Pointcloud %d', pointcloud_idx));

fprintf(1,'Trying to fit a plane with RANSAC...\n');

h=tic;
% Calling your function
[a,b,c,d,inliers,sample_count] = fitPlaneRANSAC(p, fitting_confidence, ...
                                          inlier_margin, min_sample_dist);
toc(h)

fprintf(1, 'DONE. %d iterations needed.\n', ...
    sample_count);

figure(2);
plotPointCloud(p, a, b, c, d, inliers);    
title(sprintf('Pointcloud %d', pointcloud_idx));


%% PART 2: CLUSTERING

% remove all points of the plane
p2 = p(:,~inliers);
% subsample pointcloud for speedup
psub = p2(:,1:subsamplerate:end);

fprintf(1,'Cluster the remaining points...\n');

g = tic;
% Calling your function
[clusters, point2cluster] = clustering(psub,maxdist);
toc(g)

fprintf(1,'DONE. %d clusters found.\n', size(clusters,2));

figure(3);
plotClusteringResult(psub, clusters, point2cluster);
title(sprintf('Pointcloud %d', pointcloud_idx));
