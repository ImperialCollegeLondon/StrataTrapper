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

            % Create original struct for error measurement tests
            testCase.originalStruct = struct('capillary_pressure', pc_base, ...
                                             'rel_perm_wat', krw, ...
                                             'rel_perm_gas', krg);
        end
    end

    methods(Test)
        function testPassThrough(testCase)
            % Verify stub returns identity mapping with zero error
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            % Verify pass-through (no actual compression yet)
            testCase.verifyEqual(size(compressed.capillary_pressure, 1), ...
                                 testCase.testData.subset_len);
            testCase.verifyEqual(compressed.mapping, uint32(1:testCase.testData.subset_len));

            % Verify data unchanged
            testCase.verifyEqual(compressed.capillary_pressure, ...
                                 testCase.testData.capillary_pressure);
            testCase.verifyEqual(compressed.rel_perm_wat, ...
                                 testCase.testData.rel_perm_wat);
            testCase.verifyEqual(compressed.rel_perm_gas, ...
                                 testCase.testData.rel_perm_gas);
        end

        function testOutputStructure(testCase)
            % Check all required fields present with correct types
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            % Check required fields exist
            testCase.verifyTrue(isfield(compressed, 'capillary_pressure'));
            testCase.verifyTrue(isfield(compressed, 'rel_perm_wat'));
            testCase.verifyTrue(isfield(compressed, 'rel_perm_gas'));
            testCase.verifyTrue(isfield(compressed, 'mapping'));

            % Check field types
            testCase.verifyClass(compressed.capillary_pressure, 'double');
            testCase.verifyClass(compressed.rel_perm_wat, 'double');
            testCase.verifyClass(compressed.rel_perm_gas, 'double');
            testCase.verifyClass(compressed.mapping, 'uint32');

            % Check dimensions
            testCase.verifySize(compressed.rel_perm_wat, ...
                                [size(compressed.capillary_pressure, 1), 3, testCase.testData.sat_num_points]);
            testCase.verifySize(compressed.rel_perm_gas, ...
                                [size(compressed.capillary_pressure, 1), 3, testCase.testData.sat_num_points]);
        end

        function testMappingValidity(testCase)
            % Ensure mapping indices are valid
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            n_compressed = size(compressed.capillary_pressure, 1);

            % All mapping values must be in range [1, n_compressed]
            testCase.verifyTrue(all(compressed.mapping >= 1));
            testCase.verifyTrue(all(compressed.mapping <= n_compressed));

            % Mapping length must match original table count
            testCase.verifyEqual(length(compressed.mapping), testCase.testData.subset_len);
        end

        function testErrorMeasurement(testCase)
            % Verify MSE = 0 for identity case
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            errors = measure_compression_error(testCase.originalStruct, compressed);

            % Verify error struct has required fields
            testCase.verifyTrue(isfield(errors, 'mse_capillary_pressure'));
            testCase.verifyTrue(isfield(errors, 'mse_rel_perm_wat'));
            testCase.verifyTrue(isfield(errors, 'mse_rel_perm_gas'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_pc'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_krw'));
            testCase.verifyTrue(isfield(errors, 'max_abs_error_krg'));

            % For identity mapping, all errors should be zero (or very close to machine precision)
            testCase.verifyLessThan(errors.mse_capillary_pressure, 1e-20);
            testCase.verifyLessThan(max(errors.mse_rel_perm_wat), 1e-20);
            testCase.verifyLessThan(max(errors.mse_rel_perm_gas), 1e-20);
            testCase.verifyLessThan(errors.max_abs_error_pc, 1e-10);
            testCase.verifyLessThan(max(errors.max_abs_error_krw), 1e-10);
            testCase.verifyLessThan(max(errors.max_abs_error_krg), 1e-10);
        end

        function testDimensionValidation(testCase)
            % Test that dimension mismatches are caught

            % Mismatch in first dimension
            bad_krw = testCase.testData.rel_perm_wat(1:end-1, :, :);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                bad_krw, ...
                testCase.testData.rel_perm_gas), ...
                'compress_tables:DimensionMismatch');

            % Mismatch in saturation points
            bad_pc = testCase.testData.capillary_pressure(:, 1:end-5);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                bad_pc, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas), ...
                'compress_tables:DimensionMismatch');

            % Wrong number of directions
            bad_krg = testCase.testData.rel_perm_gas(:, 1:2, :);
            testCase.verifyError(@() compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                bad_krg), ...
                'compress_tables:InvalidDimensions');
        end

        function testErrorMeasurementValidation(testCase)
            % Test that error measurement validates inputs properly
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            % Missing field in original
            bad_original = struct('capillary_pressure', testCase.testData.capillary_pressure);
            testCase.verifyError(@() measure_compression_error(bad_original, compressed), ...
                'measure_compression_error:MissingField');

            % Missing field in compressed
            bad_compressed = rmfield(compressed, 'mapping');
            testCase.verifyError(@() measure_compression_error(testCase.originalStruct, bad_compressed), ...
                'measure_compression_error:MissingField');
        end

        function testOutputInvariants(testCase)
            % Verify output validation catches invariant violations
            compressed = compress_tables(testCase.testData.idx, ...
                testCase.testData.capillary_pressure, ...
                testCase.testData.rel_perm_wat, ...
                testCase.testData.rel_perm_gas);

            % Verify output has all required fields
            testCase.verifyTrue(isfield(compressed, 'capillary_pressure'));
            testCase.verifyTrue(isfield(compressed, 'rel_perm_wat'));
            testCase.verifyTrue(isfield(compressed, 'rel_perm_gas'));
            testCase.verifyTrue(isfield(compressed, 'mapping'));

            % Verify mapping is consistent with tables
            n_compressed = size(compressed.capillary_pressure, 1);
            testCase.verifyEqual(max(compressed.mapping), uint32(n_compressed));
            testCase.verifyEqual(length(compressed.mapping), testCase.testData.subset_len);

            % Verify saturation points are preserved
            testCase.verifyEqual(size(compressed.capillary_pressure, 2), ...
                                 size(compressed.rel_perm_wat, 3));
            testCase.verifyEqual(size(compressed.capillary_pressure, 2), ...
                                 size(compressed.rel_perm_gas, 3));

            % Verify rel perms have 3 directions
            testCase.verifyEqual(size(compressed.rel_perm_wat, 2), 3);
            testCase.verifyEqual(size(compressed.rel_perm_gas, 2), 3);

            % Verify output arrays are finite and real
            testCase.verifyTrue(all(isfinite(compressed.capillary_pressure), 'all'));
            testCase.verifyTrue(all(isreal(compressed.capillary_pressure), 'all'));
            testCase.verifyTrue(all(isfinite(compressed.rel_perm_wat), 'all'));
            testCase.verifyTrue(all(isreal(compressed.rel_perm_wat), 'all'));
            testCase.verifyTrue(all(isfinite(compressed.rel_perm_gas), 'all'));
            testCase.verifyTrue(all(isreal(compressed.rel_perm_gas), 'all'));
        end
    end
end
