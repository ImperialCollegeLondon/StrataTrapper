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


function curves_plot(mask, strata_trapped, params,scale)
arguments
    mask 
    strata_trapped 
    params 
    scale = "log"
end
sub_data = @(data,mask,direction) squeeze(data(mask,direction,:));

tiles_krw = tiledlayout(figure(),3,2,TileSpacing='compact',Padding='tight');

stat_plot(nexttile(tiles_krw),'Water, along X-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,1));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along X-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,1));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Y-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,2));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Y-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,2));
yscale(scale);

stat_plot(nexttile(tiles_krw),'Water, along Z-axis','',strata_trapped.saturation,@(sw)params.krw.func(sw),sub_data(strata_trapped.rel_perm_wat,mask,3));
yscale(scale);
stat_plot(nexttile(tiles_krw),'Gas, along Z-axis','',strata_trapped.saturation,@(sw) params.krg.func(1-sw),sub_data(strata_trapped.rel_perm_gas,mask,3));
yscale(scale);

xlabel(tiles_krw,'Wetting phase saturation');
ylabel(tiles_krw,'Relative permeability');
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

