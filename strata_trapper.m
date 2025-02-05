function strata_trapped = strata_trapper(grid, sub_rock, params, args)
arguments
    grid            (1,1) struct
    sub_rock        (1,:) struct
    params          (1,1) Params
    args.options         (1,1) Options = Options();
    args.enable_waitbar  (1,1) logical = false;
    args.num_par_workers (1,1) uint32  = Inf;
    args.mask            (:,1) logical = true(grid.cells.num,1);
end

cells_num = min(length(args.mask),grid.cells.num);
cell_idxs = 1:cells_num;
mask = args.mask(cell_idxs);
subset_len = sum(mask);

perm_upscaled = zeros(subset_len, 3);
poro_upscaled = zeros(subset_len,1);

saturations = linspace(params.sw_resid,1,args.options.sat_num_points);

cap_pres_upscaled = nan(subset_len,length(saturations));
krw = nan(subset_len,3,length(saturations));
krg = nan(subset_len,3,length(saturations));

wb_queue = parallel.pool.DataQueue;
if args.enable_waitbar
    parforWaitbar(0,sum(mask));
    afterEach(wb_queue,@parforWaitbar);
end

DR = [grid.DX(mask),grid.DY(mask),grid.DZ(mask)];

sub_rock = sub_rock(mask);

% for cell_index = 1:subset_len
parfor (cell_index = 1:subset_len,  args.num_par_workers)
    sub_porosity = sub_rock(cell_index).poro;
    sub_permeability = sub_rock(cell_index).perm;

    [perm_upscaled_cell, pc_upscaled, krw_cell, krg_cell] = upscale(...
        DR(cell_index,:), saturations, params, args.options, sub_porosity, sub_permeability);

    perm_upscaled(cell_index,:) = perm_upscaled_cell;
    poro_upscaled(cell_index) = sum(sub_porosity,'all')./numel(sub_porosity);
    cap_pres_upscaled(cell_index,:) = pc_upscaled;

    krw(cell_index,:,:) = krw_cell;
    krg(cell_index,:,:) = krg_cell;

    if args.enable_waitbar
        send(wb_queue,cell_index);
    end
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

if args.enable_waitbar
    parforWaitbar(0,0,'ready');
end

end

function parforWaitbar(~,max_iterations,~)
persistent state wb final_state start_time last_reported_state last_reported_time

if nargin == 2
    state = 0;
    final_state = max_iterations;
    wb = waitbar(state,sprintf('%u cells to upscale', final_state),'Name','StrataTrapper');
    start_time = tic();

    last_reported_state = state;
    last_reported_time = 0;
    return;
end

if ~isvalid(wb)
    return;
end

if nargin == 3
    elapsed = duration(seconds(toc(start_time)),'Format','hh:mm:ss');
    message = sprintf('%u cells upscaled\n in %s',final_state,elapsed);
    waitbar(1,wb,message);
    return;
end

state = state + 1;
elapsed = toc(start_time);

time_to_report = (elapsed - last_reported_time) > 1;
state_to_report = (state - last_reported_state) > final_state * 0.01;

if ~(time_to_report || state_to_report)
    return;
end

last_reported_state = state;
last_reported_time = elapsed;

pace_integral = elapsed/state;
eta_estimate = (final_state - state) * pace_integral;
eta = duration(seconds(eta_estimate),'Format','hh:mm:ss');
elapsed_str = duration(seconds(elapsed),'Format','hh:mm:ss');
message = sprintf('%u/%u cells upscaled\n passed: %s | ETA: %s',state,final_state,elapsed_str,eta);
waitbar(state/final_state,wb,message);
end
