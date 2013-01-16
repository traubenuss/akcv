function params = dcp_load_params

%==========================================================================
% WORLD SET SPECIFIC

%absolute path to image dir
params.img_dir = '/home/cbichler/Dokumente/Studium/AKCV/world_set_images';
params.n_images= 10;

%minimum and maximum numbers of patches the algorithm
%extracts from images of the world set
params.n_ppi_min = 10;
params.n_ppi_max = 30;

%==========================================================================
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
