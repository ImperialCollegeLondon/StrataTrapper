function [pc_eff, sw_eff, pc_bc, sub_sw, converged, err] = mip_iter_imb(...
    sw_target, dr, max_pressures, porosities, permeabilities, pc_bc,...
    Nz_sub, Nx_sub, Ny_sub, ...
    params, options)

% invaded with water
invaded_mat_mid = calc_percolation_imb(pc_bc, max_pressures,...
    options.hydrostatic_correction, dr(3), params.rho_water, params.rho_gas);

volume = prod(dr);
sub_volume = volume./double(Nz_sub*Nx_sub*Ny_sub);
pore_volumes = porosities .* sub_volume;
pore_volume = sum(pore_volumes,'all');

sub_sw = invaded_mat_mid .* params.cap_pressure.inv(pc_bc,porosities,permeabilities) ...
    + ~invaded_mat_mid .* 0;
sub_sw(~isfinite(sub_sw)) = 0;
sw_eff = sum(sub_sw.*pore_volumes,'all')/pore_volume;

% FIXME: Pc should converge as well as Sw
pc_eff = sum((1-sub_sw).*pore_volumes.*pc_bc,"all")/(pore_volume*(1-sw_eff));

if sw_eff >=1
    pc_eff = pc_bc; % FIXME: verify this branch for imbibition
end

% FIXME change target criteria to other sampling methods
% based on individual threshold pressures 
% FIXME move convergence processing to the outside
sw_err = sw_target - sw_eff; 
err = abs(sw_err);
converged = err <= options.sat_tol;
if converged
    return;
end

deriv = params.cap_pressure.deriv(sw_eff, mean(porosities,'all'), mean(permeabilities,'all'));

dpc = sw_err*deriv;

pc_bc = pc_bc + dpc * 0.8;
if ~isfinite(pc_bc)
    error('')
end

% FIXME: fix this
if pc_bc < min(max_pressures(:))
    pc_bc = min(max_pressures(:));
end

end
