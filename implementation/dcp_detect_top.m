function Cluster = dcp_detect_top(params, C, D2, hog_patches)

scores = zeros(1,size(D2,2));
for i = 1:size(D2,2)

    [~, ~, scores(i)] = svmpredict(rand(1), double(hog_patches{D2(i)}.hog(:)'), C);
    %scores(i) = C.w'*hog_patches{D2(i)}.hog(:) - C.b;
end

[sorted_scores, sorted_index] = sort(scores,'descend');  % Sort the values in
                                                         % descending order
chosen_idx = []; % indizes of HOG-patches
chosen_pics = [];
chosen_scores = [];
i = 1;
finished = false;
while ~finished
    img_nr = hog_patches{D2(sorted_index(i))}.img_nr;
    if sum(chosen_pics == img_nr) == 0 && sorted_scores(i) > params.svm_min_score
        chosen_pics = [chosen_pics img_nr];
        chosen_idx = [chosen_idx D2(sorted_index(i))];
        chosen_scores = [chosen_scores sorted_scores(i)];
    end
    if i >= length(sorted_index) || ... % was the last element
       length(chosen_idx) >= params.new_cluster_by_top_m || ... % no more elements needed
       sorted_scores(i) <= params.svm_min_score % no more scores above threshold
          finished = true;
          %chosen_pics
          %chosen_idx
          %chosen_scores
    end
    i = i + 1;
end

Cluster.members = chosen_idx;
Cluster.C = C;
Cluster.scores = chosen_scores;
Cluster.score = sum(Cluster.scores);
                                                         
%to_score = min(sum(sorted_scores > params.svm_min_score), params.new_cluster_by_top_m);
%max_index = sorted_index(1:to_score);

%Cluster.members = D2(max_index);
%Cluster.C = C;
%Cluster.scores = sorted_scores(1:to_score);
%Cluster.score = sum(Cluster.scores);

end
