classdef CodeGenMex < handle
    properties
        cfg
        built_func = {}
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
            if isempty(self.built_func)
                self.built_func{1} = func;
            else
                self.built_func{end+1} = func;
            end
        end

        function self = build(self)
            self = self.build_with({"-o","upscale"},'upscale');

            % NOTE: fminunc not supported
            % self = self.build_with({"-o","fit_LET"},'fit_LET'); 
        end

        function self = clear(self)
            clear mex; %#ok<CLMEX>
            for i = 1:numel(self.built_func)
                delete([self.built_func{i},'.mex*']);
            end
            self.built_func = {};
        end
    end
end
