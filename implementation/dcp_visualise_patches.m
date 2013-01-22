function dcp_visualise_patches(params, patches, discovery_set, is_intermediate, run, showScores)

if nargin < 4
   is_intermediate = false; 
   run = 1;
   showScores = true;
end

if is_intermediate
    figure(1)
    hold on
    suptitle('Best Cluster over Iterations')
    %title('Best Clusters')
    %ylabel(['1..', num2str(params.niterations), ' iterations'])
    %xlabel('Top 5 patches')
    nrows = params.niterations;
    ncols = params.nintermed_patches_to_visualise;
    npatches = min(numel(patches),params.nintermed_patches_to_visualise);
    start = (run-1)*params.nintermed_patches_to_visualise+1;
    for i = 1:npatches
        img = imread(discovery_set{patches{i}.img_nr});
        subplot(nrows,ncols,i+start-1);
        
        if showScores
            title(['Patch score: ', num2str(patches{i}.score)]);
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
        sumimg = zeros(params.pat_maxsz, params.pat_maxsz, 3);
        nsumimg = 1;
        figure(j+1);
        suptitle([num2str(j) '. best cluster'])
        for i = 1:npatches
            if ~isempty(patches{j,i})
                img = imread(discovery_set{patches{j,i}.img_nr});
                subplot(nrows,ncols,i);
                
                if showScores
                    title(['Patch score: ', num2str(patches{j,i}.score)]);
                end
                
                rect = patches{j,i}.rect;
                subimage(img(rect.tl(1):rect.tl(1)+rect.sz, rect.tl(2):rect.tl(2)+rect.sz, :));
                resized = im2double( imresize(img(rect.tl(1):rect.tl(1)+rect.sz, rect.tl(2):rect.tl(2)+rect.sz, :), [params.pat_maxsz, params.pat_maxsz]));
                sumimg = sumimg + resized;
                nsumimg = nsumimg + 1;
            end
        end
        figure(100);
        nrows = ceil(size(patches,1)/3);
        ncols = ceil(size(patches,1)/nrows);
        subplot(nrows,ncols,j);
        subimage(sumimg/nsumimg);
        suptitle('Best Clusters Blended')
    end

end



end