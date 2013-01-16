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
