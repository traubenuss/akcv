function K = dcp_kmeans(params, S, hog_patches)

% extract relevant HOGs into matrix
data = zeros(size(hog_patches{1}.hog,1), size(S,2));
for i = 1:size(S,2)
    data(:,i) = hog_.patches{S(i)}.hog;
end

% cols = datapoints
% rows = dimensions
[~, ndata] = size(data);

nclusters = floor(ndata/params.kmeans_nclusterfactor)

[centers assign] = vl_kmeans(data, nclusters,...
                           'distance', params.kmeans_distance, ...
                           'algorithm', params.kmeans_algorithm);
                       
K.centers    = centers;
K.assignment = assign;

% delete clusters, with less than 3 patches

end