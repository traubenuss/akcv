function cluster_scores = dcp_score_cluster(params, Clusters, D, N, hog_patches)

%first, compute purity of the cluster (=> SVM score of top r cluster
%members, where r > m to evaluate generalization)

cluster_size = size(Clusters,2);

parfor cluster_index=1:cluster_size
    
    num_patches_D = size(D,2);
    patch_scores = ones(1,size(D,2));
    
    for member_index=1:num_patches_D
        patch = hog_patches{D(member_index)}.hog(:);
        patch_scores(member_index) = Clusters{cluster_index}.C.w'*patch - Clusters{cluster_index}.C.b;        
    end
    
    patch_scores = patch_scores(patch_scores > params.svm_min_score);
    num_firings_D = sum(patch_scores);
    
    [sorted_patch_scores, sorted_patch_index] = sort(patch_scores,'descend');
    
    purity = sum(sorted_patch_scores(1:params.cluster_purity_r));   
    Clusters{cluster_index}.topRPatchesScore = sorted_patch_scores(1:params.cluster_purity_r);
        
    N_scores = Clusters{cluster_index}.C.w'*N - Clusters{cluster_index}.C.b;
    N_scores = N_scores(N_scores > params.svm_min_score);
    num_firings_N = sum(N_scores);
    
    discriminativeness = num_firings_D / num_firings_N;
    
    Clusters{cluster_index}.score = purity + params.discriminativeness_weight * discriminativeness;
    
end


%now, calculate discriminativeness and add to cluster scores