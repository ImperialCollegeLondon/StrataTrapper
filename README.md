# Field scale model generation and upscaling [toolkit](https://github.com/ImperialCollegeLondon/StrataTrapper)

![StrataTrapper logo](./img/StrataTrapper.jpg)

* [What is StrataTrapper upscaling toolkit?](#what-is-stratatrapper-upscaling-toolkit)
* [Code structure](#code-structure)
* [How to run codes](#how-to-run-codes)
* [Contributing](#contributing)
* [References](#references)

## What is StrataTrapper upscaling toolkit?

This is a tool to generate heterogeneous fine-scale models with specific correlation length & update model for two-phase flow simulation.

## Code structure

`A0_mian.m` is the main script to run.
`A1` – `A5` scripts are called by `A0_mian.m`, and can also be run individually.

|Folder     |Contents                                                            |
|-----------|--------------------------------------------------------------------|
|`Functions`|internal helper functions                                           |
|`Input`    |input settings & fluid properties for simulation                    |
|`Output`   |produced visualisations and intermediate files                      |
|`Reference`|the User Manual                                                     |
|`Result`   |generated `.DATA` file (+includes) in ECLIPSE format (version 2019) |

Input/output directories as a whole are the precomputed example
to describe file formats and provide a reference for comparisons and testing.

Other folder and files are repository-related.

## How to run codes

1. Go to `Input` folder and adjust parameters of a numerical model
2. Run `A0_mian.m` and wait for the completion
3. Re-run sub-scripts `A1` – `A5` if considered necessary
4. Use `Output/*.vtk` files for visualisation and other needs
5. Use `Result/ECLIPSE_RUN.DATA` as an input for reservoir simulation software.
  The generated file corresponds to the version 2019 of ECLIPSE.

## Contributing

Everyone is welcome to open [issues](https://github.com/ImperialCollegeLondon/StrataTrapper/issues) and [pull requests](https://github.com/ImperialCollegeLondon/StrataTrapper/pulls).

## References

Please refer to the User Manual in the `Reference` folder
for more detailed description of the algorithm with visual examples.

More about motivation and theory behind the StrataTrapper approach in the paper:
> Samuel J. Jackson, Samuel Krevor\
> **Small-Scale Capillary Heterogeneity Linked to Rapid Plume Migration During CO2 Storage**\
> *Geophysical Research Letters* | 2020\
> <https://doi.org/10.1029/2020GL088616>
