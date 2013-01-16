function params = dcp_load_params

%==========================================================================
% WORLD SET SPECIFIC

%absolute path to image dir
params.img_dir = 'world_set_images';
params.n_images= 10;

%minimum and maximum numbers of patches the algorithm
%extracts from images of the world set
params.n_ppi_min = 10;
params.n_ppi_max = 30;

%==========================================================================
% DCP Extract
params.npatches = 10;  % number of patches which should be found
params.one_patch_out_of = 2000;  % how many patches should be considered
                                 % when detecting one discriminative patch
                                 % (controls runtime)
                                 
params.pat_maxsz = 300; % maximum size of one patch
params.pat_minsz = 80;  % minimum size of one patch (must not be smaller than
                        % the size of the HOG features)


                        
% k-means specific
params.kmeans_init_grad_threshold = 100; % threshold for the gradient energy
                                         % if a patch is chosen for the
                                         % initial cluserting
params.kmeans_init_S_sz = 1/20;
params.kmeans_nclusterfactor = 4;
params.kmeans_distance = 'l2';
params.kmeans_algorithm = 'elkan';

% SVM specific


end
