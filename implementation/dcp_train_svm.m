function  C = dcp_train_svm(params, members_i, hog_patches, N1, world_set)


% fill the data vector
%X = zeros(size(hog_patches{1}.hog(:),1), size(members_i,2) + size(N1,2));

X_pos = zeros(size(hog_patches{1}.hog(:),1), size(members_i,2));
%X_neg = world_set(:,N1);%zeros(size(hog_patches{1}.hog(:),1), size(N1, 2));

for i = 1:size(members_i,2)
    X_pos(:,i) = hog_patches{members_i(i)}.hog(:);
end

% set labels
Y_pos = int8(ones(1,size(members_i,2)));
Y_neg = int8(-1*ones(1,size(N1,2)));

% negative hard mining
[C.w C.b] = vl_pegasos([X_pos world_set(:,N1)], [Y_pos Y_neg], 0.1);

for i = 1:params.svm_hard_minining_niters
    % classify the negative set (N1)
    y_negatives = C.w'*world_set(:,N1) - C.b;
    
    % where was this negative set false classified?
    hard_minings = find(y_negatives > params.svm_min_score);
    Y_neg = int8(-1*ones(1,size(hard_minings,2)));
    
    [C.w C.b] = vl_pegasos([X_pos world_set(:,hard_minings)], [Y_pos Y_neg], 0.1);
    display(['train SVM.. ', num2str(i), ' / ', num2str(params.svm_hard_minining_niters),...
             ' Negatives: ', num2str(numel(hard_minings))]);
end 


end