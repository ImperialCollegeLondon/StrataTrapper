function strata_trapped = strata_trapper(G, mask, params, options, enable_waitbar)
arguments
    G              (1,1) struct
    mask           (:,1) logical
    params         (1,1) struct
    options        (1,1) struct
    enable_waitbar (1,1) logical = false;
end

perm_upscaled = zeros(G.cells.num, 3);
poro_upscaled = zeros(G.cells.num, 1);

saturations = linspace(params.rel_perm.sw_resid,1,options.sat_num_points);

cap_pres_upscaled = zeros(G.cells.num,length(saturations));
krw = zeros(G.cells.num,  3,length(saturations));
krg = zeros(G.cells.num,3,length(saturations));

cells_num = min(length(mask),G.cells.num);
mask = mask(1:cells_num);

wb_queue = parallel.pool.DataQueue;
if enable_waitbar
    parforWaitbar(0,sum(mask));
    afterEach(wb_queue,@parforWaitbar);
end

DR = [G.DX,G.DY,G.DZ];

parfor cell_index = 1:cells_num
    if ~mask(cell_index)
        continue;
    end

    [porosity, Kabs, sw_upscaled, pc_upscaled, krg_cell, krw_cell] = ...
        downscale_upscale(DR(cell_index,:), saturations , params, options);

    if porosity <= 0
        error('Resulted in non-positive upscaled porosity')
    end

    poro_upscaled(cell_index) = porosity;
    perm_upscaled(cell_index,:) = Kabs;
    cap_pres_upscaled(cell_index,:) = interp1(sw_upscaled,pc_upscaled,saturations,"linear","extrap");

    for i = 1:3
        krw_cell(i,:) = monotonize(sw_upscaled, krw_cell(i,:),  1);
        krg_cell(i,:) = monotonize(sw_upscaled, krg_cell(i,:), -1);
    end

    krw(cell_index,:,:) = interp1(sw_upscaled, krw_cell', saturations, "linear")';
    krg(cell_index,:,:) = interp1(sw_upscaled, krg_cell', saturations, "linear")';

    if enable_waitbar
        send(wb_queue,cell_index);
    end
end

krw(:,:,saturations<=params.rel_perm.sw_resid) = 0;

strata_trapped = struct(...
    'porosity', poro_upscaled, ...
    'permeability', perm_upscaled, ...
    'saturation', saturations,...
    'capillary_pressure', cap_pres_upscaled, ...
    'rel_perm_wat', krw, ...
    'rel_perm_gas', krg ...
    );

if enable_waitbar
    parforWaitbar(0,0,'ready');
end

end

function parforWaitbar(~,max_iterations,~)
persistent state wb final_state timer_val last_reported_state last_reported_time

if nargin == 2
    state = 0;
    final_state = max_iterations;
    wb = waitbar(state,sprintf('%u cells to upscale', final_state),'Name','StrataTrapper');
    timer_val = tic();

    last_reported_state = state;
    last_reported_time = timer_val;
    return;
end

if ~isvalid(wb)
    return;
end

if nargin == 3
    elapsed = duration(seconds(toc(timer_val)),'Format','hh:mm:ss');
    message = sprintf('%u cells upscaled\n in %s',final_state,elapsed);
    waitbar(1,wb,message);
    return;
end

state = state + 1;
elapsed = toc(timer_val);

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
