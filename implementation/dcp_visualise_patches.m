function dcp_visualise_patches(params, patches, discovery_set)

npatches = size(patches,2);
ncols = ceil(sqrt(npatches));
nrows = ceil(npatches/ncols);

figure;
for i = 1:npatches
    img = imread(discovery_set{patches{i}.img_nr});
    subplot(nrows,ncols,i);
    rect = patches{i}.rect;
    subimage(img(rect.tl(1):rect.tl(1)+rect.sz, rect.tl(2):rect.tl(2)+rect.sz, :));
end

end