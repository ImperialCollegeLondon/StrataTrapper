%% StrataTrapper demonstration

parpool(); % start default parpool (optional)

%% Inputs

params  = gen_params (); % rock and fluid parameters
options = gen_options(); % StrataTrapper options

%% Downscaling demo

downscale_demo(params, options);

%% Grid & rock properties

[grid, rock] = grid_demo(params);

%% Run StrataTrapper

mask = rand(grid.cells.num,1) < 0.001; % process only a fraction of cells

enable_waitbar = true;
num_par_workers = Inf; % use all parallel workers from the pool

strata_trapped = strata_trapper(grid, rock, mask, params, options, enable_waitbar, num_par_workers);

%% Visualize saturation functions

plot_result(rock, mask, strata_trapped, params);

%% OGS inputs generation

% run in background
export_fut = parfeval(backgroundPool,@ogs_export,0,grid,mask,strata_trapped);

%% helpers

function downscale_demo(params, options)

[~, sub_porosity, sub_permeability, sub_entry_pressures] = downscale(...
    0.1, 100*milli*darcy,...
    [400,400,0.1].*meter(),...
    params, options ...
    );

fig = figure;
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

slice_plot(nexttile(tiles),squeeze(sub_entry_pressures(:,:,2)./barsa()),'Entry pressure','bar');

slice_plot(nexttile(tiles),squeeze(sub_permeability(:,:,2)./(milli()*darcy())),'Permeability','mD');
xlabel(tiles,'x, m');
ylabel(tiles,'y, m');
end

function [grid, rock] = grid_demo(params)
grid.cartDims = [80, 120, 35];
grid.cells.num = prod(grid.cartDims);
grid.cells.indexMap = 1:grid.cells.num;

grid.DX = 400 * meter() * ones(grid.cells.num,1);
grid.DY = grid.DX;
grid.DZ = 0.1 * meter() * ones(grid.cells.num,1);

poro_perm = params.poro_perm_gen(grid.cells.num);
rock.poro = poro_perm(1,:)';
rock.poro = max(rock.poro,0);

rock.perm = poro_perm(2,:)';
end

