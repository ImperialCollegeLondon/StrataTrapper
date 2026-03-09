classdef QuantizeOptions
    properties
        fit_parametric (1,1) logical = false
        fit_total_mobility (1,1) logical = false
        num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive} = []
        duplicate_threshold (1,1) double {mustBeNonnegative, mustBeScalarOrEmpty} = 0.0
        num_quants (:,1) uint32 {mustBeScalarOrEmpty, mustBePositive} = []
        
        % name-value arguments as per official kmeans documentation
        kmeans = {'OnlinePhase','on','MaxIter',1000,'Display','off','Distance','sqeuclidean',...
            'EmptyAction','drop','Start','plus'} 

        num_par_workers = 0;
    end
end
