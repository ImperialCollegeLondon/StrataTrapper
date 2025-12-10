
mexcuda -setup C++;

cfg = coder.gpuConfig("mex");
cfg.InlineBetweenMathWorksFunctions = "Speed";
cfg.InlineBetweenUserAndMathWorksFunctions = "Speed";
cfg.InlineBetweenUserFunctions = "Speed";
cfg.NumberOfCpuThreads = 32;
cfg.SIMDAcceleration = "Full";
cfg.GpuConfig.CompilerFlags = "-allow-unsupported-compiler";
cfg.GpuConfig.SafeBuild = true;
cfg.GpuConfig.SelectCudaDevice = 0;
cfg.UsePrecompiledLibraries = "Prefer";
cfg.CppNamespace = "strata_trapper";

% NOTE: then `codegen upscale -config cfg`