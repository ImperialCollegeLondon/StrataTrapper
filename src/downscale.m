function [sub_porosity, sub_permeability] = downscale(porosity, perm_coarse, dr, downscale_params)

subscale_dims = max(ceil(dr./downscale_params.subscale),3);
even_dims = mod(subscale_dims,2)==0;
subscale_dims(even_dims) = subscale_dims(even_dims)+1;

%% generate initial relizations

gen_dims = subscale_dims.*2-1;
sub_poro_perm = downscale_params.poro_perm_gen(prod(gen_dims));

sub_porosity = reshape(sub_poro_perm(1,:),gen_dims);
sub_perm_x = reshape(sub_poro_perm(2,:),gen_dims);

%% generate fine-scale porosity

sub_porosity = gen_corr_field(dr,subscale_dims,downscale_params.corr_lens,@(N)sub_porosity);
sub_porosity = normalize(sub_porosity,porosity);
sub_porosity = max(sub_porosity,0);

%% calculate fine-scale permeability

sub_permeability_log = log(sub_perm_x);
sub_permeability_log = gen_corr_field(dr,subscale_dims,downscale_params.corr_lens, ...
    @(N)sub_permeability_log);
perm_x = perm_coarse(1);
sub_permeability_log = normalize(sub_permeability_log,log(perm_x));
sub_perm_x = exp(sub_permeability_log);

anisotropy = perm_coarse ./ perm_x;

sub_permeability = zeros([subscale_dims,3]);
for i = 1:3
    sub_permeability(:,:,:,i) = sub_perm_x .* anisotropy(i);
end
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
