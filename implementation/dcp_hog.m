function hog = dcp_hog(params, img)

if ~strcmp(class(img), 'single')
    img = im2single(img);
end

img = imresize(img, [params.hog_cell_size*params.hog_stride, ...
                     params.hog_cell_size*params.hog_stride]);
                 
hog = vl_hog(img, params.hog_cell_size,'numOrientations', params.hog_num_orient);

end