function must_match_saturation_points(array, reference)
% MUST_MATCH_SATURATION_POINTS Validate saturation point count matches reference array
%
% Checks that the saturation dimension (typically the last dimension) of an array
% equals the saturation dimension of a reference array.
%
% Syntax:
%   must_match_saturation_points(table_array, reference_array)
%
% See also: compress_tables

arguments (Input)
    array (:,:,:) double
    reference (:,:) double
end

% For 3D array, saturation points are in third dimension
% For reference 2D array, saturation points are in second dimension
array_sat_points = size(array, 3);
reference_sat_points = size(reference, 2);

if array_sat_points ~= reference_sat_points
    error('compress_tables:DimensionMismatch', ...
        'Array saturation points (%d) must match reference array (%d)', ...
        array_sat_points, reference_sat_points);
end

end
