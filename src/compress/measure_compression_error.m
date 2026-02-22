function errors = measure_compression_error(original, compressed)
% MEASURE_COMPRESSION_ERROR Compute reconstruction error from compressed tables
%
% Quantifies how well the compressed representation approximates the original
% upscaled tables by reconstructing from compressed data and computing MSE and
% maximum absolute errors.
%
% Syntax:
%   errors = measure_compression_error(original, compressed)
%
% Input Arguments:
%   original   - struct with original table data:
%                .capillary_pressure (subset_len, sat_num_points)
%                .rel_perm_wat (subset_len, 3, sat_num_points)
%                .rel_perm_gas (subset_len, 3, sat_num_points)
%   compressed - struct with compressed data (output from compress_tables):
%                .capillary_pressure (n_compressed, sat_num_points)
%                .rel_perm_wat (n_compressed, 3, sat_num_points)  
%                .rel_perm_gas (n_compressed, 3, sat_num_points)
%                .mapping (1, subset_len) uint32
%
% Output:
%   errors - struct with error metrics:
%     mse_capillary_pressure - Mean squared error for Pc (1,1) double
%     mse_rel_perm_wat       - MSE for krw per direction (3,1) double
%     mse_rel_perm_gas       - MSE for krg per direction (3,1) double
%     max_abs_error_pc       - Maximum absolute error for Pc (1,1) double
%     max_abs_error_krw      - Max abs error for krw per direction (3,1) double
%     max_abs_error_krg      - Max abs error for krg per direction (3,1) double
%     rmse_capillary_pressure - Root mean squared error for Pc (1,1) double
%     rmse_rel_perm_wat      - RMSE for krw per direction (3,1) double
%     rmse_rel_perm_gas      - RMSE for krg per direction (3,1) double
%
% Example:
%   original = struct('capillary_pressure', pc, ...
%                     'rel_perm_wat', krw, ...
%                     'rel_perm_gas', krg);
%   compressed = compress_tables(capillary_pressure=pc, ...
%                                 rel_perm_wat=krw, ...
%                                 rel_perm_gas=krg, ...
%                                 idx=idx);
%   errors = measure_compression_error(original, compressed);
%   fprintf('Pc MSE: %.2e, Max error: %.2e\n', ...
%           errors.mse_capillary_pressure, errors.max_abs_error_pc);
%
% See also: compress_tables

arguments
    original (1,1) struct
    compressed (1,1) struct
end

% Validate required fields in original
required_fields_orig = {'capillary_pressure', 'rel_perm_wat', 'rel_perm_gas'};
for i = 1:length(required_fields_orig)
    field = required_fields_orig{i};
    assert(isfield(original, field), ...
        'measure_compression_error:MissingField', ...
        'original struct missing required field: %s', field);
end

% Validate required fields in compressed
required_fields_comp = {'capillary_pressure', 'rel_perm_wat', 'rel_perm_gas', 'mapping'};
for i = 1:length(required_fields_comp)
    field = required_fields_comp{i};
    assert(isfield(compressed, field), ...
        'measure_compression_error:MissingField', ...
        'compressed struct missing required field: %s', field);
end

% Get dimensions
subset_len = size(original.capillary_pressure, 1);
sat_num_points = size(original.capillary_pressure, 2);

% Validate mapping
assert(length(compressed.mapping) == subset_len, ...
    'measure_compression_error:DimensionMismatch', ...
    'mapping length (%d) must match original table count (%d)', ...
    length(compressed.mapping), subset_len);

assert(all(compressed.mapping >= 1) && all(compressed.mapping <= size(compressed.capillary_pressure, 1)), ...
    'measure_compression_error:InvalidMapping', ...
    'mapping indices must be in range [1, %d]', size(compressed.capillary_pressure, 1));

% Reconstruct original data from compressed representation
reconstructed_pc = compressed.capillary_pressure(compressed.mapping, :);
reconstructed_krw = compressed.rel_perm_wat(compressed.mapping, :, :);
reconstructed_krg = compressed.rel_perm_gas(compressed.mapping, :, :);

% Compute errors for capillary pressure
diff_pc = original.capillary_pressure - reconstructed_pc;
errors.mse_capillary_pressure = mean(diff_pc(:).^2);
errors.rmse_capillary_pressure = sqrt(errors.mse_capillary_pressure);
errors.max_abs_error_pc = max(abs(diff_pc(:)));

% Compute errors for rel_perm_wat per direction
errors.mse_rel_perm_wat = zeros(3, 1);
errors.rmse_rel_perm_wat = zeros(3, 1);
errors.max_abs_error_krw = zeros(3, 1);

for dir = 1:3
    diff_krw = squeeze(original.rel_perm_wat(:, dir, :)) - squeeze(reconstructed_krw(:, dir, :));
    errors.mse_rel_perm_wat(dir) = mean(diff_krw(:).^2);
    errors.rmse_rel_perm_wat(dir) = sqrt(errors.mse_rel_perm_wat(dir));
    errors.max_abs_error_krw(dir) = max(abs(diff_krw(:)));
end

% Compute errors for rel_perm_gas per direction
errors.mse_rel_perm_gas = zeros(3, 1);
errors.rmse_rel_perm_gas = zeros(3, 1);
errors.max_abs_error_krg = zeros(3, 1);

for dir = 1:3
    diff_krg = squeeze(original.rel_perm_gas(:, dir, :)) - squeeze(reconstructed_krg(:, dir, :));
    errors.mse_rel_perm_gas(dir) = mean(diff_krg(:).^2);
    errors.rmse_rel_perm_gas(dir) = sqrt(errors.mse_rel_perm_gas(dir));
    errors.max_abs_error_krg(dir) = max(abs(diff_krg(:)));
end

end
