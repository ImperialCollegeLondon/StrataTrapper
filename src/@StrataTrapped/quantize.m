function [quantized, mse] = quantize(strata_trapped,num_quants)
arguments (Input)
    strata_trapped (1,1) StrataTrapped
    num_quants (1,1) uint32
end

arguments (Output)
    quantized (1,1) StrataTrapped
    mse (1,1) struct
end

quantized = StrataTrapped();
mse = struct([]);
end
