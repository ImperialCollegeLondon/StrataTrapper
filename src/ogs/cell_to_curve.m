function [curve_mapping] = cell_to_curve(G,idx)
    curve_mapping = zeros(prod(G.cartDims),1);
    curve_mapping(G.cells.indexMap(idx)) = 1:length(idx);
end
