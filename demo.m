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

mask = true(ceil(grid.cells.num* 0.001),1); % process only a fraction of cells

sub_rock = downscale_all(grid,rock,mask,downscale_params);

strata_trapped = strata_trapper(grid, sub_rock, params, ...
    mask=mask, options=Options(), ...
    enable_waitbar=args.show_progress,...
    parfor_arg=args.parfor_arg ...
    );

%% Visualize saturation functions

plot_result(strata_trapped,visible=visible);

%% OGS inputs generation

ogs_export(strata_trapped);

% export_fut = parfeval(backgroundPool,@ogs_export,0,strata_trapped); % or run in background
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
