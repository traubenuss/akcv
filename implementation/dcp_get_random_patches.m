function patches = dcp_get_random_patches(params, I, npatches)
% extract npatches random quadratic patches
% return: cell array of patches struct
%         patches struct: data - the image data
%                         rect - the patch rectangle of the image I

[img_rows img_cols] = size(I);

maxsz = min(params.pat_maxsz, min(img_rows, img_cols));

if maxsz < params.pat_minsz
    display('Image smaller than pat_minsz!')
    patches = [];
    return
end

%r = rand(1,3*npatches);

patches = cell(1,npatches);
parfor i = 1:npatches
    % select random size
    sz = params.pat_minsz + ceil(rand * (maxsz-params.pat_minsz));
    sz = min(sz, min(img_rows, img_cols)-1);
    % select random top left corner
    tl = [ceil(rand * (img_rows-sz)) ceil(rand * (img_cols-sz))];
    br = tl + sz;
    
    % extract patch
    patches{i}.data = I(tl(1):br(1), tl(2):br(2));
    patches{i}.rect.tl = tl;
    patches{i}.rect.sz = sz;
    
    %rand_idx = rand_idx + 3;
end

end