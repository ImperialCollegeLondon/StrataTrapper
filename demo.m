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

%% Downscaling demo

downscale_demo(params, downscale_params,visible);

%% Grid & rock properties

[grid, rock] = grid_demo(downscale_params);

%% Run StrataTrapper

mask = uint8([0,1,2,1,0,1,2,1,0]); % process only a fraction of cells
params(2) = gen_params_2();
sub_rock = downscale_all(grid,rock,mask,downscale_params);

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

end

%% helpers

function fig = downscale_demo(params,downscale_params,visible)

[sub_porosity, sub_permeability] = downscale(...
    0.1, 100*milli*darcy * [1,1,0.5], [400,400,0.1].*meter(),downscale_params);

fig = figure('Visible',visible);
tiles = tiledlayout(fig,'flow',TileSpacing='tight',Padding='tight');

    function slice_plot(ax,data,title_str,units_str)
        imagesc(ax,data,...
            'YData',linspace(0,400,size(data,2)), ...
            'XData',linspace(0,400,size(data,1))...
            );

        axis(ax,'equal');

        ax.XLimitMethod="tight";
        ax.YLimitMethod="tight";

        title(ax,title_str);
        cb = colorbar(ax,"eastoutside");
        ylabel(cb,units_str);
    end

slice_plot(nexttile(tiles),squeeze(sub_porosity(:,:,2)),'Porosity','');

perm_to_plot = params.cap_pressure.transform_perm(sub_porosity,sub_permeability);

sub_entry_pressures = params.cap_pressure.func(1, sub_porosity, perm_to_plot);

slice_plot(nexttile(tiles),squeeze(sub_entry_pressures(:,:,2)./barsa()),'Entry pressure','bar');

slice_plot(nexttile(tiles),squeeze(perm_to_plot(:,:,2)./(milli()*darcy())),'Permeability','mD');
xlabel(tiles,'x, m');
ylabel(tiles,'y, m');
end

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

function [sub_rock] = downscale_all(grid,rock,mask,params)
arguments
    grid
    rock
    mask
    params
end

coarse_idx = 1:length(mask);
sub_rock(coarse_idx) = struct('poro',[],'perm',[]);

DR = [grid.DX,grid.DY,grid.DZ];
perm = rock.perm;
poro = rock.poro;

for cell_index = coarse_idx
    if ~mask(cell_index)
        continue;
    end

    [sub_rock(cell_index).poro, sub_rock(cell_index).perm] = downscale(...
        poro(cell_index), perm(cell_index,:), DR(cell_index,:), params);
end
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
