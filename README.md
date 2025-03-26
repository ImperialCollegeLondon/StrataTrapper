# Field scale model generation and upscaling toolkit

Repository: [github.com/ImperialCollegeLondon/StrataTrapper](https://github.com/ImperialCollegeLondon/StrataTrapper)

![build](https://github.com/ImperialCollegeLondon/StrataTrapper/actions/workflows/ci.yml/badge.svg?branch=main)
![GitHub Tag](https://img.shields.io/github/v/tag/ImperialCollegeLondon/StrataTrapper?sort=semver&style=flat&label=version)
![GitHub Release Date](https://img.shields.io/github/release-date/ImperialCollegeLondon/StrataTrapper?display_date=published_at&style=flat&label=dated)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

* [The StrataTrapper codes](#the-stratatrapper-codes)
* [Structure](#structure)
* [Running](#running)
* [Versions](#versions)
* [Contributing](#contributing)
* [References](#references)

![StrataTrapper logo](./img/StrataTrapper.jpg)

## The StrataTrapper codes

This is the StrataTrapper **upscaling toolkit**.
It can also generate heterogeneous fine-scale models with specific correlation lengths
to re-upscale given coarse-scale two-phase flow models.

Another tool is the **reduced-physics model** [CO2GraVISim](https://github.com/ajobutler/CO2GraVISim).

In [`StrataTrapper-models`](https://github.com/ImperialCollegeLondon/StrataTrapper-models)
repository, we publish field-scale models upscaled with StrataTrapper.

## Structure

Top-level scripts and functions are in the repository root,
and the rest is in [`src/`](src) folder.

[`demo.m`](demo.m) script is an implementation of the running guideline below.\
Feel free to play with it and use as an example for your own scripts.

## Running

1. Run [`startup.m`](startup.m) to setup MATLAB Path.
   1. Optional: start a parallel pool to run computations there.
2. Read or generate target coarse grid dimensions
and input fine-scale porosity and permeability for each coarse block.
3. Setup input rock-fluid properties and algorithm options represented by
  [`Params`](src/Params.m) and [`Options`](src/Options.m) classes.
4. Create logical `mask` to filter out impermeable cells
and/or define an arbitrary subset of cells to process.
5. Run [`strata_trapper`](strata_trapper.m) function
with arbitrary number of parallel workers
optionally enabling a UI progress bar.
6. Visualise outputs with [`plot_result`](plot_result.m) function
7. Export the outputs to [PFLOTRAN-OGS](https://docs.opengosim.com/)-compatible
text files using [`ogs_export`](ogs_export.m) function.

Tips:

* Usually, MATLAB runs `startup.m` scripts automatically
if they are in a startup folder.
* The heaviest part of the algorithm is essentially parallel with no synchronisation.
So, using several parallel workers usually results
in a proportional performance boost.

## Versions

The original version of the toolkit is [v0.1.0](https://github.com/ImperialCollegeLondon/StrataTrapper/tree/v0.1.0).\
It has its own structure and some unique functionality,\
so it may worth attention as much as later versions.

[CHANGELOG.md](CHANGELOG.md) describes the version history and key changes.

Other versions can be accessed via
[tags](https://github.com/ImperialCollegeLondon/StrataTrapper/tags) and
[releases](https://github.com/ImperialCollegeLondon/StrataTrapper/releases)
sections of the repository.

## Contributing

Everyone is welcome to open
[issues](https://github.com/ImperialCollegeLondon/StrataTrapper/issues) and
[pull requests](https://github.com/ImperialCollegeLondon/StrataTrapper/pulls).

## References

The StrataTrapper algorithm as well as motivation
and theory behind it are in the paper:

> Samuel J. Jackson, Samuel Krevor\
> **Small-Scale Capillary Heterogeneity**
> **Linked to Rapid Plume Migration During CO2 Storage**\
> *Geophysical Research Letters* | 2020\
> <https://doi.org/10.1029/2020GL088616>
