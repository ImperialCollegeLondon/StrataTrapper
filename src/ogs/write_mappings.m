function write_mappings(prefix,G,perm,poro)
[curve_mapping, permeable_cells] = cell_to_curve(G, perm);

keywords = ["KRNUMX","KRNUMY","KRNUMZ","SATNUM"];

num_permeable_cells = length(permeable_cells);
num_offset = [0,num_permeable_cells,num_permeable_cells*2,0];

parfor keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_curve_nums(file_name,keyword,curve_mapping,1,num_offset(keyword_num));
end

perm_mapping = zeros(G.cells.num,3);
perm_mapping(G.cells.indexMap,:) = perm;
keywords = ["PERMX","PERMY","PERMZ"];
parfor keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".grdecl"],'');
    write_curve_nums(file_name,keyword,perm_mapping(:,keyword_num),0,0);
end

poro_mapping = zeros(G.cells.num,1);
poro_mapping(G.cells.indexMap) = poro;
keyword = "PORO";
file_name = join([prefix,keyword,".grdecl"],'');
write_curve_nums(file_name,"PORO",poro_mapping,0,0);

end
