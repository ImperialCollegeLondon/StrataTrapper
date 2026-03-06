classdef QuantizeOptions
    properties
        use_total_mobility (1,1) logical = false
        duplicate_threshold (:,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = []
        dim_reduction (1,1) DimReduction = DimReduction.None
        num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
        % NOTE: name-value arguments as per official kmeans documentation
        kmeans = {'OnlinePhase','off','MaxIter',1000,'Display','off','Distance','sqeuclidean',...
            'EmptyAction','drop','Start','plus'} 
    end
end