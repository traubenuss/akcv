function params = dcp_load_params

%==========================================================================
% WORLD SET SPECIFIC

%absolute path to image dir
params.img_dir = 'SUN2012pascalformat/JPEGImages';
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
params.npatches = 5;  % number of patches which should be found
params.one_patch_out_of = 2000;  % how many patches should be considered
                                 % when detecting one discriminative patch
                                 % (controls runtime)
params.max_npatches_per_pic = 35;
                                 
params.pat_maxsz = 250; % maximum size of one patch
params.pat_minsz = 80;  % minimum size of one patch (must not be smaller than
                        % the size of the HOG features)

params.niterations = 5;
                        
params.prune_clusters_thres = 3; % remove clusters with less than this
                                 % number of elements
params.new_cluster_by_top_m = 5;
                        
% k-means specific
params.kmeans_init_grad_threshold = 150; % threshold for the gradient sum
                                         % if a patch is chosen for the
                                         % initial cluserting
params.kmeans_init_S_sz = 1/7; % which portion of the patches of the half 
                                % discovery set is used for the first
                                % clustering
params.kmeans_nclusterfactor = 4;
params.kmeans_distance = 'l2';
params.kmeans_algorithm = 'elkan';

% SVM specific

params.svm_C = 0.1;
params.svm_hard_minining_niters = 0; % number of iterations of negative hard mining
params.svm_min_score = -0.9;
params.svm_prune_clusters_thres = 3; % remove clusters with less then this firings on the validation set


% Evaluation

params.cluster_purity_r = 10;
params.discriminativeness_weight = 1;

params.show_intermediate_results = true;
params.nintermed_patches_to_visualise = 5;

params.num_of_best_clusters = 3;

end
