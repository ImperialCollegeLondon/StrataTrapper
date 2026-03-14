function strata_trapped = normalize_lj(strata_trapped)
arguments (Input)
    strata_trapped (1,1) struct
end

arguments (Output)
    strata_trapped (1,1) struct
end


cap_pressure = [strata_trapped.params.cap_pressure];
cap_pressure_normalized = cap_pressure.normalize();

unique_ids = unique(strata_trapped.param_ids);

trivial_poro = 1;
truivial_perm = 1;

for i = 1:size(strata_trapped.tables,1)
    % find param_id for this row of tables
    param_id = unique_ids(i);
    for dir=1:3
        % restore cap_pressure from J-functions
        leverett_j = strata_trapped.tables(i,dir).leverett_j;
        pc = cap_pressure(param_id).from_lj(leverett_j,trivial_poro,truivial_perm);
        % normalize with new J-functions
        strata_trapped.tables(i,dir).leverett_j = ...
            cap_pressure_normalized(param_id).inv_lj(pc,trivial_poro,truivial_perm);
    end
    strata_trapped.params(param_id).cap_pressure = cap_pressure_normalized(param_id);
end
end
