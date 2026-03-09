clc;
organized = strata_trapped;

quantized_trivial = quantize(organized,QuantizeOptions());

options = QuantizeOptions();
options.fit_total_mobility = false;
options.num_quants = 3;
options.duplicate_threshold = 0.0;
options.num_principal_components = 3;
options.fit_parametric = true;

clc; tic;
quantized = quantize(organized,options);
toc;

err = compare_tables(quantized_trivial.tables,quantized.tables,quantized.saturation,false,false,[]);
arrayfun(@(err) err.delta_mse, err,"UniformOutput",true)
%%

plot_result(quantized,1,"visible",'on');
plot_result(quantized,2,"visible",'on');

