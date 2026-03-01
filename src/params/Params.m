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
            arguments
                params (1,:) Params {mustBeNonempty}
                sw (:,:) double
                file_path char
            end

            cap_pressure = [params.cap_pressure]; %#ok<PROPLC>
            cap_pressure = cap_pressure.normalize(); %#ok<PROPLC>

            chc_file = fopen(file_path,'wb','native','UTF-8');

            fprintf(chc_file,'%s %f %s\n\n','JLEV_GW', ...
                cap_pressure(1).mult / (dyne / centi /meter),'XY dynes/cm'); %#ok<PROPLC>

            for tab_num=1:numel(params)
                sw_tab = sw(tab_num,:);
                write_sat_jlev(tab_num,chc_file,...
                    params(tab_num).krw.func(sw_tab),...
                    params(tab_num).krg.func(1-sw_tab),...
                    sw_tab,...
                    cap_pressure(tab_num).leverett_j.func(sw_tab)); %#ok<PROPLC>
            end


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
