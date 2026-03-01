function [quantized, mse] = quantize(strata_trapped,args)
arguments (Input)
    strata_trapped (1,1) struct
    args.use_total_mobility (1,1) logical = false
    args.duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
    args.dim_reduction (1,1) DimReduction = DimReduction.None
    args.num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
end
arguments (Output)
    quantized (3,1) struct
    mse (3,1) struct
end

% transform strata_trapped into direction-wise struct array
quantized = [];

% prepare split features {J,krw,krg}

if args.use_total_mobility
    % augment inputs
    % replace krw with total mobility
end

% quantize each direction
for dir = 1:3
    [quantized(dir), mse(dir)] = quantize_dir(quantized(dir),args);
end

end

function [quantized, mse] = quantize_dir(input_dir,args)
arguments (Input)
    input_dir (1,1) struct
    args.use_total_mobility (1,1) logical = false
    args.duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
    args.dim_reduction (1,1) DimReduction = DimReduction.None
    args.num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
end
arguments (Output)
    quantized
    mse
end

% prepare split features {J,krw,krg}

if args.use_total_mobility
    % augment inputs
    % replace krw with total mobility
end

% prepare trivial quantization
quantized = struct([]);

[quantized,mse] = deduplicate(quantized,args.duplicate_threshold);

if isempty(args.num_quants)
    % quantization not required
    return;
end

[quantized, mse, mse_reduction] = quantize_impl(quantized,args);

end

function [output, mse] = deduplicate(input,duplicate_threshold);
    if ~isempty(duplicate_threshold)
        output = input;
        return;
    end
end

function [output, mse, mse_reduction] = quantize_impl(input,args)

% encoding and decoders on the spot
encoded = [];
decoder = [];
switch args.dim_reduction
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
quants = kmeans(encoded,args.num_quants);

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
