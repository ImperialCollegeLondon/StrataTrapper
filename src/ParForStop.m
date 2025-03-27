classdef ParForStop < handle
    %PARFORSTOP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        signal
        value
    end
    
    methods
        function self = ParForStop()
            self.value = false;
            self.signal = parallel.pool.DataQueue;
            
            afterEach(self.signal, @(~) self.stop());
        end
        function stop(self)
            self.value = true;
        end
    end
end

