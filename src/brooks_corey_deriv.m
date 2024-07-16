function dpc_dsw = brooks_corey_deriv(sw,sw_resid,p_entry,lambda)
A = p_entry .* (1-sw_resid).^(1/lambda);
B = sw_resid;
C = -(1/lambda);
dpc_dsw = A.*C .* (sw - B).^(C-1);
end