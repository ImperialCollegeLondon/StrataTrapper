function [sub_porosity, sub_permeability] = downscale(porosity, perm_coarse, dr, downscale_params)

subscale_dims = max(ceil(dr./downscale_params.subscale),3);
even_dims = mod(subscale_dims,2)==0;
subscale_dims(even_dims) = subscale_dims(even_dims)+1;

%% generate initial relizations

gen_dims = subscale_dims.*2-1;
sub_poro_perm = downscale_params.poro_perm_gen(prod(gen_dims));

sub_porosity = reshape(sub_poro_perm(1,:),gen_dims);
sub_permeability = reshape(sub_poro_perm(2,:),gen_dims);

%% generate fine-scale porosity

sub_porosity = rsgen3D(dr,subscale_dims,downscale_params.corr_lens,@(N)sub_porosity);
sub_porosity = normalize(sub_porosity,porosity);
sub_porosity = max(sub_porosity,0);

%% calculate fine-scale permeability

sub_permeability_log = log(sub_permeability);
sub_permeability_log = rsgen3D(dr,subscale_dims,downscale_params.corr_lens,@(N)sub_permeability_log);
sub_permeability_log = normalize(sub_permeability_log,log(perm_coarse));
sub_permeability = exp(sub_permeability_log);

end

function [f] = rsgen3D(dr,dims,corr_lens,dist)
arguments
    dr        (1,3) double
    dims      (1,3) uint32
    corr_lens (1,3) double
    dist      = @(N) randn(N)
end
x = linspace(-0.5,0.5,dims(1)).*dr(1)*(1 - 1/double(dims(1)));
y = linspace(-0.5,0.5,dims(2)).*dr(2)*(1 - 1/double(dims(2)));
z = linspace(-0.5,0.5,dims(3)).*dr(3)*(1 - 1/double(dims(3)));

[X,Y,Z] = meshgrid(x,y,z);

X = permute(X,[2 1 3]);
Y = permute(Y,[2 1 3]);
Z = permute(Z,[2 1 3]);

D = dist(dims.*2-1);

% Gaussian filter

    function out = divide(a,b)
        out = a./b;
        out(a==0)=0;
    end

K = divide(X,corr_lens(1)).^2 + divide(Y,corr_lens(2)).^2 + divide(Z,corr_lens(3)).^2;
K = exp(K.*(-2));
K = K./sum(K(:));

f = convn(D,K,'valid');

end

function [data] = normalize(data,new_norm)
arguments
    data double
    new_norm (1,1) double
end

norm_out = mean(data,"all");
data = data ./ norm_out .* new_norm;

norms_out = mean(data,"all");
assert(norm(norms_out - new_norm)<1e-8*norm(new_norm),'normalization failed');
end
