function [subscale_dims, sub_porosity, sub_permeability, sub_entry_pressures, porosity] ...
    = downscale(dr, params, options)

subscale_dims = max(ceil(dr./options.subscale),3);
subscale_dims(mod(subscale_dims,2)==0) = subscale_dims(mod(subscale_dims,2)==0)+1;

%% Permut arrays to satisfy (z,x,y) basis
idx_permut = [3,1,2];
sub_dims_permut = subscale_dims(idx_permut);
dr_permut = dr(idx_permut);
corr_lens = params.poro.corr_lens(idx_permut);

%% generate fine-scale porosity

% TODO: consider using extreme value distribution `evrnd`
sub_porosity = rsgen3D(sub_dims_permut,corr_lens./dr_permut,@(dims) randn(dims).* params.poro.std_dev + params.poro.mean);
sub_porosity = max(sub_porosity,0);
porosity = sum(sub_porosity .* prod(dr_permut./double(sub_dims_permut)),'all')/prod(dr_permut);

%% calculate fine-scale permeability

sub_permeability = params.perm_corr(sub_porosity);

%% calculate fine-scale sub_entry_pressures

sub_entry_pressures = params.capil.pres_func(1,sub_porosity, sub_permeability);

end

function [f] = rsgen3D(dims,corr_lens,dist)
arguments
    dims      (1,3) uint32
    corr_lens (1,3) double
    dist      = @(N) randn(N)
end

z = linspace(-0.5,0.5,dims(1));
x = linspace(-0.5,0.5,dims(2));
y = linspace(-0.5,0.5,dims(3));

[X,Z,Y] = meshgrid(x,z,y);

D = dist(dims.*2-1);

% Gaussian filter
K = (X./corr_lens(2)).^2 + (Y./corr_lens(3)).^2 + (Z./corr_lens(1)).^2;
K = exp(K.*(-2));
K = K./sum(K(:));

f = convn(D,K,'valid');

end
