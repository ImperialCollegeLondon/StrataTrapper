function [file_name] = generate_sfn(mask, saturations, pres_upscaled, krw, krg,prefix,inc_ext)
arguments
    mask           (:,1)   logical
    saturations    (1,:) double
    pres_upscaled  (:,:) double
    krw            (:,3,:) double
    krg            (:,3,:) double
    prefix char
    inc_ext char = '.inc'
end
file_name = [prefix,'sfn',inc_ext];

file_id = fopen(file_name,'w','native','UTF-8');


for direction=1:3
    write_tables_for_direction(mask,file_id,krw, krg,saturations,pres_upscaled,direction);
end
fclose(file_id);
end

function write_tables_for_direction(mask,file_id, krw, krg,saturations,pres_upscaled,direction)
for cell_index = 1:length(mask)
    if ~mask(cell_index)
        continue;
    end

    table_num = cell_index + length(mask) * (direction-1);

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
fprintf(file_id,'%f\t%f\t%f\n',data);
fprintf(file_id,'%s\n','/');
end
