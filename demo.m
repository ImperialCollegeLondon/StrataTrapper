function demo(args)
arguments
    args.parfor_arg = Inf;
    args.show_figures = true;
    args.show_progress = true;
end

if args.show_figures
    visible = 'on';
else
    visible = 'off';
end

%% StrataTrapper demonstration

% parpool(); % start default parpool (optional)

startup;

%% Inputs

params  = gen_params (); % input rock-fluid parameters

downscale_params = gen_downscale_params();

%% Grid & rock properties

[grid, rock] = grid_demo(downscale_params);

%% Run StrataTrapper

mask = uint8([0;1;2;1;0;1;2;1;0]); % process only a fraction of cells
params(2) = gen_params_2();
downscale_mask = true(grid.cells.num,1);
downscale_mask(1:numel(mask)) = mask > 0;
sub_rock = downscale(grid,rock,downscale_params.corr_lens,downscale_mask);

options = Options().save_mip_step(true);

strata_trapped = strata_trapper(grid, sub_rock, params, ...
    mask=mask, options=options, ...
    enable_waitbar=args.show_progress,...
    parfor_arg=args.parfor_arg...
    );

%% Visualize saturation functions

plot_result(strata_trapped,1,visible=visible);
plot_result(strata_trapped,2,visible=visible);

%% OGS inputs generation

ogs_export(strata_trapped,satnum=1);

% export_fut = parfeval(backgroundPool,@ogs_export,0,strata_trapped); % or run in background

%% OPM Flow inputs generation

opm_export(strata_trapped,satnum=1);

%% Output compression

test_output_compression(strata_trapped,visible);

end

function test_output_compression(strata_trapped,visible)

% trivial pass
quantized_trivial = quantize(strata_trapped,QuantizeOptions());
err_trivial = compare_tables(quantized_trivial.tables,strata_trapped.tables,...
    strata_trapped.saturation);
err_trivial = arrayfun(@(err) err.delta_mse, err_trivial,"UniformOutput",true);
assert(norm(err_trivial) <= eps);

% de-duplication
options(1) = QuantizeOptions();
options(1).duplicate_threshold = 1e-3;

options(2) = QuantizeOptions();
options(2).fit_parametric = true;

options(3) = QuantizeOptions();
options(3).fit_total_mobility = true;

options(4) = QuantizeOptions();
options(4).num_principal_components = 3;

options(5) = QuantizeOptions();
options(5).num_quants = 3;

options(6) = QuantizeOptions();
options(6).fit_total_mobility = true;
options(6).num_principal_components = 3;
options(6).num_quants = 3;

options(7) = QuantizeOptions();
options(7).fit_parametric = true;
options(7).num_principal_components = 3;
options(7).num_quants = 3;

for i=1:numel(options)
    quantized(i) = quantize(strata_trapped,options(i));

    compare_tables(strata_trapped.tables,quantized(i).tables,strata_trapped.saturation);

    plot_result(quantized(i),mod(i,2)+1,"visible",visible);
end

end

%% helpers

function [grid, rock] = grid_demo(downscale_params)
grid.cartDims = [5, 3, 2];
grid.cells.num = prod(grid.cartDims);
grid.cells.indexMap = 1:grid.cells.num;

grid.DX = 400 * meter() * ones(grid.cells.num,1);
grid.DY = grid.DX;
grid.DZ = 0.1 * meter() * ones(grid.cells.num,1);

poro_perm = downscale_params.poro_perm_gen(grid.cells.num);
rock.poro = poro_perm(1,:)';
rock.poro = max(rock.poro,0);

perm_x = poro_perm(2,:)';
perm_y = perm_x;
perm_z = perm_x*0.5;
rock.perm = [perm_x,perm_y,perm_z];
end

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
    TableFunction(krw_data), TableFunction(krg_data),...
    CapPressure(contact_angle,surface_tension,TableFunction(leverett_j_data),[1,1,0]),...
    800, 1000 ...
    );
end

function params = gen_params_2()
krw_data=[
    8.000000e-02	0.000000e+00
    1.035897e-01	2.665023e-04
    1.271795e-01	8.840336e-04
    1.507692e-01	1.912290e-03
    1.743590e-01	3.480852e-03
    1.979487e-01	5.775429e-03
    2.215385e-01	9.051335e-03
    2.451282e-01	1.365508e-02
    2.687179e-01	2.005328e-02
    2.923077e-01	2.886903e-02
    3.158974e-01	4.092447e-02
    3.394872e-01	5.728482e-02
    3.630769e-01	7.929201e-02
    3.866667e-01	1.085634e-01
    4.102564e-01	1.469140e-01
    4.338462e-01	1.961407e-01
    4.574359e-01	2.576103e-01
    4.810256e-01	3.316395e-01
    5.046154e-01	4.168006e-01
    5.282051e-01	5.094790e-01
    5.517949e-01	6.041101e-01
    5.753846e-01	6.942807e-01
    5.989744e-01	7.743326e-01
    6.225641e-01	8.406891e-01
    6.461538e-01	8.922983e-01
    6.697436e-01	9.301909e-01
    6.933333e-01	9.566074e-01
    7.169231e-01	9.741680e-01
    7.405128e-01	9.853216e-01
    7.641026e-01	9.920853e-01
    7.876923e-01	9.959866e-01
    8.112821e-01	9.981113e-01
    8.348718e-01	9.991909e-01
    8.584615e-01	9.996935e-01
    8.820513e-01	9.999018e-01
    9.056410e-01	9.999754e-01
    9.292308e-01	9.999958e-01
    9.528205e-01	9.999996e-01
    9.764103e-01	1.000000e+00
    1.000000e+00	1.000000e+00
    ];
krg_data = [
    0.000000e+00	0.000000e+00
    2.358974e-02	4.982161e-07
    4.717949e-02	6.528591e-06
    7.076923e-02	2.978753e-05
    9.435897e-02	8.828152e-05
    1.179487e-01	2.066333e-04
    1.415385e-01	4.167120e-04
    1.651282e-01	7.584884e-04
    1.887179e-01	1.281095e-03
    2.123077e-01	2.044096e-03
    2.358974e-01	3.118973e-03
    2.594872e-01	4.590845e-03
    2.830769e-01	6.560429e-03
    3.066667e-01	9.146245e-03
    3.302564e-01	1.248706e-02
    3.538462e-01	1.674454e-02
    3.774359e-01	2.210604e-02
    4.010256e-01	2.878745e-02
    4.246154e-01	3.703593e-02
    4.482051e-01	4.713221e-02
    4.717949e-01	5.939219e-02
    4.953846e-01	7.416729e-02
    5.189744e-01	9.184279e-02
    5.425641e-01	1.128334e-01
    5.661538e-01	1.375749e-01
    5.897436e-01	1.665108e-01
    6.133333e-01	2.000722e-01
    6.369231e-01	2.386510e-01
    6.605128e-01	2.825642e-01
    6.841026e-01	3.320108e-01
    7.076923e-01	3.870231e-01
    7.312821e-01	4.474150e-01
    7.548718e-01	5.127338e-01
    7.784615e-01	5.822222e-01
    8.020513e-01	6.547972e-01
    8.256410e-01	7.290492e-01
    8.492308e-01	8.032551e-01
    8.728205e-01	8.753677e-01
    8.964103e-01	9.428204e-01
    9.200000e-01	1.000000e+00
    ];

    function sw_norm = calc_sw_norm(sw,sw_irr)
        sw_norm = (sw - sw_irr)./(1-sw_irr);
    end

interfacial_tension = 36 * milli * newton / meter;
pe = 270 * kilo * pascal;
contact_angle = deg2rad(37);
ref_poro = 0.21;
ref_perm = 0.003 * darcy;
j_min = pe / cos(contact_angle) / interfacial_tension * sqrt(ref_perm/ref_poro);

sw_pc = unique(1-krg_data(:,1));
sw_pc(1) = sw_pc(1) +(sw_pc(2) - sw_pc(1))*0.01;

pc_mult = 1;
pc_shape = -1;

jlev = j_min * calc_sw_norm(sw_pc,krw_data(1,1)).^pc_shape * pc_mult;

params = Params(...
    TableFunction(krw_data),...
    TableFunction(krg_data),...
    CapPressure(contact_angle,interfacial_tension,TableFunction([sw_pc,jlev]), [1 1 0]),NaN,1000);
end

function [params] = gen_downscale_params()
params.subscale = 50 * meter();

params.corr_lens = [50,50,0].*meter();

poro_gen = @(num_samples) randn(1,num_samples)*0.01 + 0.2;
perm_gen = @(num_samples) exp(randn(1,num_samples) + log(100)) * milli * darcy;

params.poro_perm_gen = @(num_samples) [poro_gen(num_samples); perm_gen(num_samples)];
end
