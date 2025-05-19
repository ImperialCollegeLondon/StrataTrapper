function write_keyword(file_name, keyword, data, offset, data_fallback)
arguments
    file_name {mustBeText}
    keyword {mustBeText}
    data (:,1) {mustBeNumericOrLogical}
    offset (1,1) {mustBeNumericOrLogical}
    data_fallback (1,1) {mustBeNumericOrLogical}
end

data(data~=0) = data(data~=0) + offset;
data(data==0) = data_fallback;

output_fid =  fopen(file_name,'wb','native','UTF-8');
    
    fprintf(output_fid,keyword + "\n");
    fprintf(output_fid,"%u\n",data);
    fprintf(output_fid,"/\n");

fclose(output_fid);
end
