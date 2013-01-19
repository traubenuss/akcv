function Cluster = dcp_detect_top(params, C, D2, hog_patches)

scores = zeros(1,size(D2,2));
for i = 1:size(D2,2)
    [~, ~, scores(i)] = svmpredict(rand(1), double(hog_patches{D2(i)}.hog(:)'), C, 'q');
    %scores(i) = C.w'*hog_patches{D2(i)}.hog(:) - C.b;
end

scores = scores(scores > params.svm_min_score);

[sorted_scores, sorted_index] = sort(scores,'descend');  % Sort the values in
                                                         % descending order

m = min(params.new_cluster_by_top_m, size(sorted_scores,2));
max_index = sorted_index(1:m);

Cluster.members = D2(max_index);
Cluster.C = C;
Cluster.scores = sorted_scores(1:m);
Cluster.score = sum(Cluster.scores-params.svm_min_score);

end