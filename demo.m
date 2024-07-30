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

function curves_plot(mask, strata_trapped, params,scale)
arguments
    mask 
    strata_trapped 
    params 
    scale = "log"
end
sub_data = @(data,mask,direction) squeeze(data(mask,direction,:));

tiles_krw = tiledlayout(figure(),3,2,TileSpacing='compact',Padding='tight');

stat_plot(nexttile(tiles_krw),'Water, along X-axis','',strata_trapped.saturation,params.rel_perm.calc_krw,sub_data(strata_trapped.rel_perm_wat,mask,1));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along X-axis','',strata_trapped.saturation,@(sw) params.rel_perm.calc_krg(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,1));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Y-axis','',strata_trapped.saturation,params.rel_perm.calc_krw,sub_data(strata_trapped.rel_perm_wat,mask,2));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Y-axis','',strata_trapped.saturation,@(sw) params.rel_perm.calc_krg(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,2));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Z-axis','',strata_trapped.saturation,params.rel_perm.calc_krw,sub_data(strata_trapped.rel_perm_wat,mask,3));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Z-axis','',strata_trapped.saturation,@(sw) params.rel_perm.calc_krg(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,3));
yscale(scale);

xlabel(tiles_krw,'Wetting phase saturation');
ylabel(tiles_krw,'Relative permeability');
end

function plot_result(rock, mask, strata_trapped, params, kr_scale)
arguments
    rock 
    mask 
    strata_trapped 
    params 
    kr_scale = "log"
end

curves_plot(mask, strata_trapped, params, kr_scale);


base_cap = strata_trapped;
base_cap.permeability = rock.perm;
for i = 1:length(base_cap.saturation)
    base_cap.capillary_pressure(mask,i) = params.capil.pres_func(base_cap.saturation(i),rock.poro(mask),geomean(rock.perm(mask,:),2));
end

tiles_pc = tiledlayout(figure(),'flow',TileSpacing='compact',Padding='tight');

pc_base = nexttile(tiles_pc);
y_lim_base = stat_plot(pc_base,'Base','',base_cap.saturation,[],base_cap.capillary_pressure(mask,:)./barsa());
pc_base.YScale='log';

[y_lim_strat, pc_strat] = stat_plot(nexttile(tiles_pc),'StrataTrapped','',strata_trapped.saturation,[],strata_trapped.capillary_pressure(mask,:)./barsa());
pc_strat.YScale='log';

y_lim_concat = [y_lim_base;y_lim_strat];
y_lim_both = [min(y_lim_concat(:,1)),max(y_lim_concat(:,2))];

ylim(pc_base,y_lim_both);
ylim(pc_strat,y_lim_both);

xlabel(tiles_pc,'Wetting phase saturation');
ylabel(tiles_pc,'Capillary pressure, bar');

end

function [y_lim, ax] = stat_plot(ax, name, y_label, x_data, base_func, data,color)
arguments
    ax
    name char
    y_label char
    x_data (1,:) double
    base_func
    data   (:,:) double
    color = 'blue'
end

parallelcoords(ax,data,'Quantile',0.01,'XData',x_data,'Color',color);

if ~isempty(base_func)
    hold(ax,'on');
    plot(x_data,base_func(x_data),'-r');
    hold(ax,'off');
end

title(ax,name);
xlabel(ax,'');
ax.XTickMode='auto';
ax.XTickLabelMode='auto';
ax.XLimitMethod="tickaligned";

ylabel(ax,y_label);
ax.YLimitMethod="tight";

legends = {'Median','Quantiles 0.01 and 0.99',''};
if ~isempty(base_func)
    legends{end+1} = 'Intrinsic curve';
end

legend(ax,legends,'Location','best');

try
    [yu,yl,ym] = ax.Children(:).YData;
    ydata = [yu,yl,ym];
    y_lim = [min(ydata),max(ydata)];
catch err
    y_lim = [nan,nan];
end
end
