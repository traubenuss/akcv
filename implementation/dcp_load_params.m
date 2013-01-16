function params = dcp_load_params

% DCP Extract
params.npatches = 10;
params.one_patch_out_of = 2000;

params.pat_maxsz = 300;
params.pat_minsz = 80;

% k-means specific
params.kmeans_nclusterfactor = 4;
params.kmeans_distance = 'l2';
params.kmeans_algorithm = 'elkan';

% SVM specific


end