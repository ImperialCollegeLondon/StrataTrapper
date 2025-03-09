function write_mappings(prefix,G,idx)
curve_mapping = cell_to_curve(G, idx);

keywords = ["KRNUMX","KRNUMY","KRNUMZ","SATNUM"];

num_cells = length(idx);
num_offset = [0,num_cells,num_cells*2,0];

for keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_curve_nums(file_name,keyword,curve_mapping,1,num_offset(keyword_num));
end

end
