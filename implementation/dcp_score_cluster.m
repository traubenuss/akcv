function cluster_scores = dcp_score_cluster(params, Clusters, D, N)

%first, compute purity of the cluster (=> SVM score of top r cluster
%members, where r > m to evaluate generalization)

cluster_size = size(cluster,1);

cluster_scores = ones(cluster_size,1);

for cluster_index=1:cluster_size
    cluster_members = D(Clusters{cluster_index}.members);

    patch_scores = ones(size(cluster_members,1),1);
    
    for member_index=1:size(cluster_members,1)
        patch = hog_patches{cluster_members(member_index)}.hog(:);
        patch_scores(member_index) = Clusters.C.w'*patch - Clusters.C.b;        
    end
    
    [sorted_patch_scores, sorted_patch_index] = sort(patch_scores,'descend');
    
    cluster_scores(cluster_index) = sum(sorted_patch_scores(1:params.cluster_purity_r));                                                        
end


%now, calculate discriminativeness and add to cluster scores