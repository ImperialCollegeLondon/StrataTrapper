function must_be_valid_mapping(mapping, num_original)
% MUST_BE_VALID_MAPPING Validate that mapping array is correct format and range
%
% Checks that mapping is:
%   - uint32 row vector
%   - Has length equal to number of original tables
%   - Contains indices in valid range [1, n_compressed]
%
% Syntax:
%   must_be_valid_mapping(mapping, num_original)
%
% See also: compress_tables

arguments (Input)
    mapping (1,:) uint32
    num_original (1,1) double {mustBePositive, mustBeInteger}
end

% Check mapping is correct length
if length(mapping) ~= num_original
    error('compress_tables:InvalidOutput', ...
        'Mapping length (%d) must equal number of original tables (%d)', ...
        length(mapping), num_original);
end

% Get max index (number of compressed tables)
n_compressed = max(mapping);

% Check all mapping values are valid indices (must be non-zero positive integers)
if any(mapping < 1) || any(mapping > n_compressed)
    error('compress_tables:InvalidOutput', ...
        'Mapping indices must be in range [1, %d], found min=%d, max=%d', ...
        n_compressed, min(mapping), max(mapping));
end

end
