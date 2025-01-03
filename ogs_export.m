function [] = ogs_export(G, strata_trapped, output_folder)
arguments
    G              (1,1) struct
    strata_trapped (1,1) struct
    output_folder  char   = 'out'
end

mkdir(output_folder);

output_prefix = append(output_folder,'/');

write_mappings(output_prefix,G,strata_trapped.permeability ./ milli ./ darcy(),strata_trapped.idx);

generate_sfn(...
    strata_trapped.idx, ...
    strata_trapped.saturation, ...
    strata_trapped.capillary_pressure ./ barsa(), ...
    strata_trapped.rel_perm_wat, ...
    strata_trapped.rel_perm_gas, ...
    output_prefix, '.data');
end
