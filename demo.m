%% StrataTrapper demonstration

ppool = parpool; % start default parpool (optional)

%% Input params

params = gen_params();
options = gen_options();

%% Subscaling demo

subscale_demo(params, options);

%% Grid geometry

grid = grid_demo();
is_permeable = rand(grid.cells.num,1) > 0.1;
mask = is_permeable(1:1000); % process only a subset of cells

%% Run StrataTrapper

enable_waitbar = true;

strata_trapped = strata_trapper(grid, mask, params, options, enable_waitbar);

%% Visualize saturation functions

curves_plot(mask, strata_trapped, params);

%% OGS inputs generation

export_fut = parfeval(backgroundPool,@()ogs_export(grid,mask,strata_trapped,'model/'), 0); % async call to function

ogs_export_base(grid, strata_trapped, params); % base model parameters

%% helpers

function subscale_demo(params, options)

options.subscale = 20 * meter();

[~, sub_porosity, sub_permeability, sub_entry_pressures, ~] = downscale(...
    [400,400,0.1].*meter(),...
    params, options ...
    );

fig = figure('WindowStyle','docked','Name','Sub-scaling demonstration');
tiles = tiledlayout(fig,'flow',TileSpacing='compact',Padding='tight');

    function slice_plot(ax,data,title_str,units_str)
        imagesc(ax,data',...
            'YData',linspace(0,400,size(data,2)), ...
            'XData',linspace(0,400,size(data,1))...
            );

        axis(ax,'equal');
        xlabel(ax,'x, m');
        ylabel(ax,'y, m');

        ax.XLimitMethod="tight";
        ax.YLimitMethod="tight";

        title(ax,title_str);
        cb = colorbar(ax,"eastoutside");
        ylabel(cb,units_str);
    end

slice_plot(nexttile(tiles),squeeze(sub_porosity(2,:,:)),'Porosity','');

slice_plot(nexttile(tiles),squeeze(sub_entry_pressures(2,:,:)./kilo()),'Entry pressure','kPa');

slice_plot(nexttile(tiles),squeeze(sub_permeability(2,:,:)./(milli()*darcy())),'Permeability','mD');

end

function [grid] = grid_demo()
grid.cartDims = [82, 123, 36];
grid.cells.num = prod(grid.cartDims);
grid.cells.indexMap = 1:grid.cells.num;
grid.DX = 400 * meter() * ones(grid.cells.num,1);
grid.DY = grid.DX;
grid.DZ = 0.1 * meter() * ones(grid.cells.num,1);
end

function curves_plot(mask, strata_trapped, params)
sub_data = @(data,mask,direction) squeeze(data(mask,direction,:));

fig_krw = figure('WindowStyle','docked','Name','krw');
tiles_krw = tiledlayout(fig_krw,'flow',TileSpacing='compact',Padding='tight');

stat_plot(nexttile(tiles_krw),'Water relative permeability along X-axis','',strata_trapped.saturation,params.rel_perm.wat_func,sub_data(strata_trapped.rel_perm_wat,mask,1));
stat_plot(nexttile(tiles_krw),'Water relative permeability along Y-axis','',strata_trapped.saturation,params.rel_perm.wat_func,sub_data(strata_trapped.rel_perm_wat,mask,2));
stat_plot(nexttile(tiles_krw),'Water relative permeability along Z-axis','',strata_trapped.saturation,params.rel_perm.wat_func,sub_data(strata_trapped.rel_perm_wat,mask,3));

fig_krg = figure('WindowStyle','docked','Name','krg');
tiles_krg = tiledlayout(fig_krg,'flow',TileSpacing='compact',Padding='tight');

stat_plot(nexttile(tiles_krg),'Gas relative permeability along X-axis','',strata_trapped.saturation,@(sw) params.rel_perm.gas_func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,1));
stat_plot(nexttile(tiles_krg),'Gas relative permeability along Y-axis','',strata_trapped.saturation,@(sw) params.rel_perm.gas_func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,2));
stat_plot(nexttile(tiles_krg),'Gas relative permeability along Z-axis','',strata_trapped.saturation,@(sw) params.rel_perm.gas_func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,3));

fig_pc = figure('WindowStyle','docked','Name','pc');
stat_plot(axes(fig_pc),'Capillary pressure','bar',strata_trapped.saturation,@(sw) params.capil.pres_func(sw,params.capil.pres_entry)./barsa(),strata_trapped.capillary_pressure(mask,:)./barsa());

end

function ax = stat_plot(ax, name, y_label, x_data, base_func, data)
arguments
    ax
    name char
    y_label char
    x_data (1,:) double
    base_func
    data   (:,:) double
end

parallelcoords(ax,data,'Quantile',0.01,'XData',x_data);

if ~isempty(base_func)
    hold(ax,'on');
    plot(x_data,base_func(x_data),'-r');
    hold(ax,'off');
end

title(ax,name);

xlabel(ax,'Wetting phase saturation');
xlim(ax,[0,1]);
ax.XTickMode='auto';
ax.XTickLabelMode='auto';
ax.XLimitMethod="tickaligned";

% ylim(ax,[0,max(data,[],'all')]);
ylabel(ax,y_label);
ax.YLimitMethod="tight";

legend(ax,{'Median','Quantiles 0.01 and 0.99','','Intrinsic curve'},'Location','best');
end

function ogs_export_base(G, strata_trapped, params)
perm_base = params.perm_corr(strata_trapped.porosity)./milli()./darcy();
perm_base(strata_trapped.porosity == 0) = 0;

perm_base_mapping = zeros(G.cells.num,1);
perm_base_mapping(G.cells.indexMap) = perm_base;

write_curve_nums("model/base-PERMX.grdecl","PERMX",perm_base_mapping,0,0);
write_curve_nums("model/base-PERMY.grdecl","PERMY",perm_base_mapping,0,0);
write_curve_nums("model/base-PERMZ.grdecl","PERMZ",perm_base_mapping,0,0);

swfn_base = [strata_trapped.saturation; ...
    params.rel_perm.wat_func(strata_trapped.saturation); ...
    params.capil.pres_func(strata_trapped.saturation,params.capil.pres_entry)./barsa()];

sg = unique([1-strata_trapped.saturation,1]);

sgfn_base = [sg; params.rel_perm.gas_func(sg); zeros(size(sg))];

format_spec ='%f\t%f\t%f\n';
swfn_base_str = sprintf(format_spec,swfn_base)
sgfn_base_str = sprintf(format_spec,sgfn_base)
end
