function [porosity, Kabs, sw_upscaled, pc_upscaled, krg, krw] = ...
    downscale_upscale(dr, saturations, params, options)
arguments
    dr          (1,3) double
    saturations (1,:) double
    params      (1,1) struct
    options     (1,1) struct
end

% TODO: implement multi-scale approach for really small small_scale

[subscale_dims, sub_porosity, sub_permeability, sub_entry_pressures, porosity] ...
    = downscale(dr, params, options);

if porosity <= 0
    return;
end

[Kabs, sw_upscaled, pc_upscaled, krw, krg] = upscale(...
    dr, saturations, params, options, ...
    subscale_dims, sub_porosity, sub_permeability, sub_entry_pressures ...
    );

end
