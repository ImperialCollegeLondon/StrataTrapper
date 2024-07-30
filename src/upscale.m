function [Kabs, sw_upscaled, pc_upscaled, krw, krg] = upscale(...
    dr, saturations, params, options, ...
    downscale_dims, porosities, permeabilities, entry_pressures)

if max(porosities,[],'all') <= 0
    error('inactive cell');
end

dr_sub = dr ./ downscale_dims;

Kabs = upscale_permeability(permeabilities, dr_sub(1),dr_sub(2),dr_sub(3));

sw_upscaled = saturations;
pc_upscaled = zeros(size(saturations));

Nx_sub = downscale_dims(1);
Ny_sub = downscale_dims(2);
Nz_sub = downscale_dims(3);

krg = zeros(3,length(sw_upscaled));
krw = zeros(3,length(sw_upscaled));

for index_saturation = 1:length(saturations)

    sw_target = saturations(index_saturation);

    pc_mid = params.capil.pres_func(sw_target, mean(porosities,'all'), mean(permeabilities,'all'));
    sw_mid = sw_target;

    calc_endpoint = index_saturation == 1 || index_saturation == length(saturations);
    max_iterations = calc_endpoint*1000 + ~calc_endpoint*2;

    for iteration_num=1:max_iterations
        [pc_mid_tot, sw_mid, pc_mid, invaded_mat_mid, converged] = mip_iteration(...
            sw_target, dr, entry_pressures, porosities, permeabilities, pc_mid, ...
            Nz_sub, Nx_sub, Ny_sub,...
            params.capil.pres_func_inv, params.capil.pres_deriv,...
            options.sat_tol ...
            );

        if converged
            break;
        end
    end

    sw_upscaled(index_saturation) = sw_mid;
    pc_upscaled(index_saturation) = pc_mid_tot;

    sw = invaded_mat_mid .* sw_mid + ~invaded_mat_mid .* 1;

    kg_mat_local = params.rel_perm.calc_krg(1-sw);
    kw_mat_local = params.rel_perm.calc_krw(sw);

    kg_mat_local = kg_mat_local.*permeabilities;
    kw_mat_local = kw_mat_local.*permeabilities;

    [krg(:,index_saturation), krw(:,index_saturation)] = calc_phase_permeabilities(dr_sub, Kabs, kg_mat_local, kw_mat_local);
end

sw_upscaled(end) = 1;
[sw_upscaled,unique_idx] = unique(sw_upscaled);
pc_upscaled = pc_upscaled(unique_idx);
krg = krg(:,unique_idx);
krw = krw(:,unique_idx);

[sw_upscaled,sorted_idx] = sort(sw_upscaled);
pc_upscaled = pc_upscaled(sorted_idx);
krg = krg(:,sorted_idx);
krw = krw(:,sorted_idx);

pc_upscaled(isinf(pc_upscaled)) = max(pc_upscaled(~isinf(pc_upscaled)));

if ~allfinite(pc_upscaled)
    disp(pc_upscaled);
end

end

function [pc_mid_tot, sw_mid, pc_mid, invaded_mat_mid, converged] = mip_iteration(...
    sw_target, dr, entry_pressures, porosities, permeabilities, pc_mid,...
    Nz_sub, Nx_sub, Ny_sub, ...
    pc_func_inv, pc_deriv, ...
    tol_sw)

invaded_mat_mid = calc_percolation(pc_mid, entry_pressures);

volume = prod(dr);
sub_volume = volume./double(Nz_sub*Nx_sub*Ny_sub);
pore_volumes = porosities .* sub_volume;
pore_volume = sum(pore_volumes,'all');

sub_sw_mid = invaded_mat_mid .* pc_func_inv(pc_mid,porosities,permeabilities) + ~invaded_mat_mid .* 1;
sub_sw_mid(~isfinite(sub_sw_mid)) = 1;
sw_mid = sum(sub_sw_mid.*pore_volumes,'all')/pore_volume;

pc_mid_tot = sum((1-sub_sw_mid).*pore_volumes.*pc_mid,"all")/(pore_volume*(1-sw_mid));

if sw_mid >=1
    pc_mid_tot = pc_mid;
end

sw_err = sw_target - sw_mid;
err = abs(sw_err);
converged = err <= tol_sw;
if converged
    return;
end

deriv = pc_deriv(sw_mid, mean(porosities,'all'), mean(permeabilities,'all'));

dpc = sw_err*deriv;

pc_mid = pc_mid + dpc * 0.8;
if ~isfinite(pc_mid)
    error('')
end
pc_mid = max(pc_mid,min(entry_pressures,[],'all'));
end

function [krg, krw] = calc_phase_permeabilities(dr_sub, Kabs, kg_mat, kw_mat)

Kx = Kabs(1);
Ky = Kabs(2);
Kz = Kabs(3);

Kalli = zeros(1,6);

Kalli(1:3) = upscale_permeability(kg_mat, dr_sub(1), dr_sub(2), dr_sub(3));
Kalli(4:6) = upscale_permeability(kw_mat, dr_sub(1), dr_sub(2), dr_sub(3));

Kalli([1,4]) = Kalli([1,4]) ./ Kx;
Kalli([2,5]) = Kalli([2,5]) ./ Ky;
Kalli([3,6]) = Kalli([3,6]) ./ Kz;

krg = Kalli(1:3)';
krw = Kalli(4:6)';

end
