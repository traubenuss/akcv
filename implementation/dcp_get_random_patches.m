function patches = dcp_get_random_patches(params, I, npatches)
% extract npatches random quadratic patches
% return: cell array of patches struct
%         patches struct: data - the image data
%                         rect - the patch rectangle of the image I

tic
[img_rows img_cols] = size(I);

maxsz = min(params.pat_maxsz, min(img_rows, img_cols));

if maxsz < params.pat_minsz
    display('Image smaller than pat_minsz!')
    patches = [];
    return
end

r = rand(1,3*npatches);

rand_idx = 1;
patches = cell(1,npatches);
for i = 1:npatches
    % select random size
    sz = params.pat_minsz + ceil(r(rand_idx) * (maxsz-params.pat_minsz));
    
    % select random top left corner
    tl = [ceil(r(rand_idx+1) * (img_rows-sz)) ceil(r(rand_idx+2) * (img_cols-sz))];
    br = tl + sz;
    
    % extract patch
    patches{i}.data = I(tl(1):br(1), tl(2):br(2));
    patches{i}.rect.tl = tl;
    patches{i}.rect.sz = sz;
    
    rand_idx = rand_idx + 3;
end
toc
end