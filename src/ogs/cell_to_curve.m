function [curve_mapping, permeable_cells] = cell_to_curve(G,perm)
    permeable_cells = 1:G.cells.num;
    is_permeable = geomean(perm,2,"omitnan") > 0;
    permeable_cells(is_permeable == 0) = [];
    curve_mapping = zeros(prod(G.cartDims),1);
    curve_mapping(G.cells.indexMap(permeable_cells)) = 1:length(permeable_cells);
end
