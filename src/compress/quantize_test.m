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

plot_result(organised,1,"visible",'off');
