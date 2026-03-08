function strata_trapped = normalize_lj(strata_trapped)
%NORMALIZE_LJ Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    strata_trapped (1,1) struct
end

arguments (Output)
    strata_trapped (1,1) struct
end


cap_pressure = [strata_trapped.params.cap_pressure];
cap_pressure_normalized = cap_pressure.normalize();

unique_ids = unique(strata_trapped.param_ids);

for i = 1:numel(unique_ids)
    param_id = unique_ids(i);
    mask = strata_trapped.param_ids == param_id;
    poro = strata_trapped.porosity(mask);
    perm = strata_trapped.permeability(mask,:);
    for dir=1:3
        % restore cap_pressure with originial
        leverett_j = strata_trapped.tables(i,dir).leverett_j;
        pc = cap_pressure(param_id).from_lj(leverett_j,poro,perm);
        % inverse J-function with normalized
        strata_trapped.tables(i,dir).leverett_j = ...
            cap_pressure_normalized(param_id).inv_lj(pc,poro,perm);
    end
    strata_trapped.params(param_id).cap_pressure = cap_pressure_normalized(param_id);
end
end
