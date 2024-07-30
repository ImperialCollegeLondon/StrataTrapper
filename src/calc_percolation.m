function [invasion,num_iter] = calc_percolation(p_boundary,p_entry)
invasion = false(size(p_entry));
invadable = p_entry < p_boundary;
idx_invadable = find(invadable)';
[I,J,K] = ind2sub(size(invadable),idx_invadable);
is_invading = true;
num_iter = 0;
while is_invading
    [invasion, is_invading] = calc_percolation_iter(invasion,[I;J;K]);
    not_checked = find(invadable & ~invasion)';
    [I,J,K] = ind2sub(size(invadable),not_checked);
    num_iter = num_iter+1;
end
end

function [invasion,has_changed] = calc_percolation_iter(invasion,Idx)
[Nx,Ny,Nz] = size(invasion);
has_changed = false;
for idx = Idx
    i = idx(1);
    j = idx(2);
    k = idx(3);

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

function is_next_to_invaded = find_invaded_nearby(invasion, i,j,k, Nx,Ny,Nz)
is_next_to_invaded = false;
delta_around = [-1,1];

for di=delta_around
    ii = i + di;
    if ii < 1 || ii > Nx
        continue;
    end

    is_next_to_invaded = invasion(ii,j,k);
    if is_next_to_invaded
        return;
    end
end

for dj=delta_around
    jj = j + dj;
    if jj < 1 || jj > Ny
        continue;
    end

    is_next_to_invaded = invasion(i,jj,k);
    if is_next_to_invaded
        return;
    end
end

for dk=delta_around
    kk = k + dk;
    if kk < 1 || kk > Nz
        continue;
    end

    is_next_to_invaded = invasion(i,j,kk);
    if is_next_to_invaded
        return;
    end
end
end
