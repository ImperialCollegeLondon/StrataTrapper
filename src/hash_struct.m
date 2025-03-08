function [hash] = hash_struct(input)
fields = fieldnames(input);
hash = 0;
for i = 1:numel(fields)
    field_name = fields{i};
    hash_i = keyHash(input.(field_name));
    hash = keyHash([hash,hash_i]);
end
end

