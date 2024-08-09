function [params] = gen_downscale_params()
params.subscale = 50 * meter();

params.corr_lens = [50,50,0].*meter();

poro_gen = @(num_samples) randn(1,num_samples)*0.01 + 0.2;
perm_gen = @(num_samples) exp(randn(1,num_samples) + log(100)) * milli * darcy;

params.poro_perm_gen = @(num_samples) [poro_gen(num_samples); perm_gen(num_samples)];
end

