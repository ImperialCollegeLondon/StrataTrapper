quantized_trivial = quantize(strata_trapped,QuantizeOptions());

options = QuantizeOptions();
options.fit_total_mobility = false;
options.dim_reduction = "PCA";
options.num_quants = 10;
options.duplicate_threshold = 0.0;
options.num_pc = 3;

clc; tic;
quantized = quantize(strata_trapped,options);
toc;

err = compare_tables(quantized_trivial.tables,quantized.tables,false);

[err.delta_mse]
