function must_have_matching_compressed_count(table_array, mapping)
% MUST_HAVE_MATCHING_COMPRESSED_COUNT Validate table array has correct number of compressed tables
%
% Checks that the first dimension of a table array equals the number of unique
% compression targets (max(mapping)).
%
% Works with 2D and 3D arrays:
%   - 2D: (num_compressed, sat_points)
%   - 3D: (num_compressed, 3, sat_points)
%
% Syntax:
%   must_have_matching_compressed_count(table_array, mapping)
%
% See also: compress_tables

arguments (Input)
    table_array
    mapping (1,:) uint32
end

n_compressed = max(mapping);

if size(table_array, 1) ~= n_compressed
    error('compress_tables:InvalidOutput', ...
        'Table array first dimension (%d) must equal number of compressed tables (%d)', ...
        size(table_array, 1), n_compressed);
end

end
