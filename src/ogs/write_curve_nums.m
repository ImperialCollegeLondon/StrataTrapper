function write_curve_nums(file_name,keyword,curve_mapping, fallback_curve_num, offset)
line_ending = "\n";

%% FIXME: use fopen + fprintf to write data
% fopen(file_name,'wb','native','UTF-8');
writelines(keyword,file_name,LineEnding=line_ending,WriteMode='overwrite');

mapping_to_write = curve_mapping;
mapping_to_write(curve_mapping==0) = fallback_curve_num;
mapping_to_write(curve_mapping~=0) = mapping_to_write(curve_mapping~=0) + offset;
writematrix(mapping_to_write,file_name,FileType="text",WriteMode="append",Delimiter='space');

writelines(["/",""],file_name,LineEnding=line_ending,WriteMode='append');
end
