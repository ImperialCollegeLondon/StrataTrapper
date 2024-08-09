classdef TableFunction
    properties
        data (:,2) double
    end

    methods
        function obj = TableFunction(data)
            obj.data = data;
        end

        function out = func(obj,arg)
            out = interp1(obj.data(:,1), obj.data(:,2), arg, "linear",'extrap');
        end

        function out = inv(obj,arg)
            out = interp1(obj.data(:,2), obj.data(:,1), arg, "linear",'extrap');
        end

        function out = deriv(obj,arg)
            out = compute_derivative(obj.data(:,1), obj.data(:,2), arg);
        end
    end
end

function df = compute_derivative(x, f, x0)
    % x: vector of x values
    % f: vector of f(x) values
    % x0: point at which to compute the derivative

    % Find the index of the closest point to x0
    [~, idx] = min(abs(x - x0));

    % Check if we can use central difference
    if idx > 1 && idx < length(x)
        % Central difference formula
        h = x(idx+1) - x(idx-1);
        df = (f(idx+1) - f(idx-1)) / h;
    elseif idx == 1
        % Forward difference formula
        h = x(2) - x(1);
        df = (f(2) - f(1)) / h;
    else
        % Backward difference formula
        h = x(end) - x(end-1);
        df = (f(end) - f(end-1)) / h;
    end
end
