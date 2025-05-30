function [] = ogs_export(strata_trapped, output_folder)
arguments
    strata_trapped (1,1) struct
    output_folder  char   = 'out'
end

mkdir(output_folder);

output_prefix = append(output_folder,'/');

grid = strata_trapped.grid;

% export porosity
porosity = zeros(grid.cells.num,1);
porosity(grid.cells.indexMap(strata_trapped.idx)) = strata_trapped.porosity;
write_keyword([output_prefix,'PORO.inc'],'PORO',porosity,0,0);

% export fine-scale curves
strata_trapped.params.export_ogs(strata_trapped.saturation,[output_prefix,'chc.inc']);

% export upscaled curves
generate_sfn(strata_trapped,output_prefix,'.data',1);

% export curve mappings
write_mappings(output_prefix,strata_trapped.grid,strata_trapped.idx,1);

% export permeability
write_perm(output_prefix,strata_trapped.grid,strata_trapped.permeability,strata_trapped.idx);


% create grid properties include file
grid_fid = fopen([output_prefix,'grid.inc'],'wb','native','UTF-8');

fprintf(grid_fid,...
    "INCLUDE\n" + ...
    """PORO.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """PERMX.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """PERMY.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """PERMZ.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """KRNUMX.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """KRNUMY.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """KRNUMZ.inc"" /\n" + ...
    "\n" + ...
    "INCLUDE\n" + ...
    """SATNUM.inc"" /\n" + ...
    "\n");

fclose(grid_fid);

% create curves include file
curve_fid = fopen([output_prefix,'curves.inc'],'wb','native','UTF-8');

fprintf(curve_fid,...
    "EXTERNAL_FILE ""chc.inc""\n" + ...
    "EXTERNAL_FILE ""chcx.data""\n" + ...
    "EXTERNAL_FILE ""chcy.data""\n" + ...
    "EXTERNAL_FILE ""chcz.data""\n" + ...
    "\n");

fclose(curve_fid);

end
