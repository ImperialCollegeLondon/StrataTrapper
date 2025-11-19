function write_perm(prefix,G,perm,idx)
perm = perm / milli / darcy;
perm_mapping = zeros(G.cells.num,3);
perm_mapping(G.cells.indexMap(idx),:) = perm;
keywords = ["PERMX","PERMY","PERMZ"];
for keyword_num = 1:length(keywords)
    keyword = keywords(keyword_num);
    file_name = join([prefix,keyword,".inc"],'');
    write_keyword(file_name,keyword,perm_mapping(:,keyword_num),0,0);
end
end

