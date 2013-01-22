function patches = dcp_get_patches_of_best_cluster(params, Clusters, list, hog_patches)

% select top
%the_best_score = -inf;
scores = zeros(1, size(Clusters,2));
for i = 1:size(Clusters,2)
    scores(i) = Clusters{i}.score;
    %if Clusters{i}.score > the_best_score
    %   the_best = Clusters{i};
    %   the_best_score = Clusters{i}.score;
    %end
end

[~, sorted_index] = sort(scores, 'descend');

% return the patch information
if strcmp(list, 'topRPatchesIndex')
    patches = cell(params.num_of_best_clusters,params.cluster_purity_r);
    for j = 1:params.num_of_best_clusters
        the_best = Clusters{sorted_index(j)};
        display(['getPatchesOfBestCluster: Best score: ', num2str(the_best.score), ...
            ' with ', num2str(numel(the_best.topRPatchesIndex)), ' members']);
        npatches = numel(the_best.topRPatchesIndex);
        %patches = cell(params.num_of_best_clusters,npatches);
        for i = 1:npatches
            patches{j,i}.img_nr = hog_patches{the_best.topRPatchesIndex(i)}.img_nr;
            patches{j,i}.rect   = hog_patches{the_best.topRPatchesIndex(i)}.rect;
            patches{j,i}.score  = the_best.topRPatchesScore(i);
        end
    end
else
    display(['getPatchesOfBestCluster: Best score: ', num2str(the_best.score), ...
        ' with ', num2str(numel(the_best.members)), ' members']);
    npatches = numel(the_best.members);
    patches = cell(1,npatches);
    for i = 1:size(patches,2)
        patches{i}.img_nr = hog_patches{the_best.members(i)}.img_nr;
        patches{i}.rect   = hog_patches{the_best.members(i)}.rect;
        patches{i}.score  = the_best.scores(i);
    end
end

end

