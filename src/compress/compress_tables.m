function compressed = compress_tables(idx, capillary_pressure, rel_perm_wat, rel_perm_gas, ...
    porosity, permeability, params, args)
% COMPRESS_TABLES Compress upscaled saturation tables by removing duplicates and clustering
%
% Reduces storage requirements for strata_trapper output by identifying similar
% capillary pressure and relative permeability curves and replacing them with
% representative curves. Processes each spatial direction independently.
%
% Syntax:
%   compressed = compress_tables(idx, capillary_pressure, rel_perm_wat, rel_perm_gas, ...
%                                porosity, permeability, params)
%   compressed = compress_tables(..., duplicate_tolerance=1e-8)
%
% Input Arguments (Required, Positional):
%   idx                - Original cell indices from strata_trapper output
%                        (1, subset_len) double
%   capillary_pressure - Upscaled capillary pressure tables
%                        (subset_len, sat_num_points) double
%   rel_perm_wat       - Upscaled water relative permeability tables
%                        (subset_len, 3, sat_num_points) double
%                        Dimensions: (cells, [x y z], saturation_points)
%   rel_perm_gas       - Upscaled gas relative permeability tables
%                        (subset_len, 3, sat_num_points) double
%   porosity           - Cell porosity values for J-function computation
%                        (subset_len, 1) double
%   permeability       - Cell permeability values for J-function computation
%                        (subset_len, 3) double [Kx, Ky, Kz]
%   params             - CapPressure object array (contains contact angle, surface tension)
%                        (1, n_params) CapPressure
%
% Input Arguments (Optional, Name-Value):
%   duplicate_tolerance - Absolute tolerance for checksum comparison (default: 0)
%                        Checksums within this tolerance are considered duplicates.
%                        Default of 0 means exact duplicates only.
%
% Output:
%   compressed - (3,1) struct array (one per direction)
%                Each element compressed(dir) has fields:
%     capillary_pressure - (n_compressed_dir, sat_num_points) double
%                          Compressed Pc tables for this direction
%     rel_perm_wat       - (n_compressed_dir, sat_num_points) double
%                          Compressed krw tables for this direction
%     rel_perm_gas       - (n_compressed_dir, sat_num_points) double
%                          Compressed krg tables for this direction
%     mapping            - (1, subset_len) uint32
%                          Maps original idx to compressed table index for this direction
%
% Example:
%   % After running strata_trapper
%   st = strata_trapper(grid, rock, params_obj);
%   compressed = compress_tables(st.idx, st.capillary_pressure, ...
%                                 st.rel_perm_wat, st.rel_perm_gas, ...
%                                 st.porosity, st.permeability, params_obj);
%   for dir = 1:3
%       n_original = length(compressed(dir).mapping);
%       n_compressed = size(compressed(dir).capillary_pressure, 1);
%       fprintf('Direction %d: Compressed %d tables to %d (%.1f%% reduction)\n', ...
%               dir, n_original, n_compressed, 100*(1 - n_compressed/n_original));
%   end
%
%   % With custom tolerance
%   compressed = compress_tables(st.idx, st.capillary_pressure, ...
%                                 st.rel_perm_wat, st.rel_perm_gas, ...
%                                 st.porosity, st.permeability, params_obj, ...
%                                 duplicate_tolerance=1e-8);
%
% See also: measure_compression_error, strata_trapper, CapPressure

arguments (Input)
    idx (1,:) double {mustBePositive, mustBeInteger}
    capillary_pressure (:,:) double {mustBeReal, mustBeFinite, ...
        must_match_table_count(capillary_pressure, idx)}
    rel_perm_wat (:,:,:) double {mustBeReal, mustBeFinite, ...
        must_be_3_directions(rel_perm_wat), ...
        must_match_table_count(rel_perm_wat, idx), ...
        must_match_saturation_points(rel_perm_wat, capillary_pressure)}
    rel_perm_gas (:,:,:) double {mustBeReal, mustBeFinite, ...
        must_be_3_directions(rel_perm_gas), ...
        must_match_table_count(rel_perm_gas, idx), ...
        must_match_saturation_points(rel_perm_gas, capillary_pressure)}
    porosity (:,1) double {mustBeReal, mustBeFinite, mustBeNonnegative, ...
        must_match_table_count(porosity, idx)}
    permeability (:,3) double {mustBeReal, mustBeFinite, mustBeNonnegative, ...
        must_match_table_count(permeability, idx)}
    params (1,:) {mustBeOfClass(params, 'CapPressure')}
    args.duplicate_tolerance (1,1) double {mustBeNonnegative} = 0
end

arguments (Output)
    compressed (3,1) struct {validate_compressed_output(compressed)}
end

% Step 1: Compute J-function using CapPressure.inv_lj() method
% For single param_id case (Phase 2 scope)
cap_pressure_obj = params(1);  % Extract CapPressure object
leverett_j = cap_pressure_obj.inv_lj(capillary_pressure, porosity, permeability);
% Shape: (subset_len, sat_num_points)

% Step 2: Process each direction independently using nested function
compressed = repmat(struct('leverett_j', [], 'rel_perm_wat', [], ...
    'rel_perm_gas', [], 'mapping', []), 3, 1);

for dir = 1:3
    % Extract per-direction relative permeabilities
    krw_dir = squeeze(rel_perm_wat(:, dir, :));  % (subset_len, sat_num_points)
    krg_dir = squeeze(rel_perm_gas(:, dir, :));  % (subset_len, sat_num_points)

    % Call nested function to compress this direction
    compressed(dir) = compress_tables_dir(leverett_j, krw_dir, krg_dir, ...
        capillary_pressure, ...
        args.duplicate_tolerance);
end

% For output validation purposes
for dir = 1:3
    compressed(dir).idx = idx;
end

end

% TODO: Introduce bisect to satisfy given MSE upper bounds
function dir_compressed = compress_tables_dir(leverett_j, krw_dir, krg_dir, ...
    pc_original, tolerance)
% COMPRESS_TABLES_DIR Compress tables for a single spatial direction
%
% Performs sum-based duplicate detection on the joint feature vector
% [J-function, krw, krg] for this direction.
%
% Inputs:
%   leverett_j  - (subset_len, sat_num_points) J-function values
%   krw_dir     - (subset_len, sat_num_points) water rel perm for this direction
%   krg_dir     - (subset_len, sat_num_points) gas rel perm for this direction
%   pc_original - (subset_len, sat_num_points) original capillary pressure
%   tolerance   - duplicate detection tolerance (scalar double)
%
% Output:
%   dir_compressed - struct with fields:
%     capillary_pressure - (n_compressed, sat_num_points)
%     rel_perm_wat       - (n_compressed, sat_num_points)
%     rel_perm_gas       - (n_compressed, sat_num_points)
%     mapping            - (1, subset_len) uint32

n_cells = size(leverett_j, 1);
n_sat = size(leverett_j, 2);

feature_vectors = build_feature_vectors(n_cells,n_sat,leverett_j,krw_dir,krg_dir);

origin = min(feature_vectors,[],1)';
[U,S,V] = svd(feature_vectors'-origin,"econ");

n_pca = round(n_sat*3*0.1);
Ur = U(:,1:n_pca);

feature_latent = V(:,1:n_pca);

options.UseParallel = false;
options.UseSubstreams = false;

[km_idx,km_c,km_sumd,km_d] = kmeans(feature_latent,round(n_cells*0.1),'OnlinePhase','off',...
    'MaxIter',1000,"Display","iter","Options",options,'Distance','sqeuclidean');

km_c = (Ur * S(1:n_pca,1:n_pca) * km_c'+origin)';

% Build output struct for this direction
dir_compressed = struct();
% FIXME: return J-funcs
dir_compressed.leverett_j = 10.^km_c(:,1:n_sat);
dir_compressed.rel_perm_wat = km_c(:, (n_sat+1):(2*n_sat));
dir_compressed.rel_perm_gas = km_c(:, (2*n_sat+1):end);
dir_compressed.mapping = uint32(km_idx)';
return;

% Compute checksums using sorted sum (minimize rounding errors)
% NOTE: Instead, I could do N^2/2 comparisons of pair-wise MSEs, but might
% be too much. Instead, I can compute N checksums and N diffs, and
% then run M bisect iterations to match my MSE criteria
checksums = zeros(n_cells, 1);
for cell_idx = 1:n_cells
    sorted_values = sort(feature_vectors(cell_idx, :));
    checksums(cell_idx) = sum(sorted_values, 'double');
end

% Find unique tables within tolerance
[sorted_checksums, sort_idx] = sort(checksums);

% Mark unique entries (first of each group within tolerance)
% TODO: consider enhancing this comparison, leveraging small cumulative diffs.
% The current impl effectively halves the number of tables,
% as it compares adjasent checksums.
% Option 1:
% Option 2: compare all N*(N-1)/2 disances pair-wise (it starts to look like
% k-means)
unique_mask = true(n_cells, 1);
unique_mask(2:end) = diff(sorted_checksums) > tolerance;

% Find indices of unique representatives
unique_indices = sort_idx(unique_mask);

% Build mapping: original index -> unique representative index
compressed_idx_map = zeros(n_cells, 1, 'uint32');
compressed_counter = uint32(1);
current_group_rep = 1;

for i = 1:n_cells
    if unique_mask(i)
        % This is a unique representative
        compressed_idx_map(sort_idx(i)) = compressed_counter;
        current_group_rep = compressed_counter;
        compressed_counter = compressed_counter + 1;
    else
        % This is a duplicate of the previous representative
        compressed_idx_map(sort_idx(i)) = current_group_rep;
    end
end

% Build output struct for this direction
dir_compressed = struct();
% FIXME: return J-funcs
dir_compressed.leverett_j = leverett_j(unique_indices, :);
dir_compressed.rel_perm_wat = krw_dir(unique_indices, :);
dir_compressed.rel_perm_gas = krg_dir(unique_indices, :);
dir_compressed.mapping = compressed_idx_map';
end

function feature_vectors = build_feature_vectors(n_cells,n_sat,leverett_j,krw_dir,krg_dir)
% Build feature vectors: [J, krw, krg]
feature_vectors = zeros(n_cells, 3 * n_sat);
for cell_idx = 1:n_cells
    j_curve = leverett_j(cell_idx, :);
    krw_curve = krw_dir(cell_idx, :);
    krg_curve = krg_dir(cell_idx, :);
    feature_vectors(cell_idx, :) = [log10(j_curve), krw_curve, krg_curve];
end
feature_vectors(~isfinite(feature_vectors)) = 0;
end