function [invasion,num_iter] = calc_percolation(p_boundary,p_entry)
invasion = false(size(p_entry));
not_invadable = p_entry >= p_boundary;
is_invading = true;
num_iter = 0;
while is_invading
    [invasion, is_invading] = calc_percolation_iter(invasion,not_invadable);
    num_iter = num_iter+1;
end
end

function [invasion,has_changed] = calc_percolation_iter(invasion,not_invadable)
[Nx,Ny,Nz] = size(invasion);
has_changed = false;
for i=1:Nx
    for j=1:Ny
        for k=1:Nz
            if not_invadable(i,j,k)
                continue;
            end

            if invasion(i,j,k)
                continue;
            end

            is_boundary = i==1 || i==Nx || j==1 || j==Ny || k==1 || k==Nz;

            is_connected = is_boundary;

            if ~is_connected
                is_connected = find_invaded_nearby(invasion, i,j,k, Nx,Ny,Nz);
            end

            if ~is_connected
                continue;
            end

            invasion(i,j,k) = true;
            has_changed = true;
        end
    end
end
end

function is_next_to_invaded = find_invaded_nearby(invasion, i,j,k, Nx,Ny,Nz)
is_next_to_invaded = false;
delta_around = [-1,1];
for di=delta_around
    ii = i + di;
    is_out_of_bounds = ii < 1 || ii > Nx;
    if is_out_of_bounds
        continue;
    end
    for dj=delta_around
        jj = j + dj;
        is_out_of_bounds = jj < 1 || jj > Ny;
        if is_out_of_bounds
            continue;
        end
        for dk=delta_around
            kk = k + dk;
            is_out_of_bounds = kk < 1 || kk > Nz;
            if is_out_of_bounds
                continue;
            end
            is_next_to_invaded = invasion(ii,jj,kk);
            if is_next_to_invaded
                return;
            end
        end
    end
end
end
