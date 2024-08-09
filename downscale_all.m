function [sub_rock] = downscale_all(grid,rock,mask,params,num_par_workers)

coarse_idx = 1:length(mask);
sub_rock(coarse_idx) = struct('poro',[],'perm',[]);

DR = [grid.DX,grid.DY,grid.DZ];
perm = rock.perm;
poro = rock.poro;

parfor (cell_index = coarse_idx, num_par_workers)
    if ~mask(cell_index)
        continue;
    end

    [sub_rock(cell_index).poro, sub_rock(cell_index).perm] = downscale(...
    poro(cell_index), perm(cell_index,:), DR(cell_index,:), params);
end
end

