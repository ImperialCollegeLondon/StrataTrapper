# Changelog

## [0.18.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.17.0...v0.18.0) (2026-01-21)


### Features

* ✨ multi-rock-type upscaling ([371ba24](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/371ba24b027b61a0b5de41810636f938b9a39a24))
* ✨ normalization for CapPressure arrays ([27416be](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/27416bed18e7cbcd01c23bf48cb4dca5cfe320ee))
* 🚸 `CapPressure` arrays in `inv_lj` method ([e8accf3](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e8accf3db5a424347f2c2ae90eb55170d43cadec))
* **export:** 🚸 normalized `Params` to OGS ([9686574](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/9686574d65bcd5e16fb4bbfca5c017a9277848b8))
* **export:** 🚸 support fallback arrays for keywords ([d8a97ff](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d8a97ff2aab85e8df86574554649a99db1dac344))


### Bug Fixes

* **export:** ♻️ unified PORO export function ([a635c0c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a635c0c06c465e3c52e20dae19111843e5c4246a))
* **export:** 🚚 `write_mappings -> write_krnum` + SATNUM ([cf7c577](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/cf7c5771019ecc51062c9e32ce56524826d78894))
* **export:** 🚸 name-value args for OGS ([ab475d7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/ab475d7185d5852b5e4ba3f5c522c79da9e063c8))

## [0.17.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.16.0...v0.17.0) (2025-12-12)


### Features

* 📦️ MEX-accelerated `upscale` function ([2afdca7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/2afdca7372a28b9cd5876c6c8b35e3e4b39e9da9))
* **export:** `opm_export` out FIPMIP region of MIP upscaling mask ([12c8a17](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/12c8a171fcb16d96bf000e183a5d5d07f98cad76))
* **export:** ✨ MULT[XYZ] for OPM (optional) ([73f5da7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/73f5da7599fec1ef3a51d8f0e81f197120d11d2e))
* **options:** ✨ porosity/permeability thresholds ([adf1dc6](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/adf1dc6ba53a134dc9ebb08fc84a013694fb889b))
* support 1x1x1 upscaling edge case ([8259137](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/8259137aea7ab94627acb7c974ad5ab13e09d93c))


### Bug Fixes

* **export:** `opm_export`: export ENDSCALE ([4077382](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/407738230bb0a66f1e4cf5e364af58244f1c67e0))
* **export:** `opm_export`: make `output_folder` named argument ([64aab5f](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/64aab5f144bfec954f5d5123170a50971868ec6e))
* **export:** dimensionality of output PERM cubes ([768bdb1](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/768bdb1931f6a0ec3945c118748345cea7981f4a))
* **export:** OPM: export with default PORO and PERM ([8996909](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/89969098678afd831dca65f1badb5c7fbf00c82d))
* monotonize water rel. perms ([1e9d240](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/1e9d240be07ff7d4f2adb9ff6138104393fa1783))

## [0.16.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.15.0...v0.16.0) (2025-11-19)


### Features

* **export:** ✨ export to OPM Flow simulator ([68f8263](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/68f8263768d3d8670df7c3b46c637c6d8c0f875e))


### Bug Fixes

* 🦺 ensure non-negative upscaled permeability ([9aa748c](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/9aa748c58a3b696cd27aea37fa32c50f84265951))
* **export:** 🔥 do not export SATNUM ([11037fd](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/11037fdcb1dafb4c67107004a23f5340b542d559))
* **export:** 🩹 `ogs_export` exports to `ogs/` by default ([9ef25a5](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/9ef25a5759e41f43ec4d597e77f1d565b053b6e0))

## [0.15.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.14.0...v0.15.0) (2025-06-02)


### Features

* 🚸 optionally disable misleading warnings ([e81151e](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e81151ee4052ba3f2cabae0692b34c7c18f62478))


### Bug Fixes

* ⚡️ replace expensive `condest` ([6fcfb3f](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6fcfb3fdd814bfe6dfda481f6bea66cfacd8fb12))

## [0.14.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.13.0...v0.14.0) (2025-05-19)


### Features

* **export:** 🚸 `function export_ogs(Params)` ([589c415](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/589c415b59c303a8310b30748c06b830cde516a1))
* **export:** 🚸 `write_mappings`: add `offset` argument ([68ba084](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/68ba08448b4249b2971f0d03a4bdd46fb521a86d))


### Bug Fixes

* **export:** `write_curve_num` -&gt; `write_keyword` ([3ed1d8d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/3ed1d8db8b6098ec280b1cd97716fd735c8c3901))
* **export:** 🚸 `generate_sfn` syntax and behavior ([67e9f55](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/67e9f557cc4175a686ac946fab01ab1ed816660e))
* **export:** 🚸 `ogs_export` functionality ([6eb3402](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6eb3402b18cf2321c6e41c2c5a5dbecee39345d9))
* **matlab:** 🚸 add root to path on `startup` ([6e32ee9](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6e32ee93580a5cfc1269c41ffab869deeaf39c66))

## [0.13.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.12.1...v0.13.0) (2025-05-16)


### Features

* 📝 add minimal citation file ([c9cbbfd](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/c9cbbfdfa97cbc82ad58b6d079d686c9decba7a4))

## [0.12.1](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.12.0...v0.12.1) (2025-05-02)


### Bug Fixes

* ♻️ move demo helpers into demo script ([5e79f39](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/5e79f39dcb0f34ef26e3ec97dd8af21617e20a6b))

## [0.12.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.11.4...v0.12.0) (2025-04-25)


### Features

* **options:** ✨ save sub-saturations from MIP step ([a9c26ac](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a9c26ac86c6338833ca8ee324d950cb5c515fe4a))

## [0.11.4](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.11.3...v0.11.4) (2025-04-11)


### Bug Fixes

* **plot:** 🚨 remove unused variable ([cfd4540](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/cfd454046bc63c60caec4e844f1e1bcf313d9b4a))

## [0.11.3](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.11.2...v0.11.3) (2025-03-27)


### Bug Fixes

* 🐛 `ParWaitBar`: support thread-based pools ([3d6b2cf](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/3d6b2cf7563aa22b137c9a127dbb1403f53e48e0))

## [0.11.2](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.11.1...v0.11.2) (2025-03-26)


### Bug Fixes

* code analyzer warnings ([4890f33](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/4890f3348be9c144e3ae145ca781e66157f5b569))
* line change revert in demo.m ([dc333be](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dc333be82b498ed51483f972931e4b794ab6e5d8))
* revert mask change in demo.m ([dc6fcab](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dc6fcab0524e502cf83dd962df4cd6bcbd8980ab))

## [0.11.1](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.11.0...v0.11.1) (2025-03-26)


### Bug Fixes

* 🐛 numerical stability of `upscale_permeability` ([8e255be](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/8e255bee6cda73fa4e7a4e4d04fd43b07ecdfb77))

## [0.11.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.10.0...v0.11.0) (2025-03-21)


### Features

* :children_crossing: add arguments to `demo` ([c5907d9](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/c5907d96421fc9e686ca9a63a450b9d81b21a264))


### Bug Fixes

* **plot:** :children_crossing: remove legend transparency ([d4ef60e](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d4ef60e5d6eee3b093fc96b9503ae114837ebfa2))
* **plot:** :children_crossing: set `YScale` directly ([c0d3c33](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/c0d3c33fe1b32636affb14606228d5028aa6857b))

## [0.10.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.9.0...v0.10.0) (2025-03-09)


### Features

* :children_crossing: `strata_trapper`: named optional arguments ([3ca7ebb](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/3ca7ebb4ac5db91d66aa24997bccc73eb2bc90e3))
* :children_crossing: `strata_trapper`: put inputs to output ([6c43ab7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/6c43ab7487bd14429f3500b259966e0243f93d77))
* :children_crossing: compute solver performance ([bd6aad0](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/bd6aad0a8ccbcd5c00849f0ee6aff5761f2d724c))
* :children_crossing: more flexible parallel options ([dfb4ba2](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/dfb4ba2d6c8e115f17f3615b2e9e661b4e634c0d))
* :sparkles: function for struct hashing ([381b3e2](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/381b3e2f31e3bd2ef1fdfe4a00e4fd3288230392))
* **export:** :children_crossing: J-Leverett export function ([911a441](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/911a441caaee316bab15e71a1793d9a5dece3f57))
* **export:** :sparkles: separate function for permeability export ([403459a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/403459a37dc983c7359cd4e74feebd07a4b28750))
* **plot:** visibility option for `plot_result` figure ([5e85ab9](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/5e85ab9ad8b5e9a89c67c2890c4566476b0d2778))


### Bug Fixes

* :bug: fix interpolation of Pc and kr ([f2a3969](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/f2a39692b4073e863dc118818bec6fa37ff62aab))
* :bug: fix numerical errors in gas permeability ([0a7533a](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/0a7533a34200c564a3adc921a2d4a91d367e1d69))
* :bug: Improve MIP stability ([784ef9e](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/784ef9e1a52ac804dfc9af574b2ba4648db0c238))
* :bug: more stable cap. pressure calculations ([a082bd1](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a082bd13be1a9e745df29e62dc66f6ebf8c48f44))
* :bug: upscale permeabilities in milli-darcy ([e97a25d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e97a25dd5b71097b457b07edb0f5abb7cc2d0eba))
* :children_crossing: make `demo` suitable for test ([74cf275](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/74cf275afbac9a8686bce6afc5bc24a3761454f6))
* :children_crossing: more stable TableFunction behaviour ([f21a025](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/f21a02502fcd8a5fc7f53350c4c7644c73a5481f))
* **export:** export curves to 3 separate files (x,y,z) ([21f05e8](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/21f05e851ae716d22b3f010505346e771356e402))
* **matlab:** :fire: delete `finish.m` ([5616ea0](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/5616ea0c0ad737ceae6d0d567cf5ca2de1f63dfb))


### Continuous Integration

* **matlab:** :construction_worker: enable tests in CI ([d05d1e2](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/d05d1e2267cdce4848ed0199fd1e5434121be3a8))

## [0.9.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.8.0...v0.9.0) (2024-12-09)


### ⚠ BREAKING CHANGES

* **plot:** :children_crossing: `plot_result`: make optional args name-value'd

### Features

* **plot:** :children_crossing: optionally plot summary at a given parent ([5d3b25d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/5d3b25d987cb0af3cbe71e70027cbca54027cedf))


### Bug Fixes

* **export:** :bug: call to `ogs_export` in `demo` ([afc0e61](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/afc0e61a47d45201ee33d3634f3e3cb93c56d7bf))
* **export:** :children_crossing: `ogs_export`: update input args to auto-create directories ([fca0ec4](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/fca0ec491b6a6583e0f138034d1bcf7ed38ddde6))
* **plot:** :children_crossing: `plot_result`: make optional args name-value'd ([a239899](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/a2398999527b9a6ba9dff698dd7a64354fdc75b9))


### Miscellaneous Chores

* :page_facing_up: license Apache 2.0 -&gt; BSD 3-Clause ([e2fd197](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e2fd19714a32521367dfa674fd57d44d3d92616c))

## [0.8.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.7.0...v0.8.0) (2024-11-05)


### Features

* :sparkles: figure handle for `plot_summary` ([5eaf6a7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/5eaf6a79a518d81baf3f335aed594ae49953782b))

## [0.7.0](https://github.com/ImperialCollegeLondon/StrataTrapper/compare/v0.6.3...v0.7.0) (2024-10-29)


### Features

* :children_crossing: compressed `strata_trapper` outputs ([08654cc](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/08654cc9a091177c0cdf0208516d89351c15c1b0))
* :children_crossing: New summary plot layout ([e73f0f0](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/e73f0f0a2deac073cacce7cd0da8b0d16bf56f15))
* :children_crossing: workspace autosave on exit ([207bfd0](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/207bfd05260338812875124002c33f9ce6886eb4))
* :sparkles: compute Leverett J-function with `CapPressure` class ([312d54d](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/312d54df83a079c8ec7352e38f0f7753962866f6))
* :sparkles: Hydrostatic correction for MIP ([7dd9c37](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7dd9c37e811bc843f63a06374cef35a054e21a8b)), closes [#57](https://github.com/ImperialCollegeLondon/StrataTrapper/issues/57)


### Bug Fixes

* :bug: `upscale`: account for zero-porocity sub-volumes ([7389e95](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/7389e957f7b316a25208dfb8e61f954422640a39))
* :bug: MIP with gravity: missing gas density case ([f8728d2](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/f8728d2c470ae082b1dd1eb276cccb4f44c38119))


### Documentation

* :memo: more status badges in README ([ebe5ac7](https://github.com/ImperialCollegeLondon/StrataTrapper/commit/ebe5ac7419a4e5d02bd481e742af7eb4e247d181))

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
