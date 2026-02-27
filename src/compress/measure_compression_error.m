function errors = measure_compression_error(original, compressed)
% MEASURE_COMPRESSION_ERROR Compute reconstruction error from compressed tables
%
% Quantifies how well the compressed representation approximates the original
% upscaled tables by reconstructing from compressed data and computing MSE and
% maximum absolute errors per direction.
%
% Syntax:
%   errors = measure_compression_error(original, compressed)
%
% Input Arguments:
%   original   - struct with original table data:
%                .leverett_j (subset_len, sat_num_points)
%                .rel_perm_wat (subset_len, 3, sat_num_points)
%                .rel_perm_gas (subset_len, 3, sat_num_points)
%   compressed - (3,1) struct array from compress_tables
%                Each element compressed(dir) has:
%                .leverett_j (n_compressed_dir, sat_num_points)
%                .rel_perm_wat (n_compressed_dir, sat_num_points)
%                .rel_perm_gas (n_compressed_dir, sat_num_points)
%                .mapping (1, subset_len) uint32
%
% Output:
%   errors - struct with error metrics (all per direction):
%     mse_leverett_j - Mean squared error for Pc (3,1) double
%     mse_rel_perm_wat       - MSE for krw per direction (3,1) double
%     mse_rel_perm_gas       - MSE for krg per direction (3,1) double
%     max_abs_error_pc       - Maximum absolute error for Pc (3,1) double
%     max_abs_error_krw      - Max abs error for krw per direction (3,1) double
%     max_abs_error_krg      - Max abs error for krg per direction (3,1) double
%     rmse_leverett_j - Root mean squared error for Pc (3,1) double
%     rmse_rel_perm_wat      - RMSE for krw per direction (3,1) double
%     rmse_rel_perm_gas      - RMSE for krg per direction (3,1) double
%
% Example:
%   original = struct('leverett_j', pc, ...
%                     'rel_perm_wat', krw, ...
%                     'rel_perm_gas', krg);
%   compressed = compress_tables(idx, pc, krw, krg, poro, perm, params);
%   errors = measure_compression_error(original, compressed);
%   fprintf('X-direction Pc MSE: %.2e, Max error: %.2e\n', ...
%           errors.mse_leverett_j(1), errors.max_abs_error_pc(1));
%
% See also: compress_tables

arguments
    original (1,1) struct
    compressed (3,1) struct
end

% Validate required fields in original
required_fields_orig = {'capillary_pressure', 'rel_perm_wat', 'rel_perm_gas'};
for i = 1:length(required_fields_orig)
    field = required_fields_orig{i};
    assert(isfield(original, field), ...
        'measure_compression_error:MissingField', ...
        'original struct missing required field: %s', field);
end

% Validate dimensions
subset_len = size(original.capillary_pressure, 1);

% Validate compressed struct array
assert(numel(compressed) == 3, ...
    'measure_compression_error:InvalidStructure', ...
    'compressed must be a (3,1) struct array');

% Validate required fields in compressed per direction
required_fields_comp = {'leverett_j', 'rel_perm_wat', 'rel_perm_gas', 'mapping'};
for dir = 1:3
    for i = 1:length(required_fields_comp)
        field = required_fields_comp{i};
        assert(isfield(compressed(dir), field), ...
            'measure_compression_error:MissingField', ...
            'compressed(%d) missing required field: %s', dir, field);
    end
    
    % Validate mapping dimensions for this direction
    assert(size(compressed(dir).mapping, 1) == 1 ...
        && size(compressed(dir).mapping, 2) == subset_len, ...
        'measure_compression_error:DimensionMismatch', ...
        'Direction %d: mapping must be (1, %d) but is (%d, %d)', ...
        dir, subset_len, size(compressed(dir).mapping, 1), size(compressed(dir).mapping, 2));
end

% Initialize error metrics (all per direction now)
% FIXME: compare J-functions
errors.mse_leverett_j = zeros(3, 1);
errors.rmse_leverett_j = zeros(3, 1);
errors.max_abs_error_jfunc = zeros(3, 1);
errors.mse_rel_perm_wat = zeros(3, 1);
errors.rmse_rel_perm_wat = zeros(3, 1);
errors.max_abs_error_krw = zeros(3, 1);
errors.mse_rel_perm_gas = zeros(3, 1);
errors.rmse_rel_perm_gas = zeros(3, 1);
errors.max_abs_error_krg = zeros(3, 1);

% Compute errors per direction
for dir = 1:3
    mapping_dir = compressed(dir).mapping;
    
    % Validate mapping indices for this direction
    n_compressed_dir = size(compressed(dir).leverett_j, 1);
    assert(all(mapping_dir >= 1) && all(mapping_dir <= n_compressed_dir), ...
        'measure_compression_error:InvalidMapping', ...
        'Direction %d: mapping indices must be in range [1, %d]', dir, n_compressed_dir);
    
    % Reconstruct capillary pressure for this direction
    cap_pressure_obj = original.params.cap_pressure;
    original_leverett_j = cap_pressure_obj.inv_lj(original.capillary_pressure, ...
        original.porosity, original.permeability);
    reconstructed_jfunc = compressed(dir).leverett_j(mapping_dir, :);
    diff_jfunc = original_leverett_j - reconstructed_jfunc;
    errors.mse_leverett_j(dir) = mean(diff_jfunc(:).^2);
    errors.rmse_leverett_j(dir) = sqrt(errors.mse_leverett_j(dir));
    errors.max_abs_error_jfunc(dir) = max(abs(diff_jfunc(:)));
    
    % Reconstruct rel_perm_wat for this direction
    reconstructed_krw = compressed(dir).rel_perm_wat(mapping_dir, :);
    original_krw_dir = squeeze(original.rel_perm_wat(:, dir, :));
    diff_krw = original_krw_dir - reconstructed_krw;
    errors.mse_rel_perm_wat(dir) = mean(diff_krw(:).^2);
    errors.rmse_rel_perm_wat(dir) = sqrt(errors.mse_rel_perm_wat(dir));
    errors.max_abs_error_krw(dir) = max(abs(diff_krw(:)));
    
    % Reconstruct rel_perm_gas for this direction
    reconstructed_krg = compressed(dir).rel_perm_gas(mapping_dir, :);
    original_krg_dir = squeeze(original.rel_perm_gas(:, dir, :));
    diff_krg = original_krg_dir - reconstructed_krg;
    errors.mse_rel_perm_gas(dir) = mean(diff_krg(:).^2);
    errors.rmse_rel_perm_gas(dir) = sqrt(errors.mse_rel_perm_gas(dir));
    errors.max_abs_error_krg(dir) = max(abs(diff_krg(:)));
end

end
