function write_poro(output_prefix,grid,poro,idx,default_poro)
arguments (Input)
    output_prefix
    grid
    poro
    idx
    default_poro
end

export_porosity = zeros(prod(grid.cartDims),1);
if ~isempty(default_poro)
    export_porosity(:) = default_poro;
end
export_porosity(grid.cells.indexMap(idx)) = poro;
write_keyword([output_prefix,'PORO.inc'],'PORO',export_porosity,0,0);
end
