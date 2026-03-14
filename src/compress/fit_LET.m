function x = fit_LET(krw,krg,sw)
arguments
    krw (1,:) double
    krg (1,:) double
    sw (1,:) double
end

x0 = [0,0,1,1,1,1,1,1,1,1];

krwg = [krw,krg];
resid_fun = @(x) let_residual(krwg,sw,x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10));

options.Display = "off";
options.TolFun = 1e-16;
options.TolX = 1e-16;

[x,~,~,~] = fminsearch(resid_fun,x0,options);

end


function resid = let_residual(krwg,sw,sw_irr,sg_cr,kw_max,kg_max,L_w,E_w,T_w,L_g,E_g,T_g)
    resid = norm(krwg-calc_let_wg(sw,sw_irr,sg_cr,kw_max,kg_max,L_w,E_w,T_w,L_g,E_g,T_g));
end
