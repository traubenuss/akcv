function K = dcp_kmeans(params, data)

% cols = datapoints
% rows = dimensions
[~, ndata] = size(data);

nclusters = floor(ndata/params.kmeans_nclusterfactor);

[centers assign] = vl_kmeans(data, nclusters,...
                           'distance', params.kmeans_distance, ...
                           'algorithm', params.kmeans_algorithm);
                       
K.centers    = centers;
K.assignment = assign;

end