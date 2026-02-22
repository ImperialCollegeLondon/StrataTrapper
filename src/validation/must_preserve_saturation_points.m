function must_preserve_saturation_points(pc_compressed, krw_compressed, krg_compressed)
% MUST_PRESERVE_SATURATION_POINTS Validate saturation points are consistent across outputs
%
% Ensures that capillary pressure and relative permeability tables in compressed
% output have the same saturation axis.
%
% Syntax:
%   must_preserve_saturation_points(pc_compressed, krw_compressed, krg_compressed)
%
% See also: compress_tables

arguments (Input)
    pc_compressed (:,:) double
    krw_compressed (:,:,:) double
    krg_compressed (:,:,:) double
end

% Saturation points for 2D pc array is second dimension
pc_sat_points = size(pc_compressed, 2);

% Saturation points for 3D krw/krg arrays is third dimension
krw_sat_points = size(krw_compressed, 3);
krg_sat_points = size(krg_compressed, 3);

if pc_sat_points ~= krw_sat_points
    error('compress_tables:InvalidOutput', ...
        'Capillary pressure saturation points (%d) must match rel_perm_wat (%d)', ...
        pc_sat_points, krw_sat_points);
end

if pc_sat_points ~= krg_sat_points
    error('compress_tables:InvalidOutput', ...
        'Capillary pressure saturation points (%d) must match rel_perm_gas (%d)', ...
        pc_sat_points, krg_sat_points);
end

end
