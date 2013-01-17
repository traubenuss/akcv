function  C = dcp_train_svm(params, K, D1, hog_patches, N1, world_set)

% fill the data vector
X = zeros(size(hog_patches{1}.hog(:),1), size(D1,2) + size(N1,2));

for i = 1:size(D1,2)
    X(:,i) = hog_patches{i}.hog(:);
end
for i = size(D1,2)+1:size(X,2)
    X(:,i) = world_set{i}.hog(:);
end

% set labels
Y = ones(1,size(D1,2));
Y = [Y -1*ones(1,size(N1,2))];

% negative hard mining
for i = 1:params.svm_hard_minining_niters
    [w b info] = vl_svmpegasos(X, Y, 0.1);
    y_negatives = w*X(size(D1,2)+1:size(X,2))-b;
    
    
end
[w b info] = vl_svmpegasos(X, Y, 0.1); 

end