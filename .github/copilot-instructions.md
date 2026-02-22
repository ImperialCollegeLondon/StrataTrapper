# StrataTrapper AI Coding Guide

## Project Overview

StrataTrapper is a MATLAB toolkit for **upscaling** field-scale reservoir models using a Macroscopic Invasion Percolation (MIP) algorithm. It models two-phase flow (CO₂/water) by computing upscaled properties from fine-scale heterogeneous models and exporting to PFLOTRAN-OGS or OPM Flow formats.

**Core workflow**: Fine-scale models → `strata_trapper` (upscale) → `ogs_export`/`opm_export`

**Optional**: Use `downscale()` to generate fine-scale models from coarse grids when starting without heterogeneous data.

## Architecture & Data Flow

### Main Components

- **[src/strata_trapper.m](src/strata_trapper.m)**: Main orchestrator. Loops through coarse cells using `parfor`, calls `upscale()` for each coarse block
- **[src/upscale.m](src/upscale.m)**: Core scientific algorithm. For each saturation point, runs MIP via `calc_percolation()` to compute upscaled capillary pressure and relative permeabilities (krw/krg)
- **[src/downscale.m](src/downscale.m)**: (Optional) Generates fine-scale heterogeneous porosity/permeability fields with spatial correlation using `gen_corr_field()` - only needed when starting from coarse-scale models
- **[src/export/](src/export/)**: Exports results to external simulator formats (OGS, OPM Flow)

### Key Classes (OOP with Validation)

- **[Params](src/Params.m)**: Rock-fluid properties (krw/krg tables, capillary pressure, densities). Pass arrays for multi-region models
- **[Options](src/Options.m)**: Algorithm options (saturation points, thresholds). Uses builder pattern: `Options().save_mip_step(true)`
- **[CapPressure](src/CapPressure.m)**: Leverett J-function capillary pressure model with contact angle/surface tension
- **[TableFunction](src/TableFunction.m)**: 1D interpolation wrapper for relative permeability curves

### Region Mapping via Masks

Use `uint8` masks to map coarse cells to `Params` array indices:

```matlab
mask = uint8([0,1,2,1,0,1,2,1,0]); % 0=skip, 1=params(1), 2=params(2)
params(2) = gen_params_2(); % define region 2
strata_trapped = strata_trapper(grid, sub_rock, params, mask=mask);
```

Zero mask values exclude cells from computation.

## Critical Conventions

### Units System (Physical Constants)

**All internal calculations use SI base units**. Use helper functions from [src/units/](src/units/) to convert:

```matlab
perm = 100 * milli() * darcy(); % → 9.869e-14 m²
pressure / barsa()               % → pressure in bar
depth * meter()                  % → depth in meters
```

Functions like `meter()`, `barsa()`, `milli()`, `darcy()` return conversion factors. **Never hardcode unit conversions**.

### Function Signatures (Arguments Blocks)

All modern functions use `arguments` blocks with validation:

```matlab
function result = my_func(grid, args)
arguments
    grid (1,1) struct
    args.mask (:,1) uint8 = ones(grid.cells.num,1)
    args.options (1,1) Options = Options()
end
```

Use name-value syntax when calling: `strata_trapper(grid, rock, params, mask=my_mask)`.

### Parallel Computing Pattern

All heavy computation uses `parfor` with fixed partitioning:

```matlab
parfor (cell_index = 1:subset_len, parforOptions(...,'SubrangeSize',1))
    % compute upscaled properties per cell
end
```

- Start with `parpool()` before calling `strata_trapper()` for performance
- `enable_waitbar=true` shows `ParWaitBar` progress (custom parallel waitbar using `parfeval`)
- Warning management: `warnings_off()` → compute → `warnings_on()` pattern per worker

## Developer Workflows

### Setup & Testing

1. **Initialize**: Run [startup.m](startup.m) to add paths (`addpath(genpath("./src"))`)
2. **Run demo**: `demo()` or `demo(parfor_arg=2, show_figures=false)`
3. **Test**: Use MATLAB buildtool via [buildfile.m](buildfile.m):
   - `buildtool` → runs `check`, `test`, `test_codegen` tasks
   - `buildtool test` → unit tests in [test/](test/)
   - `buildtool check` → MATLAB Code Analyzer (zero warnings enforced in CI)

### MEX Acceleration (Performance)

Use [CodeGenMex](src/CodeGenMex.m) to compile `upscale()` for ~2-5× speedup:

```matlab
codegen_mex = CodeGenMex().config().build(); % creates upscale.mexa64
% Use strata_trapper() normally - MEX overrides interpreted function
codegen_mex.clear(); % delete MEX to revert to source
```

**Requires MATLAB Coder**. Config optimizes for speed (SIMD, inlining, 32 threads). Recompile after editing `upscale.m`.

### Grid Structure Convention (MRST-Compatible)

**Input compatibility**: `strata_trapper()` is compatible with [MRST](https://www.sintef.no/projectweb/mrst/) grid structures. Grid can be imported from `.EGRID` simulation results or created manually.

Required fields:

```matlab
grid.cartDims = [Nx, Ny, Nz];
grid.cells.num = prod(grid.cartDims);
grid.DX = 400*meter() * ones(grid.cells.num,1); % per-cell dimensions
grid.DY = ...; grid.DZ = ...;
```

Rock as `rock.poro` (vector) and `rock.perm` (N×3 matrix for x/y/z).

**Important**: Maintain MRST compatibility on the input side when modifying grid/rock handling.

## File Organization

- **Root**: Top-level scripts ([demo.m](demo.m), [test.m](test.m), [startup.m](startup.m))
- **[src/](src/)**: All source code (functions/classes)
- **[src/export/](src/export/)**: Simulator-specific exporters (`ogs_export()`, `opm_export()`)
- **[src/validation/](src/validation/)**: Custom validators for `arguments` blocks
- **[ogs/](ogs/) & [opm/](opm/)**: Example export outputs (include files for grid properties, curves)

## Testing in CI

- GitHub Actions matrix tests MATLAB R2023a & R2024b
- Requires Statistics_and_Machine_Learning_Toolbox, Parallel_Computing_Toolbox
- CI skips `test_codegen` (needs batch licensing)

## Common Patterns

- **Builder methods**: Return `self` for chaining: `Options().save_mip_step(true).poro_threshold(0.01)`
- **Output structs**: `strata_trapper()` returns struct with fields like `.porosity`, `.permeability`, `.saturations`, `.mip`
- **Monotonization**: `monotonize()` enforces monotonic relative permeability curves
- **Permeability weights**: `CapPressure.perm_weights` computes effective permeability (default: `[0.5,0.5,0]` for K=(Kx+Ky)/2)

## Scientific Context

Based on [Jackson & Krevor (2020)](https://doi.org/10.1029/2020GL088616). The MIP algorithm in [calc_percolation.m](src/calc_percolation.m) simulates capillary-controlled CO₂ invasion. Upscaling preserves small-scale heterogeneity effects critical for CO₂ storage predictions.

## Commit Standards

Follow [Conventional Commits](https://www.conventionalcommits.org/) with gitmoji:

**Format**: `type(scope): emoji description`

**Types**: `feat`, `fix`, `chore`, `ci`, `refactor`, `test`, `build`, `docs`

**Scopes** (from [.vscode/settings.json](.vscode/settings.json)):
- `export` - simulator export functionality (OGS, OPM)
- `matlab` - MATLAB-specific tooling (buildfile, CI config)
- `options` - Options class and algorithm parameters
- `plot` - visualization and plotting functions
- `matlab-repo-init` - repository initialization/setup
- `release-please` - release automation

**Commit Message Template**:

```
<type>(<scope>): <emoji> <description>

<optional body with more details>

Co-authored-by: <name> <email>
```

**Field Definitions**:

- `type`: Conventional commit type (feat, fix, chore, test, refactor, docs, build, ci)
- `scope`: Feature or subsystem affected (see approved scopes above)
- `emoji`: Standard gitmoji indicator (see examples below)
- `description`: Concise one-liner describing the change
- `body`: Optional detailed explanation of what was implemented, split across multiple lines
- `Co-authored-by`: Name and email of human developer (for agentic sessions, retrieved from git config)

**Emoji Reference**:

- ✨ new feature
- 🐛 bug fix
- ✅ tests
- ♻️ refactor
- 🚸 UX improvement
- 💚 CI fix
- 📦 build/dependencies
- 🚚 rename/move files
- 💡 comments/documentation
- ✏️ typos

**Examples from commit history**:
```
feat(export): ✨ MULT[XYZ] for OPM (optional)
fix(export): 🚸 name-value args for OGS
refactor: ♻️ make `upscale` MEX-compatible
ci(matlab): 💚 fix `buildfile`
chore: ✏️ fix typos in comments
test: ✅ reduce grid size in `demo`
```

**Agentic session examples**:

```
feat(compress): ✨ add stub compress_tables function (Phase 1)

Implements zeroth iteration of compression pipeline.
- Identity mapping (no compression yet)
- Full input/output validation using granular validators
- Zero reconstruction error for stub implementation

Co-authored-by: Max Elizarev <44438314+djmaxus@users.noreply.github.com>
```

```
test(compress): ✅ add comprehensive unit tests for compression

Implements CompressTablesTest class with 8 test methods covering identity mapping,
output structure, error measurement, and invariant validation.

Co-authored-by: Max Elizarev <44438314+djmaxus@users.noreply.github.com>
```

## Agentic Session Commit Plan

When an agentic vibe-coding session needs to land a change:

1. **Plan first**: Write a short plan in the work log or chat before editing. Keep it 3-6 steps.
2. **Make minimal edits**: Change only files required for the plan. Avoid unrelated formatting or refactors.
3. **Commit message**: Use Conventional Commits + gitmoji and include an explicit cue that the change came from an agentic vibe-coding session, e.g. `docs(matlab): 💡 agentic vibe-coding notes`.
4. **Co-author trailer**: Always add a trailer line in the commit message body:
    - `Co-authored-by: <Human Name> <human@email>`
5. **Verified status**: Prefer signed commits so GitHub marks them as Verified. Use a configured GPG or SSH signing key in the authoring environment and set `commit.gpgsign=true`.
6. **Auditability**: If the change was made by an automated assistant, mention it once in the commit body for clarity.

## When Making Changes

- **Adding features**: Follow `arguments` block pattern with validation
- **Performance-critical code**: Keep `upscale.m` compatible with MATLAB Coder (avoid dynamic typing, unsupported functions)
- **New export formats**: Add to [src/export/](src/export/), follow `ogs_export.m` structure
- **Units**: Add new conversions to [src/units/](src/units/) as simple multiplier functions
- **Grid/rock inputs**: Maintain MRST compatibility - ensure `strata_trapper()` can accept MRST grid structures (e.g., from `.EGRID` files)
