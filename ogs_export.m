function [] = ogs_export(strata_trapped, output_folder)
arguments
    strata_trapped (1,1) struct
    output_folder  char   = 'out'
end

mkdir(output_folder);

output_prefix = append(output_folder,'/');

strata_trapped.params.ogs_export(strata_trapped.saturation,[output_prefix,'chc-fine.inc']);

write_mappings(output_prefix,strata_trapped.grid,strata_trapped.idx,1);

write_perm(output_prefix,strata_trapped.grid,strata_trapped.permeability,strata_trapped.idx);

generate_sfn(strata_trapped, output_prefix, '.data',1);

end
