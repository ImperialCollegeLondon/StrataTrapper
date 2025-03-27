function strata_trapped = strata_trapper(grid, sub_rock, params, args)
arguments
    grid            (1,1) struct
    sub_rock        (1,:) struct
    params          (1,1) Params
    args.options         (1,1) Options = Options();
    args.enable_waitbar  (1,1) logical = false;
    args.mask            (:,1) {mustBeOfClass(args.mask,"logical")} = true(grid.cells.num,1);
    args.parfor_arg = parforOptions(gcp('nocreate'),...
                            "RangePartitionMethod","fixed",...
                            "SubrangeSize",1,...
                            'MaxNumWorkers',Inf);
end

cells_num = min(length(args.mask),grid.cells.num);
cell_idxs = 1:cells_num;
mask = args.mask(cell_idxs);
subset_len = sum(mask);

[par_wb, update_queue, par_for_stop] = ParWaitBar(sum(mask) * args.enable_waitbar);

perm_upscaled = zeros(subset_len, 3);
poro_upscaled = zeros(subset_len,1);

saturations = linspace(params.sw_resid,1,args.options.sat_num_points);

cap_pres_upscaled = nan(subset_len,length(saturations));
krw = nan(subset_len,3,length(saturations));
krg = nan(subset_len,3,length(saturations));

DR = [grid.DX(mask),grid.DY(mask),grid.DZ(mask)];

sub_rock = sub_rock(mask);
options = args.options;
num_sub = zeros(subset_len,1);
elapsed = zeros(subset_len,1);

parfor (cell_index = 1:subset_len, args.parfor_arg)
    
    if par_for_stop.value
        continue;
    end
    
    sub_porosity = sub_rock(cell_index).poro;
    sub_permeability = sub_rock(cell_index).perm;

    timer_start = tic;

    [perm_upscaled_cell, pc_upscaled, krw_cell, krg_cell] = upscale(...
        DR(cell_index,:), saturations, params, options, sub_porosity, sub_permeability);

    for i = 1:3
        krg_cell(i,:) = monotonize(saturations, krg_cell(i,:), -1);
    end

    krw(cell_index,:,:) = krw_cell; %#ok<PFOUS>
    krg(cell_index,:,:) = krg_cell;

    timer_stop = toc(timer_start);
    elapsed(cell_index) = timer_stop;

    perm_upscaled(cell_index,:) = perm_upscaled_cell;
    poro_upscaled(cell_index) = sum(sub_porosity,'all')./numel(sub_porosity);
    cap_pres_upscaled(cell_index,:) = pc_upscaled;

    num_sub(cell_index) = numel(sub_porosity);

    send(update_queue,[]);
end

krw(:,:,saturations<=params.sw_resid) = 0;
krg(krg<0) = 0;
krg(:,:,saturations>=1)=0;

strata_trapped = struct(...
    'permeability', perm_upscaled, ...
    'saturation', saturations,...
    'capillary_pressure', cap_pres_upscaled, ...
    'rel_perm_wat', krw, ...
    'rel_perm_gas', krg, ...
    'idx', cell_idxs(mask), ...
    'porosity',poro_upscaled, ...
    'params', params, ...
    'options', args.options, ...
    'grid', grid ...
    );

perf.num_coarse = subset_len;

if canUseParallelPool && ~isempty(gcp('nocreate'))
    num_pool_workers = gcp('nocreate').NumWorkers;
    if isnumeric(args.parfor_arg)
        max_num_workers = args.parfor_arg;
    else
        max_num_workers = args.parfor_arg.MaxNumWorkers;
    end
    perf.num_workers = max(min(num_pool_workers,max_num_workers),1);
else
    perf.num_workers = 1;
end

perf.num_sub = num_sub;
perf.elapsed = elapsed;
perf.num_sat = args.options.sat_num_points;

strata_trapped.perf = compute_performance(perf,1);

par_wb.finish();
end
