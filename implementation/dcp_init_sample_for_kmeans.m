function S = dcp_init_sample_for_kmeans(params, D, hog_patches)
% sample a random subset of D, without allowing patches with low Gradient energy

gradient_threshold = params.kmeans_init_grad_threshold;

% permutate indizes of D to realise random samples
shuffle = randperm(size(D,2));

S_count = 0;
S_sz = ceil(size(D,2)*params.kmeans_init_S_sz);
S = zeros(1,S_sz);
for i = 1:size(D,2)
    
    % take sample only if there is enough gradient energy
    if sum(hog_patches(D(shuffle(i))).hog(:)) > gradient_threshold
        S_count = S_count + 1;
        S(S_count) = D(shuffle(i));
        if S_count == S_sz % have already enough samples for kmeans
            break;
        end
    end
    
end

if S_count < S_sz
    display(['Warning: kmeans: too less patches with enough gradient energy in subset D1']);
    S = S(1:S_count);
end


end