function write_mappings(prefix,G,perm,idx)
curve_mapping = cell_to_curve(G, idx);

keywords = ["KRNUMX","KRNUMY","KRNUMZ","SATNUM"];

num_permeable_cells = length(idx);
num_offset = [0,num_permeable_cells,num_permeable_cells*2,0];

parfor keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_curve_nums(file_name,keyword,curve_mapping,1,num_offset(keyword_num));
end

perm_mapping = zeros(G.cells.num,3);
perm_mapping(G.cells.indexMap(idx),:) = perm;
keywords = ["PERMX","PERMY","PERMZ"];
parfor keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_curve_nums(file_name,keyword,perm_mapping(:,keyword_num),0,0);
end

end
