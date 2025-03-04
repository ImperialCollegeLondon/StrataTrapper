function [perf] = compute_performance(perf)
perf.multi_MHz = double(perf.num_sat * sum(perf.num_sub.^3)) / double(perf.elapsed) * 10^(-6);
perf.single_MHz = perf.multi_MHz / double(perf.num_workers);
end

