classdef CapPressure
    properties
        contact_angle (1,1) double = deg2rad(0)
        surface_tension (1,1) double = 20 * dyne() / (centi()*meter())
        leverett_j (1,1) TableFunction = TableFunction([]);
        perm_weights (1,3) double {mustBeNonnegative} = [0.5,0.5,0]; % K = (Kx + Ky) / 2
        mult (1,1) double = nan;
    end

    methods
        function obj = CapPressure(contact_angle,surface_tension,leverett_j,perm_weights)
            if nargin==0
                return;
            end

            obj.contact_angle = contact_angle;
            obj.surface_tension = surface_tension;
            obj.leverett_j = leverett_j;
            obj.mult = cos(contact_angle) * surface_tension;

            obj.perm_weights = perm_weights./sum(perm_weights);
        end

        function pc = func(obj,sw,poro,perm)
            arguments
                obj (1,1) CapPressure
                sw  (1,1) double
                poro double {mustBeNonnegative}
                perm double {mustBePositive}
            end

            perm = obj.transform_perm(poro,perm);

            pc = obj.mult * obj.leverett_j.func(sw) * sqrt(poro./perm);
        end

        function sw = inv(obj,pc,poro,perm)
            arguments
                obj (1,1) CapPressure
                pc  (1,1) double
                poro double {mustBeNonnegative}
                perm double {mustBeNonnegative}
            end

            lj = obj.inv_lj(pc,poro,perm);
            lj = min(lj,obj.leverett_j.data(1,2));
            lj = max(lj,obj.leverett_j.data(end,2));

            sw = obj.leverett_j.inv(lj);
        end

        function lj = inv_lj(obj,pc,poro,perm)
            arguments
                obj (1,1) CapPressure
                pc  double
                poro double {mustBeNonnegative}
                perm double {mustBeNonnegative}
            end

            perm = obj.transform_perm(poro,perm);

            lj = pc ./ obj.mult .* sqrt(perm./poro);
        end

        function dpc_dsw = deriv(obj,sw,poro,perm)
            arguments
                obj (1,1) CapPressure
                sw  (1,1) double
                poro double {mustBeNonnegative}
                perm double {mustBePositive}
            end

            perm = obj.transform_perm(poro,perm);

            dpc_dsw = obj.mult * obj.leverett_j.deriv(sw) * sqrt(poro./perm);
        end

        function perm = transform_perm(obj,poro,perm)
            dims_poro = size(poro);
            dims_perm = size(perm);
            if (length(dims_poro) == 3) && (length(dims_perm) == 4) && (dims_perm(4) == 3)
                perm = sum(perm .* reshape(obj.perm_weights, 1, 1, 1, 3), 4);
                return;
            end

            if (length(dims_poro) == 2) && (length(dims_perm) == 2) && (dims_perm(2) == 3)
                perm = sum(perm .* reshape(obj.perm_weights, 1, 3), 2);
            end
        end
    end
end
