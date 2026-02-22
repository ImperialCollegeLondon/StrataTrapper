strata_trapped.param_ids = ones(size(strata_trapped.idx));
organized = organize(strata_trapped);
quantized_trivial = quantize(organized,QuantizeOptions());
%%
options = QuantizeOptions();

options.fit_parametric = false;

options.fit_total_mobility = false;

options.num_principal_components = 40;

options.duplicate_threshold = 1e-3;

options.num_quants = [];

options.num_par_workers = Inf;

clc; tic;
quantized = quantize(organized,options);
toc;

err = compare_tables(quantized_trivial.tables,quantized.tables,quantized.saturation,false,false,[]);
arrayfun(@(err) err.delta_mse, err,"UniformOutput",true)

close all;
plot_result(quantized_trivial,1,"visible",'on','kr_scale',"linear");
plot_result(quantized,1,"visible",'on','kr_scale',"linear");
% plot_result(quantized,2,"visible",'on');

%%