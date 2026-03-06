clc;
options = QuantizeOptions();
options.use_total_mobility = true;
[quantized, mse] = quantize(strata_trapped,options);