classdef Params
    properties
        krw (1,1) TableFunction = TableFunction([]);
        krg (1,1) TableFunction = TableFunction([]);
        cap_pressure  (1,1) CapPressure
        sw_resid (1,1) double
    end
    
    methods
        function obj = Params(krw,krg,cap_pressure)
            obj.krw = krw;
            obj.krg = krg;
            obj.cap_pressure = cap_pressure;

            obj.sw_resid = obj.krw.data(1,1);
        end
    end
end

