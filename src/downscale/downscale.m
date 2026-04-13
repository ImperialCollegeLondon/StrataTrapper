function [sub_rock] = downscale(grid,rock,corr_len_m,mask,args)
arguments
    grid (1,1) struct % MRST grid struct imported from ECLIPSE
    rock (1,1) struct % MRST rock struct imported from ECLIPSE
    corr_len_m (1,3) double % correlation lengths [cx,cy,cz] (meters)
    mask (:,1) logical = true(grid.cells.num,1);
    args.sub_dim_min (1,1) uint32 = 3
    args.sub_dim_max (1,1) uint32 = Inf
end

poro = rock.poro;
perm = rock.perm;
perm_x = perm(:,1);

stdev_poro = std(poro(mask),0,"all");
stdev_log_perm = std(log(perm_x(mask)),0,"all");

DR = [grid.DX,grid.DY,grid.DZ];

sub_dims = get_sub_dims(DR,corr_len_m,args.sub_dim_min,args.sub_dim_max);

coarse_idx = 1:grid.cells.num;
sub_rock(coarse_idx) = struct('poro',[],'perm',[]);

for i = coarse_idx
    % parfor i = coarse_idx
    if ~mask(i)
        continue;
    end
    dr = DR(i,:);
    sub_dims_i = sub_dims(i,:);
    poro_i = poro(i);
    perm_i = perm(i,:);

    [sub_poro,sub_perm] = downscale_cell(poro_i,perm_i,dr,sub_dims_i,corr_len_m,...
    stdev_poro,stdev_log_perm,max_rel_stdev_poro=0.3);

    sub_rock(i).poro = sub_poro;
    sub_rock(i).perm = sub_perm;
end
end

function sub_dims = get_sub_dims(DR,corr_len_m,sub_dim_min,sub_dim_max)
corr_len = repmat(corr_len_m,size(DR,1),1);
corr_len(:,corr_len_m<eps) = DR(:,corr_len_m<eps);
sub_dims = uint32(ceil(DR./corr_len));
sub_dims = max(sub_dims,sub_dim_min);
sub_dims(:,3) = min(sub_dims(:,3),sub_dim_max);
end

function [sub_poro,sub_perm] = downscale_cell(poro,perm,dr,sub_dims,corr_len_m,...
    stdev_poro,stdev_log_perm,args)
arguments
    poro (1,1) double
    perm (1,3) double {mustBePositive}
    dr (1,3) double
    sub_dims (1,3) uint32
    corr_len_m (1,3) double
    stdev_poro (1,1) double
    stdev_log_perm (1,1) double
    args.max_rel_stdev_poro (1,1) double = Inf;
end

sub_dr = dr./double(sub_dims);
K = gen_corr_kernel(sub_dr,corr_len_m,"num_cap",sub_dims);


rand_field = randn(double(sub_dims)+size(K)-1);
corr_field = convn(rand_field,K,'valid');

sub_poro = normalize(corr_field,poro, min(stdev_poro,poro*args.max_rel_stdev_poro));

sub_poro = max(sub_poro,0);

perm_x = perm(:,1);
sub_log_perm_x = normalize(corr_field,log(perm_x),stdev_log_perm);
sub_perm_x = exp(sub_log_perm_x);

KyKx = perm(2)./perm(1);
KvKh = perm(3)./perm(1);

% FIXME: implement optimization-based directional permeability multipliers:
% 1. Compute mean-based permeabilities
% 2. Compute multiplicative mismatch with input permeabilities
% 3. Apply multipliers
% 4. Repeat until match

sub_perm = zeros([sub_dims,3]);
sub_perm(:,:,:,1) = sub_perm_x;
sub_perm(:,:,:,2) = sub_perm_x*KyKx;
sub_perm(:,:,:,3) = sub_perm_x*KvKh;

end

function data = normalize(data,target_mean,target_stdev)
data_mean = mean(data(:));
data_stdev = std(data(:));
data = target_mean + (data - data_mean).*(target_stdev./data_stdev);
end

function K = gen_corr_kernel(dr,corr_len,options)
arguments
    dr (1,3) double
    corr_len (1,3) double
    options.num_cap (1,3) uint32 = [Inf,Inf,Inf];
end
num = floor(corr_len./dr);
num = max(num,1);
num = min(num,double(options.num_cap));
x = linspace(-1,1,2*num(1)+1)*dr(1)*num(1);
y = linspace(-1,1,2*num(2)+1)*dr(2)*num(2);
z = linspace(-1,1,2*num(3)+1)*dr(3)*num(3);

[X,Y,Z] = meshgrid(x,y,z);

X = permute(X,[2 1 3]);
Y = permute(Y,[2 1 3]);
Z = permute(Z,[2 1 3]);

K = checked_div(X,corr_len(1)).^2 ...
    + checked_div(Y,corr_len(2)).^2 ...
    + checked_div(Z,corr_len(3)).^2 <=1;
K = K./sum(K(:));
end

function result = checked_div(x,y)
arguments
    x
    y
end
fallback = 0;
result = x./y;
result(isnan(result)) = fallback;
end
