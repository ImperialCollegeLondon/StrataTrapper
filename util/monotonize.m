function y = monotonize(x,y,direction)
    for i = 2:length(x)
        if (y(i) - y(i-1)) * direction >= 0
            continue;
        end
        y(i) = y(i-1);
    end
end
