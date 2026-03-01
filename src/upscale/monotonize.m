function y = monotonize(x,y,direction)
    for i = 2:(length(x)-1)
        if y(i) * direction >= y(i-1) * direction
            continue;
        end
        % interpolate
        y(i) = (y(end) - y(i-1))/(x(end) - x(i-1))*(x(i) - x(i-1))+y(i-1);
    end
end
