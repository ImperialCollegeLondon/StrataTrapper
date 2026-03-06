function [quantized, mse] = quantize(strata_trapped,options)
arguments (Input)
    strata_trapped (1,1) struct
    options.use_total_mobility (1,1) logical = false
    options.duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
    options.dim_reduction (1,1) DimReduction = DimReduction.None
    options.num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
end
arguments (Output)
    quantized (1,1) struct
    mse
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
mse = [0,0,0];
for dir = 1:3
    % FIXME: passing name-value options
    [tables_dir, mse(dir)] = quantize_dir(tables(dir));
    tables(dir) = tables_dir;
end

% transform strata_trapped into direction-wise struct array
quantized = rmfield(strata_trapped,{'capillary_pressure','rel_perm_wat','rel_perm_gas'});
quantized.tables = tables;

end

function [quantized, mse] = quantize_dir(tables_dir,options)
arguments (Input)
    tables_dir (1,1) struct
    options.use_total_mobility (1,1) logical = false
    options.duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
    options.dim_reduction (1,1) DimReduction = DimReduction.None
    options.num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
end
arguments (Output)
    quantized
    mse
end

quantized = tables_dir;
mse = 0;
return;

% prepare split features {J,krw,krg}

if options.use_total_mobility
    % augment inputs
    % replace krw with total mobility
end

% prepare trivial quantization
quantized = struct([]);

[quantized,mse] = deduplicate(quantized,options.duplicate_threshold);

if isempty(options.num_quants)
    % quantization not required
    return;
end

[quantized, mse, mse_reduction] = quantize_impl(quantized,options);

end

function [output, mse] = deduplicate(input,duplicate_threshold);
    if ~isempty(duplicate_threshold)
        output = input;
        return;
    end
end

function [output, mse, mse_reduction] = quantize_impl(input,options)

% encoding and decoders on the spot
encoded = [];
decoder = [];
switch options.dim_reduction
    case DimReduction.None    
        % Trivial transform
        mse_reduction = 0;
    case DimReduction.PCA
        % PCA representation
        [encoded, decoder, mse_reduction] = reduce_pca(quantized);
    case DimReduction.Correlations
        % feature vector is a parametric fit
        [encoded, decoder, mse_reduction] = reduce_corr(quantized);
end    

% quantize in latent space
quants = kmeans(encoded,options.num_quants);

decoded = decoder(quants);

output = [];
mse = [];

end

function features = to_features(quantized)

end

function quantized = from_features(features)

end

function [encoded, decoder, mse_reduction] = reduce_pca(quantized)

end

function [encoded, decoder, mse_reduction] = reduce_corr(quantized)

end
