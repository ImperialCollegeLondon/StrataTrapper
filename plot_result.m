function plot_result(rock, mask, strata_trapped, params, kr_scale)
arguments
    rock
    mask
    strata_trapped
    params
    kr_scale = "log"
end

leverett_j_upscaled = params.cap_pressure.inv_lj(strata_trapped.capillary_pressure(mask,:),rock.poro(mask),strata_trapped.permeability(mask,:));

[~, ax_pc] =  stat_plot(axes(figure),'Leverett J-function','',strata_trapped.saturation,...
    @(sw)params.cap_pressure.leverett_j.func(sw), leverett_j_upscaled,true);

ax_pc.YScale='log';
% ylim(ax_pc,y_lim_pc);

xlabel(ax_pc,'Wetting phase saturation');
ylabel(ax_pc,'[-]');

curves_plot(mask, strata_trapped, params, kr_scale);

end


function curves_plot(mask, strata_trapped, params,scale)
arguments
    mask
    strata_trapped
    params
    scale = "log"
end
sub_data = @(data,mask,direction) squeeze(data(mask,direction,:));

tiles_krw = tiledlayout(figure(),3,2,TileSpacing='tight',Padding='tight');

stat_plot(nexttile(tiles_krw),'Water, along X-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,1));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along X-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,1));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Y-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,2));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Y-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,2));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Z-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,3),true);
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Z-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,3));
yscale(scale);

xlabel(tiles_krw,'Wetting phase saturation');
ylabel(tiles_krw,'Relative permeability');
end


function [y_lim, ax] = stat_plot(ax, name, y_label, x_data, base_func, data,show_legend,color)
arguments
    ax
    name char
    y_label char
    x_data (1,:) double
    base_func
    data   (:,:) double
    show_legend (1,1) logical = false
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

if show_legend
    legends = {'Median','Quantiles 0.01 and 0.99',''};
    if ~isempty(base_func)
        legends{end+1} = 'Intrinsic curve';
    end

    legend(ax,legends,'Location','best','BackgroundAlpha',0.5);
end

try
    [yu,yl,ym] = ax.Children(:).YData;
    ydata = [yu,yl,ym];
    y_lim = [min(ydata),max(ydata)];
catch err
    y_lim = [nan,nan];
end
end
