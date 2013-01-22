function Clusters = dcp_score_cluster(params, Clusters, world_set, hog_patches)

%first, compute purity of the cluster (=> SVM score of top r cluster
%members, where r > m to evaluate generalization)

cluster_size = size(Clusters,2);

for cluster_index=1:cluster_size
    
    display(['Starting purity calc, Cluster ' num2str(cluster_index)])
    num_patches_D = size(hog_patches,2);
    patch_scores = ones(1,num_patches_D);
    
    parfor member_index=1:num_patches_D
        patch = double(hog_patches{member_index}.hog(:)');
        [~, ~, patch_scores(member_index)] = svmpredict(rand(1), patch, Clusters{cluster_index}.C);    

        %patch_scores(member_index) = Clusters{cluster_index}.C.w'*patch - Clusters{cluster_index}.C.b;        
    end
 
    [sorted_patch_scores, sorted_patch_indizes] = sort(patch_scores,'descend');
    
    % take only one best patch from 1 image into consideration
    i = 1;
    finished = false;
    chosen_pics   = zeros(1,params.cluster_purity_r); % indizes of HOG-patches
    chosen_idx    = zeros(1,params.cluster_purity_r);
    chosen_scores = zeros(1,params.cluster_purity_r);
    while ~finished
        img_nr = hog_patches{sorted_patch_indizes(i)}.img_nr;
        if sum(chosen_pics == img_nr) == 0 && sorted_patch_scores(i) > params.svm_min_score
            chosen_pics(i) = img_nr;
            chosen_idx(i) = sorted_patch_indizes(i);
            chosen_scores(i) = sorted_patch_scores(i);
        end
        if i >= length(sorted_patch_indizes) || ... % was the last element
           i >= params.cluster_purity_r || ... % no more elements needed
           sorted_patch_scores(i) <= params.svm_min_score % no more scores above threshold
               finished = true;
        end
        i = i + 1;
    end
    
    mask = (chosen_pics > 0); % remove zero elements
    chosen_idx = chosen_idx(mask);
    chosen_scores = chosen_scores(mask);
    
    Clusters{cluster_index}.topRPatchesScore = chosen_scores;%sorted_patch_scores(1:endindex);
    Clusters{cluster_index}.topRPatchesIndex = chosen_idx;%sorted_patch_indizes(1:endindex);
    
    purity = mean(chosen_scores-params.svm_min_score)/2; % scores from -1 to +1 expected, so (x-minsvm) /2
                                                         % should lead to normalisation to 0 - 1
    
                                                         
    % take only one patch out of 1 image, but consider all number of
    % firings for discriminativeness
    num_firings_D = sum(patch_scores > params.svm_min_score);
    
    % OLD VERSION:
    %endindex = min(params.cluster_purity_r,size(patch_scores,2));
    %purity = sum(sorted_patch_scores(1:endindex)-params.svm_min_score)/endindex;   
    %Clusters{cluster_index}.topRPatchesScore = sorted_patch_scores(1:endindex);
    %Clusters{cluster_index}.topRPatchesIndex = sorted_patch_indizes(1:endindex);
    
    display(['Starting discriminativeness calc, Cluster' num2str(cluster_index)])
    
    [~, ~, N_scores] = svmpredict(rand(size(world_set',1),1), double(world_set)', Clusters{cluster_index}.C);
    %N_scores = Clusters{cluster_index}.C.w'*world_set - Clusters{cluster_index}.C.b;
    num_firings_N = sum(N_scores > params.svm_min_score);
    
    if (num_firings_D + num_firings_N) > 0
        discriminativeness = num_firings_D / (num_firings_D + num_firings_N);
    else
        discriminativeness = 0;
    end
    
    Clusters{cluster_index}.score = purity + params.discriminativeness_weight * discriminativeness;
    Clusters{cluster_index}.purity = purity;
    Clusters{cluster_index}.discriminativeness = discriminativeness;
    
end