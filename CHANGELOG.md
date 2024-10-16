# Changelog

## [0.6.3](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.6.2...v0.6.3) (2024-10-16)


### Documentation

* :memo: Add link to `StrataTrapper-models` ([24e55d6](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/24e55d64b9443e30b34b83358cdfbd2b38eff4bd))

## [0.6.2](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.6.1...v0.6.2) (2024-08-19)


### Bug Fixes

* :adhesive_bandage: waitbar initialization ([ad0c2af](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/ad0c2af657d6f1670516967809ac7f3517f7479c))
* :bug: `mask`-narrowed post-processing ([81b247b](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/81b247b244776ea4acf0b183711be93022a222bf))
* :bug: relative permeability upscaling ([b2b15f7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/b2b15f7e5e55f23c2eb88382f2889b67ab8ecb7b))

## [0.6.1](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.6.0...v0.6.1) (2024-08-13)


### Documentation

* :memo: CI status badge in README ([d2772df](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d2772df2e78baf6ad5668cb9844783bece354a41))

## [0.6.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.5.0...v0.6.0) (2024-08-13)


### ⚠ BREAKING CHANGES

* :sparkles: anisotropic permeability downscaling
* :sparkles: anisotropic permeability upscaling

### Features

* :sparkles: anisotropic permeability downscaling ([604bfe3](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/604bfe394d33ed1e57926e46963ed5419b8aec2e))
* :sparkles: anisotropic permeability upscaling ([91bc3e1](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/91bc3e14ec048561af156f9730132d1181a34796))
* :sparkles: capillary pressure under anisotropic permeability ([0f420c9](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/0f420c9524df9c2762605def7c860fe2152065d7))


### Bug Fixes

* :adhesive_bandage: `demo.m`: existing parpool case ([0b0ff1a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/0b0ff1ae4b1d997bdc571276a6d92fc0e98d206e))
* :adhesive_bandage: gas rel. perm. at Sw=1 ([8e7c771](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/8e7c771407ebecea56de63d66b362e628e8c8777))
* :adhesive_bandage: iterative MIP: relax saturation tolerance ([9f0bd39](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/9f0bd39a0102cff5952ec57b92c1d9acb77306aa))

## [0.5.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.4.0...v0.5.0) (2024-08-09)


### ⚠ BREAKING CHANGES

* :children_crossing: Separate downscaling from upscaling

### Features

* :sparkles: `CapPressure` class ([b0e51f1](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/b0e51f1acc1fa1b0dc773b27ab0bfe5686baca55))
* :sparkles: add centi multiplier ([22214f8](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/22214f8dccdec628d3be166f9a1353c0975d6f16))
* :sparkles: add dyne as force unit ([4cd975c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/4cd975cef83fdf665740440e31150e95fe3bf061))
* :sparkles: Implement StrataTrapper parameters as class ([c6dc14c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/c6dc14c57bb950fba52b3b6323f2f890ad93cdee))
* :sparkles: make `options` a class with validated properties ([a02bf4a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a02bf4ae7a3e1959ddc206ac74c893fd4dfbb22c))
* :sparkles: Relative permeability via new `TableFunction` class ([cfed173](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/cfed173222906bf0e37f9c0f8c24f814d57dbeed))


### Bug Fixes

* :adhesive_bandage: `strata_trapper`: initialize output arrays with NaN ([0f13d2c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/0f13d2c76a25153c9639baf5bc585a8acdc14c13))
* :adhesive_bandage: `upscale` calculate downscale dimensions inside ([de68c8b](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/de68c8b9edd69ef3a4f6d86177552ae2482bd7d1))
* :adhesive_bandage: `upscale`: interpolate upscaled curves inside ([45bd142](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/45bd1429e2b198ffdef92ca358cfbcb5c979c1e6))
* :bug: permeability upscaling ([8815ca6](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/8815ca6c9d1e5adc5290ce547d1e3b1d3f9db553))
* :children_crossing: Compute entry pressures during upscaling ([b088eaf](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/b088eaf2ebfca50e2b9ec187ad6df56774823214))
* :children_crossing: Separate downscaling from upscaling ([b551c73](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/b551c73d0ff2f6d4af0c1c1c50bc15eb17552234))


### Documentation

* :memo: Update `README.md` ([7219f1a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7219f1a4e4effcb64d8359039df54e8c0046d6b5))

## [0.4.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.3.0...v0.4.0) (2024-07-30)


### Bug Fixes

* :bug: `calc_percolation`: proper search window + performance ([bc053e4](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/bc053e49460d16be78626e2de32e655b095b217b))
* :bug: `rsgen3D` internal meshing ([b98c3c5](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/b98c3c5f94c8ae2fa709f1b1505b43dc07f08664))
* :bug: connectivity for permeability computation ([7e2d900](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7e2d9002fed96eb89a5f6699bec80be75fc8badc))
* :bug: fix negative gas rel. perms. as computational artifacts ([cc52d1e](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/cc52d1e9be7d97dc246bbd315806631a6f4cb203))
* :bug: permeability upscaling ([fb4598d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/fb4598d8e9925dac0fb0a5e8f988e259f3831ec2))


### Documentation

* :memo: update `demo` script ([e9a07b5](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e9a07b54d7e18b82b7e31cb16b9127b4aa5b28a7))

## [0.3.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.2.3...v0.3.0) (2024-07-17)


### Features

* :sparkles: `downscale` w.r.t. given coarse values ([dd2ab3f](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dd2ab3fa23f64901f4686cb9b1ce42101554a6d7))
* :sparkles: update structure and values of input data ([fb58904](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/fb58904412bbdaac1656da10e0699fe615c124f8))
* :sparkles: updated model of saturation functions ([1b34d5c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/1b34d5c257fd6c4b8a4033d2ff134ce128c6f238))
* :sparkles: variable number of parallel workers ([ac7ce89](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/ac7ce89d6b51c46ef38aa96a8c6975c361c34ee9))


### Bug Fixes

* :adhesive_bandage: default `output_prefix` for `ogs_export` ([aa4c1c0](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/aa4c1c0baeb29fb14a3e180c250fa2e79b4959ed))
* :adhesive_bandage: target saturations sampling ([a89d21b](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a89d21b47545e5775035d2599e5480905e46eaf0))
* :adhesive_bandage: truncate computation mask ([7acc040](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7acc040f9334c43aced56ef41cc1f21c8552bec1))
* :bug: create waitbar data queue unconditionally ([7d30513](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7d305130cb1a08d8b337f6a4664a7d584ff27321))
* :bug: zero gas permeabilities ([d1b29bf](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d1b29bf2f6885d1362b8d1feb39ea491e1c1cc3f))
* :children_crossing: state-based waibar update condition ([c884f8d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/c884f8d1ae1bbaeef399259b48cdb0179590133f))
* :fire: do not generate porosity file with `ogs_export` ([fa9c7b4](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/fa9c7b40e50e5544f7b53ddb0fcead649a5ced3a))
* :fire: speculative `krg` post-processing ([dbaf9f9](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dbaf9f94de0e38a02e78b192c67dd7bbeefccf40))
* :sparkles: update demo script ([77ff7e4](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/77ff7e4fff65c355f4f7ecd1087ce3b49f3f5cb1))
* :zap: `mip_iteration` Newton step relaxation ([07f0b16](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/07f0b16e420251f4424b575a3df4773ac1a6a96a))
* :zap: inexact intermediate saturations ([d76594e](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d76594eebbc4a6902d53a1d5a8ba87131b2dbe88))
* :zap: move curves post-processing to `downscale_upscale` ([14fa27d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/14fa27dfb5352bebb845ccec5a4917fed1358573))

## [0.2.3](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.2.2...v0.2.3) (2024-04-12)


### Documentation

* :memo: Add link to CO2GraVISim ([51b7a7a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/51b7a7a7fddf5a0d1a0cc4c9c50372ab5b3497d1))

## [0.2.2](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.2.1...v0.2.2) (2024-03-22)


### Documentation

* :memo: Update README ([a18fc58](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a18fc58432d9ef603c8d75a32ae8e39d8a59d92a))

## [0.2.1](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.2.0...v0.2.1) (2024-03-21)


### Bug Fixes

* :bug: misprint in function argument name ([dcd727d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dcd727db1e13ad07adfd6017bd379f0d8f687ad1))

## [0.2.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.1.0...v0.2.0) (2024-03-21)


### Features

* :sparkles: Add utilities to analyse MATLAB structs and workspaces ([6bd0f1a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6bd0f1add2d0b405cd00ff6e80a11435382ea894))
* :sparkles: Prepare new version with demonstration ([6168bad](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6168bad57faf5e5e824f64820b51ac37443248d8))


### Performance Improvements

* :zap: Optimize and format connectivity functions ([0b5e86f](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/0b5e86f3ba72c1934b5edab36d16586c74525e5a))
