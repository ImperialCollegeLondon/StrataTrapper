function write_mappings(prefix,G,idx,offset)
curve_mapping = cell_to_curve(G, idx);

keywords = ["KRNUMX","KRNUMY","KRNUMZ"]; % TODO: make sure SATNUM is not necessary

num_cells = length(idx);
num_offset = [0,num_cells,num_cells*2,0]+offset;

for keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_keyword(file_name,keyword,curve_mapping,num_offset(keyword_num),1);
end

end
