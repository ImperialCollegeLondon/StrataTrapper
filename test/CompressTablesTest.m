classdef CompressTablesTest < matlab.unittest.TestCase
    % COMPRESSTABLESTEST Unit tests for compress_tables and measure_compression_error
    %
    %   Tests the output compression feature for strata_trapper results.
    %   Validates pass-through behavior, error measurement, and compression algorithms.

    properties
        testData
        originalStruct
    end

    methods(TestMethodSetup)
        function createTestData(testCase)
            % Generate synthetic upscaled tables for testing
            % Small grid: 3x3x3 = 27 cells
            testCase.testData = struct();

            % Dimensions
            subset_len = 27;
            sat_num_points = 40;

            % Generate saturation axis
            sw = linspace(0.12, 1.0, sat_num_points);

            % Generate synthetic capillary pressure curves
            % Use power-law-like behavior typical of capillary pressure
            pc_base = zeros(subset_len, sat_num_points);
            for i = 1:subset_len
                % Add variation per cell
                amplitude = 1e5 + randn(1) * 1e4;  % ~100 kPa ± 10 kPa
                exponent = -2.0 + randn(1) * 0.2;
                pc_base(i, :) = amplitude * (sw .^ exponent);
            end

            % Generate synthetic relative permeability curves
            % Corey-type curves: krw ~ sw^nw, krg ~ (1-sw)^ng
            krw = zeros(subset_len, 3, sat_num_points);
            krg = zeros(subset_len, 3, sat_num_points);

            for i = 1:subset_len
                for dir = 1:3
                    % Water rel perm: increases with sw
                    nw = 2.0 + randn(1) * 0.3;
                    krw_max = 0.8 + randn(1) * 0.1;
                    sw_norm = (sw - sw(1)) / (1 - sw(1));
                    krw(i, dir, :) = krw_max * (sw_norm .^ nw);

                    % Gas rel perm: decreases with sw
                    ng = 2.0 + randn(1) * 0.3;
                    krg_max = 0.9 + randn(1) * 0.05;
                    krg(i, dir, :) = krg_max * ((1 - sw_norm) .^ ng);
                end
            end

            % Store test data
            testCase.testData.capillary_pressure = pc_base;
            testCase.testData.rel_perm_wat = krw;
            testCase.testData.rel_perm_gas = krg;
            testCase.testData.idx = 1:subset_len;
            testCase.testData.subset_len = subset_len;
            testCase.testData.sat_num_points = sat_num_points;

            % Generate porosity and permeability for J-function computation
            % Typical reservoir values
            testCase.testData.porosity = 0.2 + 0.05 * rand(subset_len, 1);  % 20-25%
            testCase.testData.permeability = [
                (100 + 50*rand(subset_len, 1)) * milli() * darcy(), ...  % Kx: 100-150 mD
                (100 + 50*rand(subset_len, 1)) * milli() * darcy(), ...  % Ky: 100-150 mD
                (50 + 25*rand(subset_len, 1)) * milli() * darcy()   ...  % Kz: 50-75 mD (lower)
            ];

            % Create CapPressure params object for single-region case
            % Using TableFunction for Leverett J-function
            sw_j = linspace(0.12, 1.0, 20)';
            % Typical J-function: decreases as Sw increases
            j_values = 0.5 ./ (sw_j - 0.1).^0.5;  % J(Sw) ~ 1/sqrt(Sw - Swi)
            j_func = TableFunction([sw_j, j_values]);

            contact_angle = deg2rad(0);  % Water-wet
            surface_tension = 30 * dyne() / (centi()*meter());  % Typical CO2-water
            perm_weights = [0.5, 0.5, 0];  % Average Kx and Ky

            testCase.testData.params = CapPressure(contact_angle, surface_tension, j_func, perm_weights);

            % Create original struct for error measurement tests
            testCase.originalStruct = struct('capillary_pressure', pc_base, ...
                                             'rel_perm_wat', krw, ...
                                             'rel_perm_gas', krg);
        end
    end

    methods(Test)
        function testPassThrough(testCase)
            % Verify per-direction compression with default tolerance=0
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            % Verify struct array structure (3,1)
            testCase.verifyEqual(numel(compressed), 3);
            testCase.verifyEqual(size(compressed), [3, 1]);

            % Verify each direction has correct structure and saturationpoints
            for dir = 1:3
                testCase.verifyTrue(isstruct(compressed(dir)));
                testCase.verifyTrue(isfield(compressed(dir), 'capillary_pressure'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_wat'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_gas'));
                testCase.verifyTrue(isfield(compressed(dir), 'mapping'));
                
                testCase.verifyEqual(size(compressed(dir).capillary_pressure, 2), ...
                                     testCase.testData.sat_num_points);
                testCase.verifyEqual(size(compressed(dir).rel_perm_wat, 2), ...
                                     testCase.testData.sat_num_points);
                testCase.verifyEqual(size(compressed(dir).rel_perm_gas, 2), ...
                                     testCase.testData.sat_num_points);
                
                % Verify mapping dimensions (1, subset_len) per direction
                testCase.verifySize(compressed(dir).mapping, [1, testCase.testData.subset_len]);
            end
        end

        function testOutputStructure(testCase)
            % Check all required fields present with correct types
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            % Check struct array structure: (3,1)
            testCase.verifyEqual(size(compressed), [3, 1]);
            testCase.verifyTrue(isstruct(compressed));

            % Check per-direction fields and types
            for dir = 1:3
                % Check required fields exist
                testCase.verifyTrue(isfield(compressed(dir), 'capillary_pressure'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_wat'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_gas'));
                testCase.verifyTrue(isfield(compressed(dir), 'mapping'));

                % Check field types
                testCase.verifyClass(compressed(dir).capillary_pressure, 'double');
                testCase.verifyClass(compressed(dir).rel_perm_wat, 'double');
                testCase.verifyClass(compressed(dir).rel_perm_gas, 'double');
                testCase.verifyClass(compressed(dir).mapping, 'uint32');

                % Check dimensions
                n_compressed_dir = size(compressed(dir).capillary_pressure, 1);
                testCase.verifySize(compressed(dir).capillary_pressure, [n_compressed_dir, testCase.testData.sat_num_points]);
                testCase.verifySize(compressed(dir).rel_perm_wat, [n_compressed_dir, testCase.testData.sat_num_points]);
                testCase.verifySize(compressed(dir).rel_perm_gas, [n_compressed_dir, testCase.testData.sat_num_points]);
                testCase.verifySize(compressed(dir).mapping, [1, testCase.testData.subset_len]);
            end
        end

        function testMappingValidity(testCase)
            % Ensure mapping indices are valid per direction
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            % Validate per-direction mapping ranges
            for dir = 1:3
                n_compressed_dir = size(compressed(dir).capillary_pressure, 1);
                mapping_dir = compressed(dir).mapping;
                
                % Mapping dimensions: (1, subset_len) per direction
                testCase.verifySize(mapping_dir, [1, testCase.testData.subset_len]);
            % Verify error measurement with per-direction compression
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            errors = measure_compression_error(testCase.originalStruct, compressed);

            % Verify error struct has required fields (all per-direction now)
            testCase.verifyTrue(isfield(errors, 'mse_capillary_pressure'));
            testCase.verifyTrue(isfield(errors, 'mse_rel_perm_wat'));
            testCase.verifyTrue(isfield(errors, 'mse_rel_perm_gas'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_pc'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_krw'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_krg'));

            % Verify all error fields are (3,1) vectors
            testCase.verifySize(errors.mse_capillary_pressure, [3, 1]);
            testCase.verifySize(errors.mse_rel_perm_wat, [3, 1]);
            testCase.verifySize(errors.mse_rel_perm_gas, [3, 1]);
            testCase.verifySize(errors.max_abs_error_pc, [3, 1]);
            testCase.verifySize(errors.max_abs_error_krw, [3, 1]);
            testCase.verifySize(errors.max_abs_error_krg, [3, 1]);

            % Verify all errors are non-negative and finite
            testCase.verifyTrue(all(errors.mse_capillary_pressure >= 0));
            testCase.verifyTrue(all(errors.mse_rel_perm_wat >= 0));
            testCase.verifyTrue(all(errors.mse_rel_perm_gas >= 0));
            testCase.verifyTrue(all(isfinite(errors.mse_capillary_pressure)));
            testCase.verifyTrue(all(isfinite(errors.mse_rel_perm_wat)));
            testCase.verifyTrue(all(isfinite(errors.mse_rel_perm_gas)));
        end

        function testDimensionValidation(testCase)
            % Test that dimension mismatches are caught

            % Mismatch in first dimension
            bad_krw = testCase.testData.rel_perm_wat(1:end-1, :, :);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                bad_krw, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params), ...
                'MATLAB:validation:UnableToConvert');

            % Mismatch in saturation points
            bad_pc = testCase.testData.capillary_pressure(:, 1:end-5);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                bad_pc, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params), ...
                'MATLAB:validation:UnableToConvert');

            % Wrong number of directions
            bad_krg = testCase.testData.rel_perm_gas(:, 1:2, :);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                bad_krg, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params), ...
                'MATLAB:validation:UnableToConvert');
        end

        function testErrorMeasurementValidation(testCase)
            % Test that error measurement validates inputs properly
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            % Missing field in original
            bad_original = struct('capillary_pressure', testCase.testData.capillary_pressure);
            testCase.verifyError(@() measure_compression_error(bad_original, compressed), ...
                'measure_compression_error:MissingField');

            % Missing field in compressed (remove from first direction)
            bad_compressed = compressed;
            bad_compressed(1) = rmfield(bad_compressed(1), 'mapping');
            testCase.verifyError(@() measure_compression_error(testCase.originalStruct, bad_compressed), ...
                'measure_compression_error:MissingField');
        end

        function testOutputInvariants(testCase)
            % Verify output validation catches invariant violations
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas, ...
                testCase.testData.porosity, ...
                testCase.testData.permeability, ...
                testCase.testData.params);

            % Verify struct array structure (3,1)
            testCase.verifyEqual(size(compressed), [3, 1]);
            testCase.verifyTrue(isstruct(compressed));

            % Verify per-direction invariants
            for dir = 1:3
                % Verify output has all required fields
                testCase.verifyTrue(isfield(compressed(dir), 'capillary_pressure'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_wat'));
                testCase.verifyTrue(isfield(compressed(dir), 'rel_perm_gas'));
                testCase.verifyTrue(isfield(compressed(dir), 'mapping'));
                
                n_compressed_dir = size(compressed(dir).capillary_pressure, 1);
                
                % Verify mapping is consistent with per-direction tables
                max_mapping_dir = max(compressed(dir).mapping);
                testCase.verifyLessThanOrEqual(max_mapping_dir, n_compressed_dir);

                % Verify saturation points are preserved
                testCase.verifyEqual(size(compressed(dir).capillary_pressure, 2), ...
                                     testCase.testData.sat_num_points);
                testCase.verifyEqual(size(compressed(dir).rel_perm_wat, 2), ...
                                     testCase.testData.sat_num_points);
                testCase.verifyEqual(size(compressed(dir).rel_perm_gas, 2), ...
                                     testCase.testData.sat_num_points);

                % Verify output arrays are finite and real
                testCase.verifyTrue(all(isfinite(compressed(dir).capillary_pressure), 'all'));
                testCase.verifyTrue(all(isreal(compressed(dir).capillary_pressure), 'all'));
                testCase.verifyTrue(all(isfinite(compressed(dir).rel_perm_wat), 'all'));
                testCase.verifyTrue(all(isreal(compressed(dir).rel_perm_wat), 'all'));
                testCase.verifyTrue(all(isfinite(compressed(dir).rel_perm_gas), 'all'));
                testCase.verifyTrue(all(isreal(compressed(dir).rel_perm_gas), 'all'));
            perm = testCase.testData.permeability;

            % Compute J-function using CapPressure.inv_lj() (reference)
            leverett_j_ref = cap_press_obj.inv_lj(pc, poro, perm);

            % Compute J-function manually (as done in compress_tables)
            perm_effective = sum(perm .* cap_press_obj.perm_weights, 2);
            leverett_j_manual = pc ./ cap_press_obj.mult .* sqrt(perm_effective ./ poro);

            % Verify they match
            testCase.verifyEqual(leverett_j_manual, leverett_j_ref, 'RelTol', 1e-12);

            % Verify J-function values are physically reasonable
            % Typically J ~ 0-10 for reservoir conditions
            testCase.verifyTrue(all(isfinite(leverett_j_ref), 'all'));
            testCase.verifyTrue(all(leverett_j_ref >= 0, 'all'), ...
                'J-function should be non-negative for Pc >= 0');
        end

        function testDeduplication(testCase)
            % Test per-direction deduplication with various tolerances

            % Create dataset with known duplicates per direction
            n_unique = 5;
            n_total = 20;
            subset_len = n_total;
            sat_num_points = testCase.testData.sat_num_points;

            % Generate unique base curves
            pc_unique = zeros(n_unique, sat_num_points);
            krw_unique = zeros(n_unique, 3, sat_num_points);
            krg_unique = zeros(n_unique, 3, sat_num_points);

            sw = linspace(0.12, 1.0, sat_num_points);
            for i = 1:n_unique
                % Unique capillary pressure curves
                amplitude = 1e5 * (1 + 0.2*i);
                pc_unique(i, :) = amplitude * (sw .^ (-2.0 - 0.1*i));

                % Unique rel perm curves per direction
                for dir = 1:3
                    nw = 2.0 + 0.1*i + 0.05*dir;
                    krw_max = 0.7 + 0.02*i;
                    sw_norm = (sw - sw(1)) / (1 - sw(1));
                    krw_unique(i, dir, :) = krw_max * (sw_norm .^ nw);

                    ng = 2.0 + 0.1*i - 0.05*dir;
                    krg_max = 0.85 + 0.01*i;
                    krg_unique(i, dir, :) = krg_max * ((1 - sw_norm) .^ ng);
                end
            end

            % Replicate to create exact duplicates
            pc_test = repmat(pc_unique, ceil(n_total/n_unique), 1);
            pc_test = pc_test(1:n_total, :);
            krw_test = repmat(krw_unique, ceil(n_total/n_unique), 1, 1);
            krw_test = krw_test(1:n_total, :, :);
            krg_test = repmat(krg_unique, ceil(n_total/n_unique), 1, 1);
            krg_test = krg_test(1:n_total, :, :);

            % Generate consistent porosity/permeability to enable exact J-function matching
            % Use constant values for duplicate cells to ensure J-function matches exactly
            poro_base = [0.20; 0.22; 0.21; 0.23; 0.19];
            perm_base = [
                100 * milli() * darcy(), 100 * milli() * darcy(), 50 * milli() * darcy();
                110 * milli() * darcy(), 110 * milli() * darcy(), 55 * milli() * darcy();
                105 * milli() * darcy(), 105 * milli() * darcy(), 52 * milli() * darcy();
                120 * milli() * darcy(), 120 * milli() * darcy(), 60 * milli() * darcy();
                95 * milli() * darcy(), 95 * milli() * darcy(), 48 * milli() * darcy()
            ];

            poro_test = repmat(poro_base, ceil(n_total/n_unique), 1);
            poro_test = poro_test(1:n_total);
            perm_test = repmat(perm_base, ceil(n_total/n_unique), 1);
            perm_test = perm_test(1:n_total, :);

            idx_test = 1:n_total;

            % Test 1: Exact deduplication (tolerance = 0)
            compressed = compress_tables(idx_test, pc_test, krw_test, krg_test, ...
                poro_test, perm_test, testCase.testData.params, ...
                duplicate_tolerance=0);

            % Verify cell array structure
            testCase.verifyTrue(iscell(compressed.capillary_pressure));
            testCase.verifyEqual(numel(compressed.capillary_pressure), 3);
            testCase.verifySize(compressed.mapping, [3, n_total]);

            % Verify per-direction compression
            for dir = 1:3
                n_compressed_dir = size(compressed.capillary_pressure{dir}, 1);

                % Should compress to ~n_unique per direction
                testCase.verifyLessThanOrEqual(n_compressed_dir, n_unique + 2, ...
                    sprintf('Direction %d should compress to ~%d tables', dir, n_unique));

                % Verify mapping validity for this direction
                mapping_dir = compressed.mapping(dir, :);
                testCase.verifyTrue(all(mapping_dir >= 1));
                testCase.verifyTrue(all(mapping_dir <= n_compressed_dir));
            end

            % Verify reconstruction errors are minimal
            errors = measure_compression_error(...
                struct('capillary_pressure', pc_test, 'rel_perm_wat', krw_test, 'rel_perm_gas', krg_test), ...
                compressed);

            testCase.verifyLessThan(max(errors.mse_capillary_pressure), 1e-10, ...
                'Capillary pressure reconstruction error should be very small with exact duplicates');
            testCase.verifyLessThan(max(errors.mse_rel_perm_wat), 1e-10, ...
                'Water rel perm reconstruction error should be very small');
            testCase.verifyLessThan(max(errors.mse_rel_perm_gas), 1e-10, ...
                'Gas rel perm reconstruction error should be very small');

            % Test 2: With tolerance (should compress more aggressively)
            compressed_tol = compress_tables(idx_test, pc_test, krw_test, krg_test, ...
                poro_test, perm_test, testCase.testData.params, ...
                duplicate_tolerance=1e-8);

            % Verify tolerance allows more compression
            for dir = 1:3
                n_compressed_dir = size(compressed.capillary_pressure{dir}, 1);
                n_compressed_tol_dir = size(compressed_tol.capillary_pressure{dir}, 1);
                testCase.verifyLessThanOrEqual(n_compressed_tol_dir, n_compressed_dir, ...
                    sprintf('Direction %d: larger tolerance should compress more or equal', dir));
            end
        end
    end
end
