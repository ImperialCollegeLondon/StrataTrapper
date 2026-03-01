function [f] = gen_corr_field(dr,dims,corr_lens,dist)
arguments
    dr        (1,3) double
    dims      (1,3) uint32
    corr_lens (1,3) double
    dist      = @(N) randn(N)
end
x = linspace(-0.5,0.5,dims(1)).*dr(1)*(1 - 1/double(dims(1)));
y = linspace(-0.5,0.5,dims(2)).*dr(2)*(1 - 1/double(dims(2)));
z = linspace(-0.5,0.5,dims(3)).*dr(3)*(1 - 1/double(dims(3)));

[X,Y,Z] = meshgrid(x,y,z);

X = permute(X,[2 1 3]);
Y = permute(Y,[2 1 3]);
Z = permute(Z,[2 1 3]);

D = dist(dims.*2-1);

% Gaussian filter

    function out = divide(a,b)
        out = a./b;
        out(a==0)=0;
    end

K = divide(X,corr_lens(1)).^2 + divide(Y,corr_lens(2)).^2 + divide(Z,corr_lens(3)).^2;
K = exp(K.*(-2));
K = K./sum(K(:));

f = convn(D,K,'valid');

end

