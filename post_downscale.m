%   generateCoarseGrid           - Form coarse grid from partition of fine-scale grid.
%   partitionCartGrid

[strata_trapped, sub_rock] = demo(parfor_arg=6,show_figures=false,show_progress=false);

% save sub-sw for every sw from percolation step
% take Sw from solution
% interpolate between table MIP Sw and get solution sub-sw

% Do uniform grids first
% after that, do refineGrdecl on East Mey and try to do something there

%%
run('../MRST/startup.m');
mrstModule add deckformat mrst-gui coarsegrid;
%%
cartDims = [10, 10, 10];
num_sub = [5,5,5];
DR = [100,100,100];
grid = cartGrid(cartDims.*num_sub,cartDims.*DR);
grid = computeGeometry(grid);

partition = partitionCartGrid(grid.cartDims,cartDims);
pf = cellPartitionToFacePartition(grid, partition);

grid = generateCoarseGrid(grid,partition,pf);

grid.DX = DR(1).*ones(grid.cells.num,1);
grid.DY = DR(2).*ones(grid.cells.num,1);
grid.DZ = DR(3).*ones(grid.cells.num,1);

%%
poro = zeros(grid.parent.cells.num,1);
perm = zeros(grid.parent.cells.num,3);
coarse_idx = 1:prod(cartDims);
sub_rock(coarse_idx) = struct('poro',zeros(num_sub),'perm',zeros([num_sub,3]));
for idx=coarse_idx
    sub_poro = rand(num_sub)*0.1 + 0.2;
    sub_rock(idx).poro = sub_poro;
    sub_perm = 10.^(rand(num_sub)*log10(100) + log10(200))*milli*darcy;
    sub_rock(idx).perm(:,:,:,1) = sub_perm;
    sub_rock(idx).perm(:,:,:,2) = sub_perm;
    sub_rock(idx).perm(:,:,:,3) = sub_perm;
    poro(partition == idx) = sub_poro(:);
    perm(partition == idx,1) = sub_perm(:);
    perm(partition == idx,2) = sub_perm(:);
    perm(partition == idx,3) = sub_perm(:);
end
%%

params  = gen_params ();
options = Options().save_mip_step(true);

strata_trapped = strata_trapper(grid, sub_rock, params, ...
    options=options, ...
    enable_waitbar=true...
    );

%%
plot_result(strata_trapped);
%%
sw = rand(cartDims)*(1-params.sw_resid)+params.sw_resid;

sw_fine = zeros(cartDims.*num_sub);
for idx=coarse_idx
    mip = strata_trapped.mip(idx,:);
    sw_idx = round(interp1([mip.sw],1:numel([mip.sw]),sw(idx)));
    sub_sw = mip(sw_idx).sub_sw;
    sw_fine(partition == idx) = sub_sw(:);
end
