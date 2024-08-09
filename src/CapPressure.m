classdef CapPressure
    properties
        contact_angle (1,1) double = deg2rad(0)
        surface_tension (1,1) double = 20 * dyne() / (centi()*meter())
        leverett_j (1,1) TableFunction = TableFunction([]);
        mult (1,1) double = nan;
    end

    methods
        function obj = CapPressure(contact_angle,surface_tension,leverett_j)
            if nargin==0
                return;
            end
            
            obj.contact_angle = contact_angle;
            obj.surface_tension = surface_tension;
            obj.leverett_j = leverett_j;
            obj.mult = cos(contact_angle) * surface_tension;
        end

        function pc = func(obj,sw,poro,perm)
            arguments
                obj (1,1) CapPressure
                sw  (1,1) double
                poro double {mustBeNonnegative}
                perm double {mustBePositive}
            end
            pc = obj.mult * obj.leverett_j.func(sw) * sqrt(poro./perm);
        end

        function sw = inv(obj,pc,poro,perm)
            arguments
                obj (1,1) CapPressure
                pc  (1,1) double
                poro double {mustBePositive}
                perm double {mustBeNonnegative}
            end
            lj = pc ./ obj.mult .* sqrt(perm./poro);

            lj = min(lj,obj.leverett_j.data(1,2));
            lj = max(lj,obj.leverett_j.data(end,2));

            sw = obj.leverett_j.inv(lj);
        end

        function dpc_dsw = deriv(obj,sw,poro,perm)
            arguments
                obj (1,1) CapPressure
                sw  (1,1) double
                poro double {mustBeNonnegative}
                perm double {mustBePositive}
            end
            dpc_dsw = obj.mult * obj.leverett_j.deriv(sw) * sqrt(poro./perm);
        end
    end
end
