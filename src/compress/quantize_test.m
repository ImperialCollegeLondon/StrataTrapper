clc;

quantized_trivial = quantize(strata_trapped,QuantizeOptions());

options = QuantizeOptions();
options.use_total_mobility = false;
options.dim_reduction = "None";
options.num_quants = 100;

quantized = quantize(strata_trapped,options);

err = compare_tables(quantized_trivial.tables,quantized.tables,options.use_total_mobility);

[err.delta_mse]