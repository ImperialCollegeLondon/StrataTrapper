classdef Options
    properties
        sat_num_points (1,1) uint32 {mustBePositive} = 40
        sat_tol (1,1) double {mustBeNonnegative} = 1e-4
        hydrostatic_correction (1,1) logical = false
        m_save_mip_step (1,1) {mustBeOfClass(m_save_mip_step,'logical'),mustBeA(m_save_mip_step,'logical')} = false;
        m_perm_threshold_mD (1,3) double {mustBeNonnegative} = [0,0,0];
        m_poro_threshold    (1,1) double {mustBeNonnegative} = 0;
    end

    methods % builders
        function self = save_mip_step(self,flag)
            self.m_save_mip_step = flag;
        end

        function self = perm_threshold_mD(self,value)
            self.m_perm_threshold_mD = value;
        end

        function self = poro_threshold(self,value)
            self.m_poro_threshold = value;
        end
    end
end
