function write_sfn_table(file_id,table_name,sat,kr,pc)
arguments
    file_id
    table_name string
    sat (1,:) double
    kr (1,:) double
    pc (1,:) double
end

data = [sat;kr;pc];

fprintf(file_id,'%s\n',table_name);
fprintf(file_id,'%e\t%e\t%e\n',data);
fprintf(file_id,'%s\n','/');
end
