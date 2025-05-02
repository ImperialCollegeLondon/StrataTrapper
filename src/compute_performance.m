function [perf] = compute_performance(perf,k)
perf.k = k;

perf = structfun(@(field)double(field),perf,'UniformOutput',false);

numerator = (2*perf.num_sat+1) * perf.num_sub.^k;
perf.single = numerator ./ perf.elapsed;

perf.single_avg = sum(numerator) / sum(perf.elapsed);

perf.total = perf.single_avg * perf.num_workers;
end
