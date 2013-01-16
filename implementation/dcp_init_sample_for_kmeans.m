function S = dcp_init_sample_for_kmeans(params, D, hog_patches)
% sample a random subset of D, without allowing patches with low Gradient energy

gradient_threshold = params.kmeans_init_grad_threshold;

% permutate indizes of D to realise random samples
shuffle = randperm(size(D,2));

for i = 1:size(D,2)
    
    % take sample only if there is enough gradient energy
    if sum(hog_patches(D(shuffle(i))).hog(:)) > gradient_threshold
        
    end
    
end


end