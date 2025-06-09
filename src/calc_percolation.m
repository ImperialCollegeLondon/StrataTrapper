function [invasion,num_iter] = calc_percolation(p_boundary,p_entry, ...
    include_gravity, Lz, rho_water, rho_gas)

h_ref = Lz*0.5;

N = size(p_entry);
Nx = N(1);
Ny = N(2);
Nz = N(3);
h(1,1,1:Nz) = linspace(Lz/Nz/2,Lz - Lz/Nz/2,Nz);

hydrostatic_correction = 0;
if ~ismissing(rho_gas)
    hydrostatic_correction = include_gravity * std_gravity() * (rho_water - rho_gas) * (h - h_ref);
end

is_invadable = (p_entry + hydrostatic_correction) < p_boundary;
is_boundary = false(size(p_entry));
is_boundary(  1,  :,  :) = true;
is_boundary(end,  :,  :) = true;
is_boundary(  :,  1,  :) = true;
is_boundary(  :,end,  :) = true;
is_boundary(  :,  :,  1) = true;
is_boundary(  :,  :,end) = true;
invasion = is_invadable & is_boundary;

is_invading = true;
num_iter = 0;
while is_invading
    num_iter = num_iter+1;
    has_invaded_nearby = logical(convn(invasion,near_kernel(),"same"));
    new_invaded = is_invadable & has_invaded_nearby;
    is_invading = any(xor(invasion(:),new_invaded(:)));
    invasion = invasion | new_invaded;
end

end

function out = near_kernel()
persistent k
if isempty(k)
    k = cat(3, ...
        [0,0,0; ...
        0,1,0; ...
        0,0,0], ...
        [0,1,0; ...
        1,0,1; ...
        0,1,0], ...
        [0,0,0; ...
        0,1,0; ...
        0,0,0]);
end
out = k;
end
