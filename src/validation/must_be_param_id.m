function must_be_param_id(mask,params)
arguments (Input)
    mask   (:,1) {mustBeOfClass(mask,"uint8")}
    params (1,:) Params
end

unique_ids = unique(mask);
is_param_ids = all(ismember(unique_ids, 0:numel(params)));

if ~is_param_ids
    error("mask is not consistent with the array of input parameters");
end

end
