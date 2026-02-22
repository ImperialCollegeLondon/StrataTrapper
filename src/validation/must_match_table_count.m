function must_match_table_count(array, idx)
% MUST_MATCH_TABLE_COUNT Validate that array's table count matches index array length
%
% Checks that the first dimension of an array (regardless of total dimensions) 
% equals the length of the index array, ensuring arrays have the correct number of tables.
%
% Works with 2D and 3D arrays:
%   - 2D: (num_tables, sat_points)
%   - 3D: (num_tables, 3, sat_points)
%
% Syntax:
%   must_match_table_count(table_array, idx)
%
% See also: compress_tables

arguments (Input)
    array
    idx (1,:) double
end

if size(array, 1) ~= length(idx)
    error('compress_tables:DimensionMismatch', ...
        'Array first dimension (%d) must match index array length (%d)', ...
        size(array, 1), length(idx));
end

end
