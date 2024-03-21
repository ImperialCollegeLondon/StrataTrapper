function [result_new, result_base, upd_base] = struct_diff(struct_new, struct_base)
    fields_new = fieldnames(struct_new);
    fields_base = fieldnames(struct_base);

    new_diff_base = setdiff(fields_new, fields_base);
    base_diff_new = setdiff(fields_base, fields_new);
    assert(numel(base_diff_new)==0);

    result_new = struct();

    for i = 1:numel(new_diff_base)
        result_new.(new_diff_base{i}) = struct_new.(new_diff_base{i});
    end

    result_base = struct_base;
    upd_base = struct();

    field_intersect = intersect(fields_new, fields_base);
    for i = 1:numel(field_intersect)
        if ~isequal(struct_new.(field_intersect{i}), struct_base.(field_intersect{i}))
            upd_base.(field_intersect{i}) = struct_new.(field_intersect{i});
            result_base = rmfield(result_base, field_intersect{i});
            warning('base struct field updated and placed in the new struct')
        end
    end
end
