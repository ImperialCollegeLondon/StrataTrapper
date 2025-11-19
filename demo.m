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

mask = true(ceil(grid.cells.num* 1e-3),1); % process only a fraction of cells

sub_rock = downscale_all(grid,rock,mask,downscale_params);

options = Options().save_mip_step(true);

strata_trapped = strata_trapper(grid, sub_rock, params, ...
    mask=mask, options=options, ...
    enable_waitbar=args.show_progress,...
    parfor_arg=args.parfor_arg...
    );

%% Visualize saturation functions

plot_result(strata_trapped,visible=visible);

%% OGS inputs generation

ogs_export(strata_trapped);

% export_fut = parfeval(backgroundPool,@ogs_export,0,strata_trapped); % or run in background

%% OPM Flow inputs generation

opm_export(strata_trapped);

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
grid.cartDims = [80, 120, 35];
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
