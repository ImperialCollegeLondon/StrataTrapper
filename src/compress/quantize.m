function [quantized] = quantize(strata_trapped,args)
arguments (Input)
    strata_trapped (1,1) struct
    args.use_total_mobility (1,1) logical = false
    args.duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
    args.dim_reduction (1,1) DimReduction = DimReduction.None
    args.num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
end
arguments (Output)
    quantized
end

% prepare split features {J,krw,krg}

if args.use_total_mobility
    % augment inputs
    % replace krw with total mobility
end

% merge inputs to feature vectors


% prepare trivial quantization
quantized = struct([]);

quantized = deduplicate(quantized,args.duplicate_threshold);

if isempty(args.num_quants)
    % return de-duplicated data
    return;
end

switch args.dim_reduction
    case DimReduction.None    
        % Trivial feature vectors
    case DimReduction.PCA
        % PCA representation
    case DimReduction.Correlations
        % feature vector is a parametric fit
end

% cluster in feature space

% reconstruct back to representative tables
switch args.dim_reduction
    case DimReduction.None    
        % Trivial reconstruction
    case DimReduction.PCA
        % decoding
    case DimReduction.Correlations
        % sample from representative functions
end

% return quantized approximation

end

function output = deduplicate(input,duplicate_threshold);
    if ~isempty(duplicate_threshold)
        output = input;
        return;
    end
end
