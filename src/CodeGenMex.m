classdef CodeGenMex < handle
    properties
        cfg
        built_func
    end

    methods
        function self = CodeGenMex()
            mex -setup C++
        end

        function self = config(self)
            self.cfg = coder.config("mex");

            self.cfg.Name = "strata_trapper-mex";
            self.cfg.Description = "MEX-compiled StrataTrapper functions";

            self.cfg.TargetLang = "C++";
            self.cfg.CppNamespace = "strata_trapper";

            self.cfg.InlineBetweenUserFunctions = "Speed";
            self.cfg.InlineBetweenUserAndMathWorksFunctions = "Speed";
            self.cfg.InlineBetweenMathWorksFunctions = "Speed";

            self.cfg.NumberOfCpuThreads = 32;
            self.cfg.SIMDAcceleration = "Full";
            self.cfg.OptimizeReductions = true;
            self.cfg.EnableAutoParallelization = false;
            self.cfg.EnableOpenMP = false;
        end

        
        function self = build_with(self,options,func)
            codegen("-config",self.cfg,options{:},func);
            self.built_func = func;
        end

        function self = build(self)
            self = self.build_with({"-o","upscale"},'upscale');
        end

        function self = clear(self)
            clear mex; %#ok<CLMEX>
            delete([self.built_func,'.mex*']);
            self.built_func = [];
        end
    end
end
