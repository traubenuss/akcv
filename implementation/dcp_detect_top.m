function Cluster = dcp_detect_top(params, C, D2, hog_patches)

scores = zeros(1,size(D2,2));
for i = 1:size(D2,2)

    [~, ~, scores(i)] = svmpredict(rand(1), double(hog_patches{D2(i)}.hog(:)'), C);
    %scores(i) = C.w'*hog_patches{D2(i)}.hog(:) - C.b;
end

[sorted_scores, sorted_index] = sort(scores,'descend');  % Sort the values in
                                                         % descending order


max_index = sorted_index(1:params.new_cluster_by_top_m);

Cluster.members = D2(max_index);
Cluster.C = C;
Cluster.scores = sorted_scores(1:params.new_cluster_by_top_m);
Cluster.score = sum(Cluster.scores);

end
