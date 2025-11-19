function [] = opm_export(strata_trapped, output_folder)
arguments
    strata_trapped (1,1) struct
    output_folder  char   = 'opm'
end

mkdir(output_folder);
output_prefix = append(output_folder,'/');

tab_dims = 1 + numel(strata_trapped.idx)*3;
write_keyword([output_prefix,'TABDIMS.inc'],'TABDIMS',tab_dims,0,0);

grid = strata_trapped.grid;

% export porosity
porosity = zeros(grid.cells.num,1);
porosity(grid.cells.indexMap(strata_trapped.idx)) = strata_trapped.porosity;
write_keyword([output_prefix,'PORO.inc'],'PORO',porosity,0,0);

% export permeability
write_perm(output_prefix,strata_trapped.grid,strata_trapped.permeability,strata_trapped.idx);

% Write JFUNC include file
mult = strata_trapped.params.cap_pressure.mult / (dyne / centi / meter);
jfunc_line = sprintf("'WATER' 0.0 %f * * XY /", mult); % TODO: generalize 'XY'
jfunc_str = {"JFUNC",jfunc_line};
jfunc_fid = fopen([output_prefix,'JFUNC.inc'],'wb','native','UTF-8');
fprintf(jfunc_fid,'%s\n',jfunc_str{:});
fclose(jfunc_fid);

% Write mappings
write_mappings(output_prefix,strata_trapped.grid,strata_trapped.idx,1);

% Write umbrella GRID file
grid_str = {
    "INCLUDE"
    "PORO.inc /"
    ""
    "INCLUDE"
    "PERMX.inc /"
    ""
    "INCLUDE"
    "PERMY.inc /"
    ""
    "INCLUDE"
    "PERMZ.inc /"
    ""
    "INCLUDE"
    "JFUNC.inc /"
    };
grid_fid = fopen([output_prefix,'GRID.inc'],'wb','native','UTF-8');
fprintf(grid_fid,'%s\n',grid_str{:});
fclose(grid_fid);

% Write umbrella REGIONS file
regions_str = {
    "INCLUDE"
    "KRNUMX.inc /"
    ""
    "INCLUDE"
    "KRNUMY.inc /"
    ""
    "INCLUDE"
    "KRNUMZ.inc /"
    };
regions_fid = fopen([output_prefix,'REGIONS.inc'],'wb','native','UTF-8');
fprintf(regions_fid,'%s\n',regions_str{:});
fclose(regions_fid);

% Write single SGWFN file: 1 + NX*NY*NZ*3 tables
write_sgwfn(strata_trapped,output_prefix);

%{
RUNSPEC

TABDIMS
1 -- 1 + NX*NY*NZ*3
/

GRID

INCLUDE
poro_upsc.inc /

INCLUDE
permx_upsc.inc /

INCLUDE
permy_upsc.inc /

INCLUDE
permz_upsc.inc /

JFUNC
'WATER' 0.0 28.750878 * * XY /

PROPS

SGWFN
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- x1
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- x2
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- y1
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- y2
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- z1
0.0 0.0 1.0 0.0
0.5 0.5 0.5 0.0
1.0 1.0 0.0 0.0 / -- z2

REGIONS

KRNUMX
115200*1
/

KRNUMY
115200*2
/

KRNUMZ
115200*3
/
%}

end

function write_sgwfn(strata_trapped,prefix)
arguments
    strata_trapped
    prefix char
end

original_sgwfn = strata_trapped.params.export_opm(strata_trapped.saturation);

leverett_j = strata_trapped.params.cap_pressure.inv_lj(...
    strata_trapped.capillary_pressure,...
    strata_trapped.porosity,...
    strata_trapped.permeability);

sgwfn_fid = fopen([prefix,'SGWFN.inc'],'wb','native','UTF-8');
fprintf(sgwfn_fid,'%s\n',"SGWFN");
% 1. Write original table
fprintf(sgwfn_fid,'%s/ -- 1: original fine-scale curves\n',original_sgwfn);
% 2. Write upscaled tables
for direction=1:3
    write_tables_for_direction(sgwfn_fid, strata_trapped.idx,...
        strata_trapped.rel_perm_wat, strata_trapped.rel_perm_gas,...
        strata_trapped.saturation,leverett_j,...
        direction);
end
fclose(sgwfn_fid);

end

function write_tables_for_direction(file_id,idx, krw, krg,saturations,leverett_j,direction)
dir_label = ['X','Y','Z'];
for cell_index = 1:length(idx)
    sw = saturations;
    sg = 1 - sw;
    krg_cell = squeeze(krg(cell_index,direction,:))';
    krw_cell  = squeeze(krw(cell_index,direction,:))';
    jfunc = leverett_j(cell_index,:);
    data = [sg;krg_cell;krw_cell;jfunc];
    data = data(:,end:-1:1);

    fprintf(file_id,'%e\t%e\t%e\t%e\n',data);
    fprintf(file_id,'/ -- KRNUM%s cell %u\n',dir_label(direction),idx(cell_index));
end
end
