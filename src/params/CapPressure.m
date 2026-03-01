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
                perm (:,:,:,:) double {mustBeNonnegative}
            end

            perm = obj.transform_perm(poro,perm);

            poresize_mult = poro./perm;
            poresize_mult(poro == 0) = 0;

            pc = obj.mult * obj.leverett_j.func(sw) * sqrt(poresize_mult);
            pc(poro == 0) = Inf;
        end

        function sw = inv(obj,pc,poro,perm)
            arguments
                obj (1,1) CapPressure
                pc  (1,1) double
                poro double {mustBeNonnegative}
                perm (:,:,:,:) double {mustBeNonnegative}
            end

            lj = obj.inv_lj(pc,poro,perm);
            lj = max(lj,obj.leverett_j.data(end,2));
            lj = min(lj,obj.leverett_j.data(1,2));

            sw = obj.leverett_j.inv(lj);
        end

        function lj = inv_lj(obj,pc,poro,perm,param_ids)
            arguments
                obj (1,:) CapPressure
                pc  double
                poro double {mustBeNonnegative}
                perm (:,:,:,:) double {mustBeNonnegative}
                param_ids = [];
            end
            if isscalar(obj)
                perm = obj.transform_perm(poro,perm);
    
                poresize_mult = perm./ poro;
                poresize_mult(poro == 0) = +Inf;
    
                lj = pc ./ obj.mult .* sqrt(poresize_mult);
                return;
            end

            lj = nan(size(pc));
            for param_id=unique(param_ids)'
                mask = param_ids == param_id;
                lj(mask,:) = obj(param_id).inv_lj(pc(mask,:),poro(mask),perm(mask,:));
            end
        end

        function dpc_dsw = deriv(obj,sw,poro,perm)
            arguments
                obj (1,1) CapPressure
                sw  (1,1) double
                poro double {mustBeNonnegative}
                perm (:,:,:,:) double {mustBePositive}
            end

            perm = obj.transform_perm(poro,perm);

            poresize_mult = poro./perm;
            poresize_mult(poro == 0) = 0;

            dpc_dsw = obj.mult * obj.leverett_j.deriv(sw) * sqrt(poresize_mult);
        end

        function perm_transformed = transform_perm(obj,poro,perm)
        arguments
            obj (1,1) CapPressure
            poro double
            perm (:,:,:,:) double 
        end
            dims_poro = size(poro);
            dims_perm = size(perm);
            if (length(dims_poro) == 3) && (length(dims_perm) == 4) && (dims_perm(4) == 3)
                perm_transformed = sum(perm .* reshape(obj.perm_weights, 1, 1, 1, 3), 4);
                return;
            end

            if (length(dims_poro) == 2) && (length(dims_perm) == 2) && (dims_perm(2) == 3)
                perm_transformed = sum(perm .* reshape(obj.perm_weights, 1, 3), 2);
                return;
            end
            perm_transformed = perm;
        end

        function cap_pressure = normalize(cap_pressure)
            % normalize J-functions so that Pc models have the same mult
            arguments
                cap_pressure (1,:) CapPressure 
            end
            mults = [cap_pressure.mult];
            mults_mean = mean(mults);
            j_func_mult = mults./mults_mean;
            for i=1:numel(cap_pressure)
                cap_pressure(i).leverett_j.data(:,2) = ...
                    cap_pressure(i).leverett_j.data(:,2) * j_func_mult(i);
                cap_pressure(i).surface_tension = ...
                    cap_pressure(i).surface_tension / j_func_mult(i);
                cap_pressure(i).mult = mults_mean;
            end
        end
    end
end
