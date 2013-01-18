function Clusters = dcp_kmeans(params, S, hog_patches)

tic
% extract relevant HOGs into matrix
data = zeros(size(hog_patches{1}.hog(:),1), size(S,2));
for i = 1:size(S,2)
    data(:,i) = hog_patches{S(i)}.hog(:);
end

% cols = datapoints
% rows = dimensions
[~, ndata] = size(data);

nclusters = floor(ndata/params.kmeans_nclusterfactor)

[centers assign] = vl_kmeans(data, nclusters, 'verbose',...
                           'distance', params.kmeans_distance, ...
                           'algorithm', params.kmeans_algorithm);
                       


% delete clusters, with less than 3 patches
Clusters = cell(1, nclusters);
next_valid_cluster = 1; % does this a little speed up?
for i = 1:nclusters
    if sum(assign == i) >= params.prune_clusters_thres
        Clusters{next_valid_cluster}.members = find(assign == i);
        next_valid_cluster = next_valid_cluster + 1;
    else
        Clusters(next_valid_cluster) = [];
    end
end

toc

end