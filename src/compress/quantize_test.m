clc;
organised = organise(strata_trapped);

quantized_trivial = quantize(organised,QuantizeOptions());

options = QuantizeOptions();
options.fit_total_mobility = false;
options.dim_reduction = "PCA";
options.num_quants = 1;
options.duplicate_threshold = 0.0;
options.num_pc = 3;

clc; tic;
quantized = quantize(organised,options);
toc;

err = compare_tables(quantized_trivial.tables,quantized.tables,false);

[err.delta_mse]
%%

organised = organise(strata_trapped);

function output = organise(strata_trapped)
% TODO: support multiple param_ids

tables = repmat(struct('leverett_j',[],'krw',[],'krg',[],'mapping',[]),...
    numel(strata_trapped.params),3);

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