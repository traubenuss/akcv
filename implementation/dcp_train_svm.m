function  C = dcp_train_svm(params, members_i, hog_patches, N1, world_set)


% fill the data vector
%X = zeros(size(hog_patches{1}.hog(:),1), size(members_i,2) + size(N1,2));

%X_pos = zeros(size(hog_patches{1}.hog(:),1), size(members_i,2));
X_pos_svm = zeros(size(members_i,2), size(hog_patches{1}.hog(:),1));
%X_neg = world_set(:,N1);%zeros(size(hog_patches{1}.hog(:),1), size(N1, 2));

for i = 1:size(members_i,2)
    %X_pos(:,i) = hog_patches{members_i(i)}.hog(:);
    X_pos_svm(i,:) = hog_patches{members_i(i)}.hog(:)';
end

% set labels
%Y_pos = int8(ones(1,size(members_i,2)));
%Y_neg = int8(-1*ones(1,size(N1,2)));

Y_pos_svm = (ones(size(members_i,2),1));
Y_neg_svm = (-ones(size(N1,2),1));

% negative hard mining
%[C.w C.b] = vl_pegasos([X_pos world_set(:,N1)], [Y_pos Y_neg], 0.01, 'MaxIterations', 5000);
C = svmtrain([Y_pos_svm; Y_neg_svm], [X_pos_svm; world_set(:,N1)'], '-s 0 -t 0 -c 0.1');
%scores = C.w'*X_pos - C.b;
%display(['Number of Positives of Trainingset: ', num2str(sum(scores>params.svm_min_score))]);

for i = 1:params.svm_hard_minining_niters
    % classify the negative set (N1)
    [~, ~, neg_decision_values] = svmpredict(rand(size(N1,2),1), world_set(:,N1)', C);
    %y_negatives = C.w'*world_set(:,N1) - C.b;
    
    % where was this negative set false classified?
    hard_minings = find(neg_decision_values > params.svm_min_score);
    %Y_neg_minings = (-1*ones(1,size(hard_minings,2)));
    Y_neg_minings_svm = (-1*ones(size(hard_minings,1),1));
    
    display(['train SVM.. ', num2str(i), ' / ', num2str(params.svm_hard_minining_niters),...
             ' Negatives: ', num2str(numel(hard_minings))]);
         
         
    % check positives     
    [~, ~, pos_decision_values] = svmpredict(rand(size(members_i,2),1), X_pos_svm, C);     
    pos_hard_minings = find(pos_decision_values > params.svm_min_score);
    display(['train SVM.. ', num2str(i), ' / ', num2str(params.svm_hard_minining_niters),...
             ' Positives: ', num2str(numel(pos_hard_minings)), ' of ', num2str(members_i)]);
    
         
    if numel(hard_minings) == 0
        break;
    end
    
    
    %[C.w C.b] = vl_pegasos([X_pos world_set(:,N1) world_set(:,hard_minings)], [Y_pos Y_neg Y_neg_minings], 0.1, 'MaxIterations', 5000);
    C = svmtrain([Y_pos_svm; Y_neg_svm; Y_neg_minings_svm], [X_pos_svm; world_set(:,N1)'; world_set(:,hard_minings)'], '-s 0 -t 0 -c 0.1');
         
end 


end