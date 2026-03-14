# Lossy compression of upscaled saturation tables

[Read more about Vector Quantization](https://en.wikipedia.org/wiki/Vector_quantization)

- [`quantize`](quantize.m) — main compression utility
- [`QuantizeOptions`](QuantizeOptions.m) — hyper-parameters
- [`dequantize`](dequantize.m) — restore compressed tables
to the original uncompressed number. Used for comparisons, plots, and export.
- [`compare_tables`](compare_tables.m) —
mean L2 difference between two alternative compressions
Can be used to compare with the original outputs.

## Algorithm

The conceptual Mermaid flowchart for the algorithm:

```mermaid
flowchart TD
upsc[/"Upscaled tables [sw,J,krw,krg]"/]

do_param_fit{Do parametric fit?}
embed{Fit total mobility?}
red{Use PCA?}

latent[/Feature vectors/]

clean[/De-duplicated data/]

repr[/N representative cluster points/]
tabs[/N representative saturation tables/]

upsc --> do_param_fit
do_param_fit -- no --> embed
embed -- no --> red
embed -- yes --> red
red -- no --> latent
red -- yes --> latent
do_param_fit-- Parametric LET fit for relative permeabilities --> red
latent -- Remove near-identical entries --> clean
clean -- "Use as is" --> repr
clean -- "Quantisation (k-means)" --> repr
repr -- "Inverse transform to tabular format" --> tabs
```
