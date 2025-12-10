function [perm_upscaled, pc_upscaled, krw, krg, mip] = upscale(...
    dr, saturations, params, options, porosities, permeabilities)

if max(porosities,[],'all') <= 0
    error('inactive cell');
end

mip(1:length(saturations)) = struct('sw',nan,'sub_sw',[]);

% apply absolute permeability threshold before proceeding
perm_threshold = reshape(options.m_perm_threshold_mD,[1,1,1,3])*milli*darcy;
small_Kabs = permeabilities < perm_threshold;
permeabilities = permeabilities .* (~small_Kabs) + perm_threshold .* small_Kabs;

if isscalar(porosities)
    poro_upscaled = porosities(1);
    perm_upscaled = reshape(permeabilities(:,:,1,:),1,3);
    pc_upscaled = arrayfun(@(sw)params.cap_pressure.func(sw,poro_upscaled,perm_upscaled),...
        saturations(:),"UniformOutput",true);
    krw = params.krw.func(saturations);
    krw = [krw;krw;krw];
    krg = params.krg.func(1-saturations);
    krg = [krg;krg;krg];
    mip = [];
    return;
end

downscale_dims = size(porosities);

dr_sub = dr ./ downscale_dims;

permeabilities_mD = permeabilities./milli./darcy;

perm_upscaled_mD = upscale_permeability(permeabilities_mD, dr_sub(1),dr_sub(2),dr_sub(3));
perm_upscaled = perm_upscaled_mD.*milli.*darcy;

sw_upscaled = saturations;
pc_upscaled = zeros(size(saturations));

Nx_sub = downscale_dims(1);
Ny_sub = downscale_dims(2);
Nz_sub = downscale_dims(3);

krg = zeros(3,length(sw_upscaled));
krw = zeros(3,length(sw_upscaled));

entry_pressures = params.cap_pressure.func(1,porosities,permeabilities);
pc_max = params.cap_pressure.func(params.sw_resid,porosities,permeabilities);
pc_points = linspace(max(pc_max(isfinite(pc_max))),min(entry_pressures(:)),length(saturations));

for index_saturation = 1:length(saturations)

    sw_target = saturations(index_saturation);

    pc_mid = pc_points(index_saturation);
    sw_mid = sw_target;

    calc_endpoint = index_saturation == 1 || index_saturation == length(saturations);
    max_iterations = calc_endpoint*1000 + ~calc_endpoint*100;
    err_prev = Inf;
    for iteration_num=1:max_iterations
        [pc_mid_tot, sw_mid, pc_mid, sub_sw, converged, err] = mip_iteration(...
            sw_target, dr, entry_pressures, porosities, permeabilities, pc_mid, ...
            Nz_sub, Nx_sub, Ny_sub,...
            params, options);

        if converged
            break;
        end

        if abs(err - err_prev) <= eps
            break;
        end
        err_prev = err;
    end

    sw_upscaled(index_saturation) = sw_mid;
    pc_upscaled(index_saturation) = pc_mid_tot;

    Kg_sub_mD = params.krg.func(1-sub_sw);
    Kw_sub_mD = params.krw.func(sub_sw);

    Kg_sub_mD = Kg_sub_mD.*(porosities~=0).*permeabilities_mD;
    Kw_sub_mD = Kw_sub_mD.*(porosities~=0).*permeabilities_mD;

    [krg(:,index_saturation), krw(:,index_saturation)] = calc_relative_permeabilities( ...
        dr_sub, perm_upscaled_mD, Kg_sub_mD, Kw_sub_mD);

    if options.m_save_mip_step
        mip(index_saturation).sw = sw_mid;
        mip(index_saturation).sub_sw = sub_sw;
    end
end

% NOTE: we expect only small negative values as computational errors
krw(:) = max(krw(:),0);
krg(:) = max(krg(:),0);
pc_upscaled = max(pc_upscaled,min(entry_pressures(:)));

% add potentially missing endpoints
sw_extra = [params.sw_resid,1];

[~,unique_idx] = unique(sw_upscaled);
pc_upscaled_extra = exp(interp1( ...
    sw_upscaled(unique_idx), log(pc_upscaled(unique_idx)), sw_extra, "linear","extrap"));
pc_upscaled = [pc_upscaled,pc_upscaled_extra];

sw_upscaled(end+1) = sw_extra(1);
krw(:,end+1) = 0;
krg(:,end+1) = max(params.krg.data(:,2));

sw_upscaled(end+1) = sw_extra(2);
krw(:,end+1) = max(params.krw.data(:,2));
krg(:,end+1) = 0;

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

pc_upscaled = exp(interp1(sw_upscaled, log(pc_upscaled), saturations, "linear","extrap"));
krw         = interp1(sw_upscaled, krw', saturations, "linear","extrap")';
krg         = interp1(sw_upscaled, krg', saturations, "linear","extrap")';

end

function [pc_mid_tot, sw_mid, pc_mid, sub_sw, converged, err] = mip_iteration(...
    sw_target, dr, entry_pressures, porosities, permeabilities, pc_mid,...
    Nz_sub, Nx_sub, Ny_sub, ...
    params, options)

invaded_mat_mid = calc_percolation(pc_mid, entry_pressures,...
    options.hydrostatic_correction, dr(3), params.rho_water, params.rho_gas);

volume = prod(dr);
sub_volume = volume./double(Nz_sub*Nx_sub*Ny_sub);
pore_volumes = porosities .* sub_volume;
pore_volume = sum(pore_volumes,'all');

sub_sw = invaded_mat_mid .* params.cap_pressure.inv(pc_mid,porosities,permeabilities) ...
    + ~invaded_mat_mid .* 1;
sub_sw(~isfinite(sub_sw)) = 1;
sw_mid = sum(sub_sw.*pore_volumes,'all')/pore_volume;

% FIXME: Pc should converge as well as Sw
pc_mid_tot = sum((1-sub_sw).*pore_volumes.*pc_mid,"all")/(pore_volume*(1-sw_mid));

if sw_mid >=1
    pc_mid_tot = pc_mid;
end

sw_err = sw_target - sw_mid;
err = abs(sw_err);
converged = err <= options.sat_tol;
if converged
    return;
end

deriv = params.cap_pressure.deriv(sw_mid, mean(porosities,'all'), mean(permeabilities,'all'));

dpc = sw_err*deriv;

pc_mid = pc_mid + dpc * 0.8;
if ~isfinite(pc_mid)
    error('')
end
if pc_mid < min(entry_pressures(:))
    pc_mid = min(entry_pressures(:));
end

end

function [krg, krw] = calc_relative_permeabilities(dr_sub, perm_upscaled_mD, Kg_sub_mD, Kw_sub_mD)

K_phase_upscaled = zeros(1,6);

K_phase_upscaled(1:3) = upscale_permeability(Kg_sub_mD, dr_sub(1), dr_sub(2), dr_sub(3));
K_phase_upscaled(4:6) = upscale_permeability(Kw_sub_mD, dr_sub(1), dr_sub(2), dr_sub(3));

Kx_mD = perm_upscaled_mD(1);
Ky_mD = perm_upscaled_mD(2);
Kz_mD = perm_upscaled_mD(3);

K_phase_upscaled([1,4]) = K_phase_upscaled([1,4]) ./ Kx_mD; % NOTE: avoid dividing two small numbers
K_phase_upscaled([2,5]) = K_phase_upscaled([2,5]) ./ Ky_mD;
K_phase_upscaled([3,6]) = K_phase_upscaled([3,6]) ./ Kz_mD;

K_phase_upscaled(~isfinite(K_phase_upscaled)) = 0;

krg = K_phase_upscaled(1:3)';
krw = K_phase_upscaled(4:6)';

end
