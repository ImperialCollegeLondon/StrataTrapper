function [quantized] = quantize(strata_trapped,options)
arguments (Input)
    strata_trapped (1,1) struct
    options (1,1) QuantizeOptions = QuantizeOptions();
end
arguments (Output)
    quantized (1,1) struct
end

quantized = strata_trapped;

for param_id = 1:size(strata_trapped.tables,1)
    sw = strata_trapped.saturation(param_id,:);
    for dir = 1:size(strata_trapped.tables,2)
        tables_quant = quantize_table(strata_trapped.tables(param_id,dir),sw,options);
        quantized.tables(param_id,dir) = tables_quant;
    end
end

end

function [quantized] = quantize_table(tables_dir,sw,options)
arguments (Input)
    tables_dir (1,1) UpscaledTables
    sw
    options (1,1) QuantizeOptions
end
arguments (Output)
    quantized
end

[features,decoder] = to_features(tables_dir,sw,options.fit_parametric,options.fit_total_mobility,...
    options.num_principal_components,options.num_par_workers);

mapping_dedup = deduplicate(features,options.duplicate_threshold);

tables_dedup = from_quants(tables_dir,mapping_dedup);

idx_dedup = unique(mapping_dedup);
features_dedup = features(:,idx_dedup);

if isempty(options.num_quants)
    features_decoded = decoder(features_dedup);
    quantized = from_features(tables_dir.mapping, features_decoded, mapping_dedup, ...
         options.fit_total_mobility);
    return;
end

options.num_quants = min(options.num_quants,size(features_dedup,2));
[mapping_quant,quants,~,~] = kmeans(features_dedup',options.num_quants,options.kmeans{:});

features_quant = decoder(quants');

quantized = from_features(tables_dedup.mapping, features_quant, mapping_quant, ...
    options.fit_total_mobility);

end

function mapping_dedup = deduplicate(features,duplicate_threshold)
if isempty(duplicate_threshold)
    mapping_dedup = 1:size(features,2);
    return;
end

num_samples = size(features,2);

mapping_dedup = zeros(1,num_samples);

sorted_features = sort(abs(features),1,"ascend");

checksums = sum(sorted_features,1);
sorted_checksums = sort(checksums,"ascend");
checksum_diffs = diff(sorted_checksums);

can_dedup = any(checksum_diffs <= duplicate_threshold);

if ~can_dedup
    mapping_dedup = 1:size(features,2);
    return;
end

for ref_sample_num=1:num_samples
    % exit early if all mappings are ready
    if mapping_dedup(ref_sample_num) ~=0
        continue;
    end
    if all(mapping_dedup)
        break;
    end
    % find all close checksums to ref_sample_num
    is_sample_close = abs(checksums(mapping_dedup==0) - checksums(ref_sample_num)) ...
        <= duplicate_threshold;

    mapping_dedup(mapping_dedup==0) = mapping_dedup(mapping_dedup==0)...
        +is_sample_close*ref_sample_num;
end
end

function tables = from_features(mapping_prev, features, mapping_new, fit_total_mobility)
tables = UpscaledTables();

features = features';

table_dim = size(features,2)/3;

tables.leverett_j = 10.^features(:,1:table_dim);
tables.krg = features(:, (2*table_dim+1):end);

krw_or_tm = features(:, (table_dim+1):(2*table_dim));

tables.krw = max(krw_or_tm .* (1+fit_total_mobility) - tables.krg.*fit_total_mobility,0);

tables.mapping = merge_maps(mapping_prev,mapping_new);
end

function tables_quant = from_quants(tables,mapping)
tables_quant = tables;
[quant_idx, ~, ic] = unique(mapping);
tables_quant.leverett_j = tables_quant.leverett_j(quant_idx,:);
tables_quant.krw = tables_quant.krw(quant_idx,:);
tables_quant.krg = tables_quant.krg(quant_idx,:);
tables_quant.mapping = ic';
end

function mapping = merge_maps(map_1, map_2)
[~, ~, inv_1] = unique(map_1);
[~, ~, inv_2] = unique(map_2);
mapping = inv_2(inv_1);
end

