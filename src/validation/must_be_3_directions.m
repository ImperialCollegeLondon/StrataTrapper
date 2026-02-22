function must_be_3_directions(array)
% MUST_BE_3_DIRECTIONS Validate that relative permeability array has 3 directional components
%
% Checks that the second dimension of a 3D array equals 3 (for x, y, z directions).
%
% Syntax:
%   must_be_3_directions(rel_perm_array)
%
% See also: compress_tables

arguments (Input)
    array (:,:,:) double
end

if size(array, 2) ~= 3
    error('compress_tables:InvalidDimensions', ...
        'Relative permeability array second dimension must be 3 (x,y,z), got %d', ...
        size(array, 2));
end

end
