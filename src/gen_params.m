function [params] = gen_params()

krw_data = [...
     0.12	0		
     0.15	0.05		
     0.25	0.1		
     0.35	0.3		
     0.45	0.55		
     0.65	0.85		 
     0.8	0.97		
     0.9	1		
     1	    1
     ];

krg_data = [...
        0.0 0
        0.1	0.01
        0.2	0.02
        0.35 0.04
        0.55 0.2
        0.65 0.4
        0.75 0.7
        0.85 1
        0.88 1
        ];

contact_angle   = deg2rad(0);
surface_tension = 20 * dyne() / (centi()*meter());
leverett_j_data = [
        0.12 10
        0.15 9
        0.25 8
        0.35 7
        0.45 6
        0.65 5
        0.8 4
        0.9 3
        1 2
        ];

params = Params(...
    TableFunction(krw_data),...
    TableFunction(krg_data),...
    CapPressure(...
    contact_angle,...
    surface_tension,...
    TableFunction(leverett_j_data)));

%% Downscaling params
params = struct(params);

params.corr_lens = [50,50,0].*meter();

poro_gen = @(num_samples) randn(1,num_samples)*0.01 + 0.2;
perm_gen = @(num_samples) exp(randn(1,num_samples) + log(100)) * milli * darcy;

params.poro_perm_gen = @(num_samples) [poro_gen(num_samples); perm_gen(num_samples)];
end
