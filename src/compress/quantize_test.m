clc;
organized = strata_trapped;

quantized_trivial = quantize(organized,QuantizeOptions());

options = QuantizeOptions();
options.fit_total_mobility = false;
options.num_quants = 100;
options.duplicate_threshold = 0.0;
options.num_principal_components = [];

clc; tic;
quantized = quantize(organized,options);
toc;

err = compare_tables(quantized_trivial.tables,quantized.tables,false,false,[]);

arrayfun(@(err) err.delta_mse, err,"UniformOutput",true)
%%

plot_result(organized,1,"visible",'on');

opm_export(strata_trapped,satnum=1);
