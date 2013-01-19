function patches = dcp_get_patches_of_best_cluster(params, Clusters, list, hog_patches)

% select top
the_best_score = -inf;
for i = 1:size(Clusters,2)
    if Clusters{i}.score > the_best_score
       the_best = Clusters{i};
       the_best_score = Clusters{i}.score;
    end
end

display(['getPatchesOfBestCluster: Best score: ', num2str(the_best_score), ...
         ' with ', num2str(numel(the_best.members)), ' members']);

% return the patch information
if strcmp(list, 'topRPatchesIndex')
    npatches = numel(the_best.topRPatchesIndex);
    patches = cell(1,npatches);
    for i = 1:size(patches,2)
        patches{i}.img_nr = hog_patches{the_best.topRPatchesIndex(i)}.img_nr;
        patches{i}.rect   = hog_patches{the_best.topRPatchesIndex(i)}.rect;
    end
else
    npatches = numel(the_best.members);
    patches = cell(1,npatches);
    for i = 1:size(patches,2)
        patches{i}.img_nr = hog_patches{the_best.members(i)}.img_nr;
        patches{i}.rect   = hog_patches{the_best.members(i)}.rect;
    end
end

end