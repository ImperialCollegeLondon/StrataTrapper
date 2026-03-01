classdef StrataTrapped
    properties
        Property1
    end

    methods
        function obj = StrataTrapped(inputArg1)
            obj.Property1 = inputArg1^2;
            disp(obj.Property1);

        end

        function Self = quantize(self,args);
    end
end
