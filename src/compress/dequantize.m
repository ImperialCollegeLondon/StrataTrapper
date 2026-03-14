function [table] = dequantize(table)
arguments (Input)
    table (1,1) UpscaledTables
end

arguments (Output)
    table (1,1) UpscaledTables
end

table.leverett_j = table.leverett_j(table.mapping,:);
table.krw = table.krw(table.mapping,:);
table.krg = table.krg(table.mapping,:);
table.mapping = 1:numel(table.mapping);

end
