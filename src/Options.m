classdef Options
    properties
        sat_num_points (1,1) uint32 {mustBePositive} = 40
        sat_tol (1,1) double {mustBeNonnegative} = 1e-8
        subscale (1,1) double {mustBePositive} = 50 * meter();
    end
end
