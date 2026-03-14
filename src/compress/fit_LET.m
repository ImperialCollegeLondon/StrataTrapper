function LET = fit_LET(sn,kr,k_max)
arguments
    sn (1,:) double
    kr (1,:) double
    k_max (1,1) double
end

resid_fun = @(x) let_residual(kr,sn,k_max,x(1),x(2),x(3));

options.Display = "off";
options.TolFun = 1e-16;
options.TolX = 1e-16;
LET_init_approx = [1,1,1];

LET = fminunc(resid_fun,LET_init_approx,options);

end

function resid_norm = let_residual(kr,sn,k_max,L,E,T)
kr_fit = calc_let_normalized(sn,k_max,L,E,T);
resid = kr_fit - kr;
resid_norm = norm(resid);
end