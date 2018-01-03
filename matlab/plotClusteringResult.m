%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Machine Vision and Cognitive Robotics WS 2014 - Exercise 5
% HELPER FUNCTION TO DISPLAY CLUSTERING RESULT FOR POINTCLOUD P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = plotClusteringResult(p, clusters, point2cluster)
% cluster colors
ColorSet = [
0.00 0.00 1.00 % Data 1 - blue
0.00 1.00 0.00 % Data 2 - green
1.00 0.00 0.00 % Data 3 - red
0.00 1.00 1.00 % Data 4 - cyan
1.00 0.00 1.00 % Data 5 - magenta
0.75 0.75 0.00 % Data 6 - RGB
0.25 0.25 0.25 % Data 7
0.75 0.25 0.25 % Data 8
0.95 0.95 0.00 % Data 9
0.25 0.25 0.75 % Data 10
0.75 0.75 0.75 % Data 11
0.00 0.50 0.00 % Data 12
0.76 0.57 0.17 % Data 13
0.54 0.63 0.22 % Data 14
0.34 0.57 0.92 % Data 15
1.00 0.10 0.60 % Data 16
0.88 0.75 0.73 % Data 17
0.10 0.49 0.47 % Data 18
0.66 0.34 0.65 % Data 19
0.99 0.41 0.23 % Data 20
];

for c=1:size(clusters,2)
    % find all points belonging to cluster nr i
    idx = (point2cluster == c);
    
    % don't display too small clusters
    if sum(idx) > 100
        plot3(p(1,idx),p(2,idx),p(3,idx), ...
            'Color',ColorSet(mod(c,size(ColorSet,1))+1,:), ...
            'Marker','.','LineStyle','None'); hold on;
        
        % plot cluster center in black
        scatter3(clusters(1,c),clusters(2,c),clusters(3,c),'k','filled');
    end
end 

hold off;
set(gca,'ZDir','reverse');
set(gca,'XDir','reverse');
view(180,90);
