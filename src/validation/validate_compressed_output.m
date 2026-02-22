function validate_compressed_output(compressed)
% VALIDATE_COMPRESSED_OUTPUT Validate all invariants of compress_tables output
%
% Checks that the compressed structure maintains all required invariants:
%   - output is a (3,1) struct array (one element per direction)
%   - each element has required fields with correct dimensions
%   - mapping is valid and consistent for each direction
%   - saturation points are preserved per direction
%
% Raises an error if any invariant is violated. Does not return a value.
%
% Syntax:
%   validate_compressed_output(compressed)
%
% See also: compress_tables

arguments (Input)
    compressed (:,1) struct
end

% Validate struct array dimensions: must be (3,1)
if numel(compressed) ~= 3
    error('compress_tables:InvalidOutput', ...
        'Output must be a (3,1) struct array but has %d elements', numel(compressed));
end

% Get original table count from first direction (should be same for all)
if ~isfield(compressed(1), 'idx')
    error('compress_tables:InvalidOutput', ...
        'Output struct missing field: idx');
end
num_original = length(compressed(1).idx);

% Validate each direction independently
for dir = 1:3
    % Validate required fields exist
    required_fields = {'capillary_pressure', 'rel_perm_wat', 'rel_perm_gas', 'mapping'};
    for i = 1:length(required_fields)
        field = required_fields{i};
        if ~isfield(compressed(dir), field)
            error('compress_tables:InvalidOutput', ...
                'Direction %d: missing required field: %s', dir, field);
        end
    end

    % Validate field types
    if ~isa(compressed(dir).capillary_pressure, 'double')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: capillary_pressure must be double', dir);
    end
    if ~isa(compressed(dir).rel_perm_wat, 'double')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: rel_perm_wat must be double', dir);
    end
    if ~isa(compressed(dir).rel_perm_gas, 'double')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: rel_perm_gas must be double', dir);
    end
    if ~isa(compressed(dir).mapping, 'uint32')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: mapping must be uint32', dir);
    end

    % Get dimensions for this direction
    n_compressed_dir = size(compressed(dir).capillary_pressure, 1);
    n_sat = size(compressed(dir).capillary_pressure, 2);

    % Validate mapping dimensions: (1, num_original)
    if ~isequal(size(compressed(dir).mapping), [1, num_original])
        error('compress_tables:InvalidOutput', ...
            'Direction %d: mapping must be (1, %d) but is (%d, %d)', ...
            dir, num_original, size(compressed(dir).mapping, 1), size(compressed(dir).mapping, 2));
    end

    % Validate mapping indices are in valid range
    if any(compressed(dir).mapping < 1) || any(compressed(dir).mapping > n_compressed_dir)
        error('compress_tables:InvalidOutput', ...
            'Direction %d: mapping contains invalid indices (range: 1-%d)', ...
            dir, n_compressed_dir);
    end

    % Validate table dimensions match for this direction
    pc_size = size(compressed(dir).capillary_pressure);
    krw_size = size(compressed(dir).rel_perm_wat);
    krg_size = size(compressed(dir).rel_perm_gas);

    if pc_size(1) ~= n_compressed_dir
        error('compress_tables:InvalidOutput', ...
            'Direction %d: capillary_pressure first dimension mismatch', dir);
    end
    if krw_size(1) ~= n_compressed_dir || krg_size(1) ~= n_compressed_dir
        error('compress_tables:InvalidOutput', ...
            'Direction %d: rel perm first dimension mismatch', dir);
    end

    % Validate saturation points match within direction
    if pc_size(2) ~= n_sat || krw_size(2) ~= n_sat || krg_size(2) ~= n_sat
        error('compress_tables:InvalidOutput', ...
            'Direction %d: saturation points mismatch (pc:%d, krw:%d, krg:%d)', ...
            dir, pc_size(2), krw_size(2), krg_size(2));
    end

    % Validate output arrays are real and finite
    if ~all(isreal(compressed(dir).capillary_pressure), 'all') || ...
            ~all(isfinite(compressed(dir).capillary_pressure), 'all')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: capillary pressure contains non-real or non-finite values', dir);
    end

    if ~all(isreal(compressed(dir).rel_perm_wat), 'all') || ...
            ~all(isfinite(compressed(dir).rel_perm_wat), 'all')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: rel perm water contains non-real or non-finite values', dir);
    end

    if ~all(isreal(compressed(dir).rel_perm_gas), 'all') || ...
            ~all(isfinite(compressed(dir).rel_perm_gas), 'all')
        error('compress_tables:InvalidOutput', ...
            'Direction %d: rel perm gas contains non-real or non-finite values', dir);
    end
end

end
