function world_set_ret = dcp_generate_world_set(params, world_set_img_folder, world_set_filename, overwrite)
% param1: world_set_img_folder: Folder where the natural world set images
%         are located
% param2: world_set_filename: If given, the filename (excluding .mat),
%         where the extracted world set data is stored. As default
%         'world_set' is used
% param3: overwrite: If given, a boolean value, if an existing file should
%         be overwritten. Default is 'false'
% return: boolean value, indicates if the file for the world set data
%         already exists or was already existing.

tic
if exist('world_set.mat') && ~overwrite
    world_set = load(world_set_filename, 'world_set');
    return;
end

fileList = getFilesInDirAndSubDirs(params.img_dir);
numFiles = size(fileList,1);


if(numFiles < params.n_images)
    display('Less images for natural world set than required. Reducing number');
    chosen_files = 1:numFiles;
else
    random_indxs = randperm(numFiles);
    chosen_files = random_indxs(1:params.n_images);
end

%chosen_files is the set of indizes of the fileList vector chosen for
%further computations

world_set_mat = [];

count = 1;
%now, compute hog vectors for a random number of patches for every image
for num=1:size(chosen_files,2)
    if(mod(num,50) == 0)
        num
    end
    %get the next image
    fileList{chosen_files(num)};
    I = vl_imreadgray(fileList{chosen_files(num)});
    %get random number of patches
    rand_patch_num = floor(params.n_ppi_min + rand(1,1) * (params.n_ppi_max - params.n_ppi_min));
    patches = dcp_get_random_patches(params, I, rand_patch_num);

    my_temp = ones(params.hog_sz,size(patches,2));
    %compute hog features for patchesk
    parfor indx=1:size(patches,2)
        hog_img = patches{indx}.data;
        
        hog_result = dcp_hog(params, hog_img);
    
        my_temp(:,indx) = hog_result(:);
    end
    
    world_set_mat = [world_set_mat,my_temp];
    
    if(mod(num,400) == 0)
        save(['world_set' num2str(count)], 'world_set_mat');
        count = count + 1
        clear world_set_mat;
        world_set_mat = [];
    end    
end

size(world_set_mat)
save(['world_set.mat' num2str(count)], 'world_set_mat');
world_set_ret = true;
toc