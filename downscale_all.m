function [sub_rock] = downscale_all(grid,rock,mask,params,args)
    arguments
        grid
        rock
        mask
        params
        args.num_par_workers (1,1) uint32  = Inf;
    end

coarse_idx = 1:length(mask);
sub_rock(coarse_idx) = struct('poro',[],'perm',[]);

DR = [grid.DX,grid.DY,grid.DZ];
perm = rock.perm;
poro = rock.poro;

parfor (cell_index = coarse_idx, args.num_par_workers)
    if ~mask(cell_index)
        continue;
    end

    [sub_rock(cell_index).poro, sub_rock(cell_index).perm] = downscale(...
    poro(cell_index), perm(cell_index,:), DR(cell_index,:), params);
end
end
