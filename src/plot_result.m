function fig = plot_result(strata_trapped, args)
arguments
    strata_trapped
    args.font_size = 9
    args.kr_scale = "log"
    args.parent = struct([]);
    args.visible char = 'on';
end

if isempty(args.parent)
    fig = figure('Visible',args.visible);
else
    fig = args.parent;
    clf(fig);
end

[t_all,t_pc,t_kr,t_krw,t_krg,ax_pc,ax_krw_x,ax_krw_y,ax_krw_z,ax_krg_x,ax_krg_y,ax_krg_z] ...
    = nested_tiles(fig);

leverett_j_upscaled = strata_trapped.params.cap_pressure.inv_lj(...
    strata_trapped.capillary_pressure,...
    strata_trapped.porosity,...
    strata_trapped.permeability);

[~, ax_pc] =  stat_plot(ax_pc,strata_trapped.saturation,...
    @(sw)strata_trapped.params.cap_pressure.leverett_j.func(sw), leverett_j_upscaled,args.font_size,true);
title(ax_pc,'Leverett J-function',FontSize=args.font_size,FontWeight='normal');
% ylabel(ax_pc,'[-]');
ax_pc.YScale='log';
curves_plot([ax_krw_x,ax_krw_y,ax_krw_z;ax_krg_x,ax_krg_y,ax_krg_z], ...
    strata_trapped, strata_trapped.params, args.kr_scale);

xlabel(t_all,'Water saturation',FontSize=args.font_size);
title(t_kr,'Relative permeability',FontSize=args.font_size);
title(t_krw,'Water',FontSize=args.font_size);
title(t_krg,'Gas',FontSize=args.font_size);

subtitle(ax_krw_x,'x','Interpreter','latex','FontSize',args.font_size);
subtitle(ax_krw_y,'y','Interpreter','latex','FontSize',args.font_size);
subtitle(ax_krw_z,'z','Interpreter','latex','FontSize',args.font_size);
subtitle(ax_krg_x,'x','Interpreter','latex','FontSize',args.font_size);
subtitle(ax_krg_y,'y','Interpreter','latex','FontSize',args.font_size);
subtitle(ax_krg_z,'z','Interpreter','latex','FontSize',args.font_size);
end


function curves_plot(ax_kr, strata_trapped, params,font_size,scale)
arguments
    ax_kr
    strata_trapped
    params
    font_size
    scale = "log"
end
sub_data = @(data,direction) squeeze(data(:,direction,:));

stat_plot(ax_kr(1,1),strata_trapped.saturation,...
    @(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,1),font_size);
ax_kr(1,1).YScale = scale;
stat_plot(ax_kr(2,1),strata_trapped.saturation,...
    @(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,1),font_size);
ax_kr(2,1).YScale = scale;

stat_plot(ax_kr(1,2),strata_trapped.saturation,...
    @(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,2),font_size);
ax_kr(1,2).YScale = scale;
stat_plot(ax_kr(2,2),strata_trapped.saturation,...
    @(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,2),font_size);
ax_kr(2,2).YScale = scale;

stat_plot(ax_kr(1,3),strata_trapped.saturation,...
    @(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,3),font_size);
ax_kr(1,3).YScale = scale;
stat_plot(ax_kr(2,3),strata_trapped.saturation, ...
    @(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,3),font_size);
ax_kr(2,3).YScale = scale;
end


function [y_lim, ax] = stat_plot(ax, x_data, base_func, data,font_size,show_legend,color)
arguments
    ax
    x_data (1,:) double
    base_func
    data   (:,:) double
    font_size 
    show_legend (1,1) logical = false
    color = 'blue'
end


plot_handle = parallelcoords(ax,data,'Quantile',0.01,'XData',x_data,'Color',color);

plot_handle(1).LineStyle = '-.';
plot_handle(2).LineStyle =':';
plot_handle(2).LineStyle =':';

if ~isempty(base_func)
    hold(ax,'on');
    plot(ax,x_data,base_func(x_data),'-r');
    hold(ax,'off');
end

ylabel(ax,'');
xlabel(ax,'');
ax.XTickMode='auto';
ax.XTickLabelMode='auto';
ax.XLimitMethod="tickaligned";

ax.YLimitMethod="tight";

if show_legend
    legend_base = {};
    if ~isempty(base_func)
        legend_base{1} = 'Fine-scale curve';
    end

    legends = {'Median','Quantiles 0.01 and 0.99','',legend_base{:}};
    
    legend(ax,legends,'Location','northoutside','FontSize',font_size);
end

try
    [yu,yl,ym] = ax.Children(:).YData;
    ydata = [yu,yl,ym];
    y_lim = [min(ydata),max(ydata)];
catch
    y_lim = [nan,nan];
end
end

function [t_all,t_pc,t_kr,t_krw,t_krg,ax_pc,ax_krw_x,ax_krw_y,ax_krw_z,ax_krg_x,ax_krg_y,ax_krg_z] ...
    = nested_tiles(fig)
params = {'TileSpacing','tight','Padding','tight'};
t_all = tiledlayout(fig,1,3,params{:});


t_pc = tiledlayout(t_all,1,1,params{:});
t_pc.Layout.Tile = 1;
ax_pc = nexttile(t_pc);

t_kr = tiledlayout(t_all,1,2,params{:});
t_kr.Layout.Tile = 2;
t_kr.Layout.TileSpan = [1,2];


t_krw = tiledlayout(t_kr,3,1,params{:});
t_krw.Layout.Tile = 1;

ax_krw_x = nexttile(t_krw,1);
ax_krw_y = nexttile(t_krw,2);
ax_krw_z = nexttile(t_krw,3);


t_krg = tiledlayout(t_kr,3,1,params{:});
t_krg.Layout.Tile = 2;

ax_krg_x = nexttile(t_krg,1);
ax_krg_y = nexttile(t_krg,2);
ax_krg_z = nexttile(t_krg,3);
end
