function [table] = dequantize(table)
arguments (Input)
    table (1,1) struct
end

arguments (Output)
    table (1,1) struct
end

table.leverett_j = table.leverett_j(quantized.mapping,:);
table.krw = table.krw(quantized.mapping,:);
table.krg = table.krg(quantized.mapping,:);
table.mapping = 1:numel(quantized.mapping);

end
