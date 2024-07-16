function [Kabs, sw_upscaled, pc_upscaled, krg, krw] = ...
    downscale_upscale(porosity, perm_coarse, dr, saturations, params, options)
arguments
    porosity
    perm_coarse
    dr          (1,3) double
    saturations (1,:) double
    params      (1,1) struct
    options     (1,1) struct
end


if porosity <= 0
    return;
end

[subscale_dims, sub_porosity, sub_permeability, sub_entry_pressures] ...
    = downscale(porosity, perm_coarse, dr, params, options);

[Kabs, sw_upscaled, pc_upscaled, krw, krg] = upscale(...
    dr, saturations, params, options, ...
    subscale_dims, sub_porosity, sub_permeability, sub_entry_pressures ...
    );

pc_upscaled = interp1(sw_upscaled,pc_upscaled,saturations,"linear","extrap");
krw = interp1(sw_upscaled, krw', saturations, "linear","extrap")';
krg = interp1(sw_upscaled, krg', saturations, "linear","extrap")';

end
