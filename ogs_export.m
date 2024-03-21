function [] = ogs_export(G, mask, strata_trapped, output_prefix)
arguments
    G              (1,1) struct
    mask           (:,1) logical
    strata_trapped (1,1) struct
    output_prefix  char   = 'model/'
end

write_mappings(output_prefix,G,strata_trapped.permeability ./ milli ./ darcy(), strata_trapped.porosity);

generate_sfn(...
    mask, ...
    strata_trapped.saturation, ...
    strata_trapped.capillary_pressure ./ barsa(), ...
    strata_trapped.rel_perm_wat, ...
    strata_trapped.rel_perm_gas, ...
    output_prefix, '.dat');
end

