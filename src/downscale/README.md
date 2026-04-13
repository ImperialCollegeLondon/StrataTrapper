# Stochastic downscaling of coarse models

[`downscale`](./downscale.m) takes coarse model data
imported with [`import_eclipse`](../import/import_eclipse.m)
and generates pseudo-random fine-scale details
with anisotropic spatial correlation lengths `corr_len_m`.

Can be used to re-upscale given conventionally-upscaled coarse models with StrataTrapper.
