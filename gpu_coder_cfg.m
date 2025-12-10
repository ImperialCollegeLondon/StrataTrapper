
mex -setup cpp;
mexcuda -setup cpp;
%%
cfg = coder.gpuConfig("mex");
cfg.InlineBetweenMathWorksFunctions = "Speed";
cfg.InlineBetweenUserAndMathWorksFunctions = "Speed";
cfg.InlineBetweenUserFunctions = "Speed";
cfg.NumberOfCpuThreads = 32;
cfg.SIMDAcceleration = "Full";
cfg.GpuConfig.CompilerFlags = "-allow-unsupported-compiler -D_ALLOW_COMPILER_AND_STL_VERSION_MISMATCH";
cfg.GpuConfig.SafeBuild = true;
cfg.GpuConfig.SelectCudaDevice = 0;
cfg.UsePrecompiledLibraries = "Prefer";
cfg.CppNamespace = "strata_trapper";

% NOTE: then `codegen upscale -config cfg`
%%
gpuEnvObj = coder.gpuEnvConfig;
gpuEnvObj.BasicCodegen  = 1;
gpuEnvObj.BasicCodeexec = 1;
results = coder.checkGpuInstall(gpuEnvObj,'gpu');

%%
mex -setup C++ -client engine

%% 
% Default compiler for normal mex
mex -setup C++
% Default compiler for GPU Coder client
mexcuda -setup C++
%%
mex_selected =  mex.getCompilerConfigurations('C++','Selected');
mex_installed = mex.getCompilerConfigurations('C++','Installed');
mex_supported =  mex.getCompilerConfigurations('Any','Supported');

%%
gpu_env_config = coder.gpuEnvConfig;
gpu_env_config.BasicCodegen  = 1;
gpu_env_config.BasicCodeexec = 1;   % optional but recommended

check_gpu_install = coder.checkGpuInstall(gpu_env_config);

%%
cfg = coder.config("mex");
cfg.TargetLang = "C++";
cfg.GenerateReport = true;
cfg.NumberOfCpuThreads = 72;
cfg.SIMDAcceleration = "Full";
cfg.CppNamespace = "strata_trapper";
cfg.OptimizeReductions = true;
cfg.EnableAutoParallelization = true;
cfg.EnableOpenMP = true;
cfg.Name