function write_krnum(prefix,G,idx,orig_tabnum,orig_satnum)
arguments
    prefix
    G
    idx
    orig_tabnum {mustBeInteger, mustBePositive} % original number of SATNUM regions
    orig_satnum = []; % original SATNUM (required if orig_tabnum > 1)
end

if (orig_tabnum == 1)
    orig_satnum = 1;
elseif isempty(orig_satnum)
    error("Original SATNUM is required when orig_tabnum > 1")
end

curve_mapping = cell_to_curve(G, idx);

keywords = ["KRNUMX","KRNUMY","KRNUMZ"];

num_cells = length(idx);
krnum = [0,num_cells,num_cells*2]+orig_tabnum;

for keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_keyword(file_name,keyword,curve_mapping,krnum(keyword_num), orig_satnum);
end

end
