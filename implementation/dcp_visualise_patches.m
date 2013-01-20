function dcp_visualise_patches(params, patches, discovery_set, is_intermediate, run, showScores)

if nargin < 4
   is_intermediate = false; 
   run = 1;
   showScores = true;
end

if is_intermediate
    figure(1)
    nrows = params.niterations;
    ncols = params.nintermed_patches_to_visualise;
    npatches = min(numel(patches),params.nintermed_patches_to_visualise);
    start = (run-1)*params.nintermed_patches_to_visualise+1;
    for i = 1:npatches
        img = imread(discovery_set{patches{i}.img_nr});
        subplot(nrows,ncols,i+start-1);
        
        if showScores
            title(['Patch score' patches{i}.score]);
        end
        
        rect = patches{i}.rect;
        subimage(img(rect.tl(1):rect.tl(1)+rect.sz, rect.tl(2):rect.tl(2)+rect.sz, :));
        drawnow;
    end
    
else
    for j = 1:size(patches,1)
        npatches = size(patches,2);
        ncols = ceil(sqrt(npatches));
        nrows = ceil(npatches/ncols);
        
        figure(j);
        for i = 1:npatches
            img = imread(discovery_set{patches{j,i}.img_nr});
            subplot(nrows,ncols,i);
            
            if showScores
                title(['Patch score' patches{j,i}.score]);
            end
            
            rect = patches{j,i}.rect;
            subimage(img(rect.tl(1):rect.tl(1)+rect.sz, rect.tl(2):rect.tl(2)+rect.sz, :));
        end
    end

end



end