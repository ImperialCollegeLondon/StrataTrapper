function validate_compressed_output(compressed)
% VALIDATE_COMPRESSED_OUTPUT Validate all invariants of compress_tables output
%
% Checks that the compressed structure maintains all required invariants:
%   - mapping is valid and consistent
%   - all output tables have correct dimensions
%   - saturation points are preserved
%   - rel perm arrays maintain 3 directions
%
% Raises an error if any invariant is violated. Does not return a value.
%
% Syntax:
%   validate_compressed_output(compressed)
%
% See also: compress_tables

arguments (Input)
    compressed (1,1) struct
end

% Validate required fields exist
required_fields = {'capillary_pressure', 'rel_perm_wat', 'rel_perm_gas', 'mapping'};
for i = 1:length(required_fields)
    field = required_fields{i};
    if ~isfield(compressed, field)
        error('compress_tables:InvalidOutput', ...
            'Output struct missing required field: %s', field);
    end
end

% Validate mapping
num_original = length(compressed.idx);
must_be_valid_mapping(compressed.mapping, num_original);

% Validate table dimensions match compression targets
must_have_matching_compressed_count(compressed.capillary_pressure, compressed.mapping);
must_have_matching_compressed_count(compressed.rel_perm_wat, compressed.mapping);
must_have_matching_compressed_count(compressed.rel_perm_gas, compressed.mapping);

% Validate rel perms still have 3 directions
must_be_3_directions(compressed.rel_perm_wat);
must_be_3_directions(compressed.rel_perm_gas);

% Validate saturation points are preserved
must_preserve_saturation_points(compressed.capillary_pressure, ...
                                 compressed.rel_perm_wat, ...
                                 compressed.rel_perm_gas);

% Validate output arrays are real and finite (no NaN or Inf)
if ~all(isreal(compressed.capillary_pressure), 'all') || ...
   ~all(isfinite(compressed.capillary_pressure), 'all')
    error('compress_tables:InvalidOutput', ...
        'Capillary pressure output contains non-real or non-finite values');
end

if ~all(isreal(compressed.rel_perm_wat), 'all') || ...
   ~all(isfinite(compressed.rel_perm_wat), 'all')
    error('compress_tables:InvalidOutput', ...
        'Relative permeability (water) output contains non-real or non-finite values');
end

if ~all(isreal(compressed.rel_perm_gas), 'all') || ...
   ~all(isfinite(compressed.rel_perm_gas), 'all')
    error('compress_tables:InvalidOutput', ...
        'Relative permeability (gas) output contains non-real or non-finite values');
end

end
