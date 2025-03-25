function output = func(value,n)
arguments (Input)
    value       double
    n     (1,1) {mustBeInteger}
end
    output = value.^double(n);
end
