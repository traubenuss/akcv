function world_set = dcp_generate_world_set(params, world_set_img_folder, world_set_filename, overwrite)
% param1: world_set_img_folder: Folder where the natural world set images
%         are located
% param2: world_set_filename: If given, the filename (excluding .mat),
%         where the extracted world set data is stored. As default
%         'world_set' is used
% param3: overwrite: If given, a boolean value, if an existing file should
%         be overwritten. Default is 'false'
% return: boolean value, indicates if the file for the world set data
%         already exists or was already existing.


if exist('world_set.mat') && ~overwrite
    world_set = load(world_set_filename, 'world_set');
    return;
end

fileList = getFilesInDirAndSubDirs(params.img_dir);
numFiles = size(fileList,1);


if(numFiles < params.n_images)
    display('Less images for natural world set than required. Reducing number');
    chosen_files = fileList;
else
    random_indxs = randperm(numFiles);
    chosen_files = random_indxs(1:params.n_images);
end

%chosen_files is the set of indizes of the fileList vector chosen for
%further computations

expected_patch_number = size(chosen_files,2) .* (params.n_ppi_max + params.n_ppi_min)/2;

hog_features_res = cell(1, expected_patch_number);
hog_index = 1;

%now, compute hog vectors for a random number of patches for every image
for num=1:size(chosen_files,2)
    %get the next image
    fileList{chosen_files(num)};
    I = vl_imreadgray(fileList{chosen_files(num)});
    %get random number of patches
    rand_patch_num = floor(params.n_ppi_min + rand(1,1) * (params.n_ppi_max - params.n_ppi_min))
    patches = dcp_get_random_patches(params, I, rand_patch_num);

    %compute hog features for patches
    for indx=1:size(patches,2)
        cellSize = 8;
        hog_img = im2single(patches{indx}.data);
        
        hog_result = vl_hog(hog_img, cellSize,'numOrientations', 8);
        
        if(hog_index < expected_patch_number)
            hog_features_res{hog_index} = hog_result;
        else
            hog_features_res{end+1} = hog_result;
        end
        hog_index = hog_index + 1; 
    end
end

save('world_set.mat', 'hog_features_res');
world_set = true;