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

        function export_ogs(params,sw,file_path)
            chc_file = fopen(file_path,'wb','native','UTF-8');

            fprintf(chc_file,'%s %f %s\n\n','JLEV_GW', ...
            params.cap_pressure.surface_tension / (dyne / centi /meter) ...
            * cos(params.cap_pressure.contact_angle),'XY dynes/cm');

            write_sat_jlev(1,chc_file,...
                params.krw.func(sw),...
                params.krg.func(1-sw),...
                sw,...
                params.cap_pressure.leverett_j.func(sw));
            fclose(chc_file);
        end

        function export_str = export_opm(params,sw)
            sg = 1 - sw;
            krg = params.krg.func(sg); %#ok<PROPLC>
            krw = params.krw.func(sw); %#ok<PROPLC>
            jfunc = params.cap_pressure.leverett_j.func(sw);
            data = [sg;krg;krw;jfunc]; %#ok<PROPLC>
            data = data(:,end:-1:1);
            export_str = sprintf('%e\t%e\t%e\t%e\n',data);
        end
    end
end
