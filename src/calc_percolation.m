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
    [invasion, is_invading] = calc_percolation_iter(invasion,I,J,K,not_checked);
end

end

function [invasion,has_changed] = calc_percolation_iter(invasion,I,J,K,ind)
[Nx,Ny,Nz] = size(invasion);
has_changed = false;
has_invaded_nearby = find_invaded_nearby(invasion, I,J,K, Nx,Ny,Nz);
has_changed = has_changed || any(xor(has_invaded_nearby,invasion(ind)));
invasion(ind) = invasion(ind) | has_invaded_nearby;
end

function is_next_to_invaded = find_invaded_nearby(invasion, I,J,K, Nx,Ny,Nz)
delta_around = [-1,1];
is_next_to_invaded = false(1,numel(I));
for di=delta_around
    II = I + di; % Bound checks not required
    
    ind_di = sub2ind([Nx,Ny,Nz],II,J,K);

    is_next_to_invaded = is_next_to_invaded | invasion(ind_di);
end

for dj=delta_around
    JJ = J + dj; % Bound checks not required
    
    ind_dj = sub2ind([Nx,Ny,Nz],I,JJ,K);

    is_next_to_invaded = is_next_to_invaded | invasion(ind_dj);
end

for dk=delta_around
    KK = K + dk; % Bound checks not required
    
    ind_dk = sub2ind([Nx,Ny,Nz],I,J,KK);

    is_next_to_invaded = is_next_to_invaded | invasion(ind_dk);
end
end
