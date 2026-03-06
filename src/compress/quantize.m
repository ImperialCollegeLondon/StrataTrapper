function [quantized] = quantize(strata_trapped,options)
arguments (Input)
    strata_trapped (1,1) struct
    options (1,1) QuantizeOptions = QuantizeOptions();
end
arguments (Output)
    quantized (1,1) struct
end

leverett_j = strata_trapped.params.cap_pressure.inv_lj(strata_trapped.capillary_pressure, ...
    strata_trapped.porosity, strata_trapped.permeability);

tables = repmat(struct('leverett_j',[],'krw',[],'krg',[],'mapping',[]),3,1);
for dir=1:3
    tables(dir).leverett_j = leverett_j; 
    tables(dir).krw = squeeze(strata_trapped.rel_perm_wat(:,dir,:));
    tables(dir).krg = squeeze(strata_trapped.rel_perm_gas(:,dir,:));
    tables(dir).mapping = 1:numel(strata_trapped.idx);
end

% quantize each direction
for dir = 1:3
    % FIXME: passing name-value options
    [tables_dir] = quantize_dir(tables(dir),options);
    tables(dir) = tables_dir;
end

% transform strata_trapped into direction-wise struct array
quantized = rmfield(strata_trapped,{'capillary_pressure','rel_perm_wat','rel_perm_gas'});
quantized.tables = tables;

end

function [quantized] = quantize_dir(tables_dir,options)
arguments (Input)
    tables_dir (1,1) struct
    options (1,1) QuantizeOptions
end
arguments (Output)
    quantized
end

features = to_features(tables_dir,options.use_total_mobility);

mapping_dedup = deduplicate(features,options.duplicate_threshold);
mapping_dedup(2) = 1; % FIXME: remove this test code

tables_dedup = from_quants(tables_dir,mapping_dedup);

if isempty(options.num_quants)
    quantized = tables_dedup;
    return;
end

idx_dedup = unique(mapping_dedup);
features_dedup = features(:,idx_dedup);

[features_quant,mapping_quant] = quantize_impl(features_dedup,options);

quantized = from_features(tables_dedup.mapping, features_quant, mapping_quant, ...
    options.use_total_mobility);

end

function mapping_dedup = deduplicate(features,duplicate_threshold)
    if ~isempty(duplicate_threshold)
        mapping_dedup = 1:size(features,2);
        return;
    end
end

function [features_quant,mapping_quant] = quantize_impl(features,options)

% encoding and decoders on the spot
encoded = [];
decoder = [];
switch options.dim_reduction
    case DimReduction.None    
        % Trivial transform
        encoded = features;
        decoder = @(x) x;
    case DimReduction.PCA
        % PCA representation
        [encoded, decoder] = reduce_pca(quantized);
    case DimReduction.Correlations
        % feature vector is a parametric fit
        [encoded, decoder] = reduce_corr(quantized);
end    

[mapping_quant,quants,~,~] = kmeans(encoded',options.num_quants,options.kmeans{:});

features_quant = decoder(quants');

end

function tables = from_features(mapping_prev, features, mapping_new, use_total_mobility)
    tables = struct();

    features = features';

    table_dim = size(features,2)/3;

    tables.leverett_j = 10.^features(:,1:table_dim);
    tables.krg = features(:, (2*table_dim+1):end);

    krw_or_tm = features(:, (table_dim+1):(2*table_dim));

    tables.krw = max(krw_or_tm .* (1+use_total_mobility) - tables.krg.*use_total_mobility,0);

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

function [encoded, decoder] = reduce_pca(quantized)
    error("not implemented");
end

function [encoded, decoder] = reduce_corr(quantized)
    error("not implemented");
end

function mapping = merge_maps(map_1, map_2)
    [~, ~, inv_1] = unique(map_1);
    [~, ~, inv_2] = unique(map_2);
    mapping = inv_2(inv_1);
end