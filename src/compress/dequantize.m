function [dequantized] = dequantize(quantized)
arguments (Input)
    quantized (1,1) struct
end

arguments (Output)
    dequantized (1,1) struct
end

dequantized.leverett_j = quantized.leverett_j(quantized.mapping,:);
dequantized.krw = quantized.krw(quantized.mapping,:);
dequantized.krg = quantized.krg(quantized.mapping,:);
dequantized.mapping = 1:numel(quantized.mapping);

end
