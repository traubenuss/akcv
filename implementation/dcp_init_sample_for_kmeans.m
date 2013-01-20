function S = dcp_init_sample_for_kmeans(params, D1, hog_patches, npictures, img_sizes)
% sample a random subset of D, without allowing patches with low Gradient energy

gradient_threshold = params.kmeans_init_grad_threshold;

% permutate indizes of D to realise random samples
shuffle = randperm(size(D1,2));

% generate 'logical images' to prevent sampling from the same position
already_selected_patch_maps = cell(1,npictures);
for i = 1:npictures
    already_selected_patch_maps{i} = false(img_sizes(i,:));
end


S_count = 0;
S_sz = ceil(size(D1,2)*params.kmeans_init_S_sz);
S = zeros(1,S_sz);
for i = 1:size(D1,2)
    % calculate center and half size of the patch
    sz = hog_patches{D1(shuffle(i))}.rect.sz;
    tl = hog_patches{D1(shuffle(i))}.rect.tl;
    center = tl+ceil(sz/2);
    img_nr = hog_patches{D1(shuffle(i))}.img_nr;
    
    % take sample only if there is enough gradient energy & not already a
    % patch taken from this region
    if sum(hog_patches{D1(shuffle(i))}.hog(:)) > gradient_threshold && ...
            ~already_selected_patch_maps{img_nr}(center(1),center(2))   
        
        S_count = S_count + 1;
        S(S_count) = D1(shuffle(i));
        
        % mark the region around the center of the selected patch
        mark_tl = center-ceil(sz/4);
        mark_br = center+ceil(sz/4);
        already_selected_patch_maps{img_nr}(mark_tl(1):mark_br(1), mark_tl(2):mark_br(2)) = true;
        
        if S_count == S_sz % have already enough samples for kmeans
            break;
        end
    end
    
end

if S_count < S_sz
    display(['Warning: kmeans: less patches for initial clustering than desired found in D1: ', ...
              num2str(S_count), ' instead of ', num2str(S_sz)]);
    S = S(1:S_count);
end


end