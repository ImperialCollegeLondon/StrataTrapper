function sum= add_mex_test(a,b)
arguments (Input)
    a (1,1) int32
    b (1,1) int32
end

arguments (Output)
    sum (1,1) int32
end
sum = a+b;
end
