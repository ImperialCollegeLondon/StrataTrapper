function generate_sfn(idx, saturations, pres_upscaled, krw, krg,prefix,inc_ext)
arguments
    idx            (1,:)   double
    saturations    (1,:) double
    pres_upscaled  (:,:) double
    krw            (:,3,:) double
    krg            (:,3,:) double
    prefix char
    inc_ext char = '.data'
end

dir_label = ['x','y','z'];

parfor direction=1:3
    file_name = [prefix,'chc',dir_label(direction),inc_ext];
    file_id = fopen(file_name,'wt','native','UTF-8');
    write_tables_for_direction(idx,file_id,krw, krg,saturations,pres_upscaled,direction);
    fclose(file_id);
end

end

function write_tables_for_direction(idx,file_id, krw, krg,saturations,pres_upscaled,direction)
for cell_index = 1:length(idx)
    table_num = cell_index + length(idx) * (direction-1);

    fprintf(file_id,'CHARACTERISTIC_CURVES sfn_%u\n',table_num);
    fprintf(file_id,'%s\n%s\n',...
        'TABLE swfn_table',...
        'PRESSURE_UNITS Bar');

    sw = saturations;
    write_sfn_table(file_id,"SWFN",...
        sw, ...
        squeeze(krw(cell_index,direction,:)), ...
        pres_upscaled(cell_index,:));

    fprintf(file_id,'%s\n%s\n%s\n',...
        'END',...
        'TABLE sgfn_table',...
        'PRESSURE_UNITS Bar');

    sg = 1 - sw;
    sg = sg(end:-1:1);
    write_sfn_table(file_id,"SGFN",...
        sg, ...
        squeeze(krg(cell_index,direction,end:-1:1)), ...
        zeros(size(sg)));

    fprintf(file_id,'%s\n%s\n',...
        'END',...
        'END');
end
end
