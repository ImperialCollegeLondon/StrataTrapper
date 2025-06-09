function [invasion,num_iter] = calc_percolation(p_boundary,p_entry, ...
    include_gravity, Lz, rho_water, rho_gas)

h_ref = Lz*0.5;

Nz = size(p_entry,3);
h(1,1,1:Nz) = linspace(Lz/Nz/2,Lz - Lz/Nz/2,Nz);

hydrostatic_correction = 0;
if ~ismissing(rho_gas)
    hydrostatic_correction = include_gravity * std_gravity() * (rho_water - rho_gas) * (h - h_ref);
end

invadable = (p_entry + hydrostatic_correction) < p_boundary;
is_boundary = false(size(p_entry));
is_boundary(  1,  :,  :) = true;
is_boundary(end,  :,  :) = true;
is_boundary(  :,  1,  :) = true;
is_boundary(  :,end,  :) = true;
is_boundary(  :,  :,  1) = true;
is_boundary(  :,  :,end) = true;
invasion = invadable & is_boundary;

is_invading = true;
num_iter = 0;
while is_invading
    num_iter = num_iter+1;
    not_checked = find(invadable(:) & ~invasion(:))';
    [I,J,K] = ind2sub(size(invadable),not_checked);
    [invasion, is_invading] = calc_percolation_iter(invasion,I,J,K);
end

end

function [invasion,has_changed] = calc_percolation_iter(invasion,I,J,K)
[Nx,Ny,Nz] = size(invasion);
has_changed = false;
for idx = 1:numel(I)
    i = I(idx);
    j = J(idx);
    k = K(idx);

    is_connected = find_invaded_nearby(invasion, i,j,k, Nx,Ny,Nz);

    has_changed = has_changed | xor(invasion(i,j,k),is_connected);

    invasion(i,j,k) = invasion(i,j,k) | is_connected;
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
