function generate_sfn(strata_trapped,prefix,inc_ext)
arguments
    strata_trapped
    prefix char
    inc_ext char
end

strata_trapped = normalize_lj(strata_trapped);

dir_label = ['x','y','z'];

offset = numel(strata_trapped.params);
for param_id=1:size(strata_trapped.tables,1)
    for direction=1:3
        file_name = sprintf('%schc%u%s%s',prefix,param_id,dir_label(direction),inc_ext);
        file_id = fopen(file_name,'wb','native','UTF-8');

        sw = strata_trapped.saturation(param_id,:);

        offset = write_table(file_id,sw,strata_trapped.tables(param_id,direction),offset);

        fclose(file_id);
    end
end

end


function new_offset = write_table(file_id,sw,table,offset)
    num_tables = numel(unique(table.mapping));
    for m = 1:num_tables
        table_num = offset + m;

        fprintf(file_id,'CHARACTERISTIC_CURVES chc_%u\n',table_num);
        fprintf(file_id,'%s\n%s\n','TABLE swfn_table','PRESSURE_UNITS None');

        write_sfn_table(file_id,"SWFN",sw,table.krw(m,:),table.leverett_j(m,:));

        fprintf(file_id,'%s\n%s\n%s\n','END','TABLE sgfn_table','PRESSURE_UNITS None');

        sg = 1 - sw; sg = sg(end:-1:1);
        write_sfn_table(file_id,"SGFN",sg, table.krg(m,end:-1:1),zeros(size(sg)));

        fprintf(file_id,'%s\n%s\n','END','END');
    end
    new_offset = offset + num_tables;
end
