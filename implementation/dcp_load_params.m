function params = dcp_load_params

%==========================================================================
% WORLD SET SPECIFIC

%absolute path to image dir
params.img_dir = '/home/cbichler/Dokumente/Studium/AKCV/SUN2012pascalformat/JPEGImages';
params.n_images= 6000;

%minimum and maximum numbers of patches the algorithm
%extracts from images of the world set
params.n_ppi_min = 40;
params.n_ppi_max = 60;

%==========================================================================
% HOG Descriptor
params.hog_cell_size = 10;
params.hog_num_orient = 9;
params.hog_stride = 8;
params.hog_sz = 1984;
%==========================================================================
% DCP Extract
params.npatches = 10;  % number of patches which should be found
params.one_patch_out_of = 1000;%2000;  % how many patches should be considered
                                 % when detecting one discriminative patch
                                 % (controls runtime)
params.max_npatches_per_pic = 1000;
                                 
params.pat_maxsz = 300; % maximum size of one patch
params.pat_minsz = 80;  % minimum size of one patch (must not be smaller than
                        % the size of the HOG features)


params.prune_clusters_thres = 3; % remove clusters with less than this
                                 % number of elements
                        
% k-means specific
params.kmeans_init_grad_threshold = 300; % threshold for the gradient energy
                                         % if a patch is chosen for the
                                         % initial cluserting
params.kmeans_init_S_sz = 1/10; % which portion of the patches of the half 
                                % discovery set is used for the first
                                % clustering
params.kmeans_nclusterfactor = 4;
params.kmeans_distance = 'l2';
params.kmeans_algorithm = 'elkan';

% SVM specific

params.C = 0.1;


end
