classdef Params
    properties
        krw (1,1) TableFunction = TableFunction([]);
        krg (1,1) TableFunction = TableFunction([]);
        cap_pressure  (1,1) CapPressure
        rho_gas (1,1) double
        rho_water (1,1) double {mustBeFinite}
        sw_resid (1,1) double
    end

    methods
        function obj = Params(krw,krg,cap_pressure, rho_gas,rho_water)
            obj.krw = krw;
            obj.krg = krg;
            obj.cap_pressure = cap_pressure;

            obj.sw_resid = obj.krw.data(1,1);

            obj.rho_gas   = rho_gas;
            obj.rho_water = rho_water;
        end
    end
end
