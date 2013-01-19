function Clusters = dcp_score_cluster(params, Clusters, world_set, hog_patches)

%first, compute purity of the cluster (=> SVM score of top r cluster
%members, where r > m to evaluate generalization)

cluster_size = size(Clusters,2);

parfor cluster_index=1:cluster_size
    
    num_patches_D = size(hog_patches,2);
    patch_scores = ones(1, num_patches_D);
    
    for member_index=1:num_patches_D
        patch = double(hog_patches{member_index}.hog(:)');
        [~, ~, patch_scores(member_index)] = svmpredict(rand(1), patch, Clusters{cluster_index}.C, '-q');
        %patch_scores(member_index) = Clusters{cluster_index}.C.w'*patch - Clusters{cluster_index}.C.b;        
    end
 
    num_firings_D = sum(patch_scores > params.svm_min_score);
    patch_scores = patch_scores(patch_scores > params.svm_min_score);
    
    [sorted_patch_scores, sorted_patch_indizes] = sort(patch_scores,'descend');
    
    endindex = min(params.cluster_purity_r,size(patch_scores,2));
    purity = sum(sorted_patch_scores(1:endindex)-params.svm_min_score)/endindex;   
    Clusters{cluster_index}.topRPatchesScore = sorted_patch_scores(1:endindex);
    Clusters{cluster_index}.topRPatchesIndex = sorted_patch_indizes(1:endindex);
        
    [~, ~, N_scores] = svmpredict(rand(size(world_set',1),1), double(world_set)', Clusters{cluster_index}.C, '-q');
    %N_scores = Clusters{cluster_index}.C.w'*world_set - Clusters{cluster_index}.C.b;
    num_firings_N = sum(N_scores > params.svm_min_score);
    
    discriminativeness = num_firings_D / num_firings_N;
    
    Clusters{cluster_index}.score = purity + params.discriminativeness_weight * discriminativeness;
    Clusters{cluster_index}.purity = purity;
    Clusters{cluster_index}.discriminativeness = discriminativeness;
    
end