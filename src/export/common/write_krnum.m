function write_krnum(prefix,G,idx,tables,param_ids,args)
arguments
    prefix
    G
    idx
    tables
    param_ids
    args.orig_satnum = []; % original SATNUM (required if orig_tabnum > 1)
end

orig_tabnum = numel(unique(param_ids));

if (orig_tabnum == 1)
    args.orig_satnum = 1;
elseif isempty(args.orig_satnum)
    error("Original SATNUM is required when orig_tabnum > 1")
end

krnum = zeros(prod(G.cartDims),3);
num_tables_prev = orig_tabnum;
for param_id = 1:orig_tabnum
    active_cells = idx(param_ids == param_id);
    cart_cells = G.cells.indexMap(active_cells);
    for dir=1:3
        krnum(cart_cells,dir) = num_tables_prev + tables(param_id,dir).mapping;
        num_tables_prev = max(krnum(:));
    end
end

keywords = ["KRNUMX","KRNUMY","KRNUMZ"];

for dir = 1:3
    keyword = keywords(dir);
    file_name = join([prefix,keyword,".inc"],'');
    write_keyword(file_name, keyword, krnum(:,dir), 0, args.orig_satnum);
end

end
