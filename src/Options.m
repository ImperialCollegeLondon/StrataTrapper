classdef Options
    properties
        sat_num_points (1,1) uint32 {mustBePositive} = 40
        sat_tol (1,1) double {mustBeNonnegative} = 1e-4
        hydrostatic_correction (1,1) logical = false
        m_save_mip_step (1,1) {mustBeOfClass(m_save_mip_step,'logical')} = false;
    end

    methods % builders
        function self = save_mip_step(self,flag)
            self.m_save_mip_step = flag;
        end
    end
end
