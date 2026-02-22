function output = organize(strata_trapped)
% organize tables by param_id and direction, and convert Pc to J

tables = repmat(UpscaledTables(),numel(strata_trapped.params),3);

for param_id=1:numel(strata_trapped.params)

    mask = strata_trapped.param_ids == param_id;

    leverett_j= strata_trapped.params(param_id).cap_pressure.inv_lj(...
        strata_trapped.capillary_pressure(mask,:),...
        strata_trapped.porosity(mask,:),...
        strata_trapped.permeability(mask,:));

    for dir=1:3
        tables(param_id,dir).leverett_j = leverett_j;
        tables(param_id,dir).krw = squeeze(strata_trapped.rel_perm_wat(mask,dir,:));
        tables(param_id,dir).krg = squeeze(strata_trapped.rel_perm_gas(mask,dir,:));
        tables(param_id,dir).mapping = 1:numel(strata_trapped.idx(mask));
    end
end
output = rmfield(strata_trapped,{'capillary_pressure','rel_perm_wat','rel_perm_gas'});
output.tables = tables;
end
