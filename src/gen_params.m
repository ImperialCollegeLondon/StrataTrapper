function [params] = gen_params()
params = struct(...
    'poro',      struct(...
        'mean',     0.23,...
        'std_dev',  0.049,...
        'corr_lens',[200,20,0.1].*meter() ...
    ),...
    'perm_corr', @(poro) 10.^(log10(poro).*4.19+5.17) * milli() * darcy(),... NOTE: produces milli Darcy
    'capil',     struct(...
        'lambda',         1.75, ...
        'angle',          deg2rad(37), ...
        'tension',        36 * milli() * newton() / meter(), ...
        'pres_entry',     10 * kilo() * pascal(), ...
        'sw_barrier',     0 ...
    ),...
    'rel_perm', struct('sw_resid', 0.01)...
    );

params.capil.pres_func = @(sw, entry_pressure) brooks_corey(sw, params.capil.sw_barrier, entry_pressure, params.capil.lambda);

params.capil.pres_func_inv = @(pc, entry_pressure) brooks_corey_inv(pc, params.capil.sw_barrier, entry_pressure, params.capil.lambda);

params.capil.pres_deriv = @(sw, entry_pressure) brooks_corey_deriv(sw, params.capil.sw_barrier, entry_pressure,params.capil.lambda);

params.capil.j_entry = params.capil.pres_entry / (sqrt(params.poro.mean/params.perm_corr(params.poro.mean)) .* cos(params.capil.angle) .* params.capil.tension);

params.rel_perm.wat_func = @(sw) max((sw - params.rel_perm.sw_resid)./(1 - params.rel_perm.sw_resid),0);
params.rel_perm.gas_func = @(sg) min(sg./(1 - params.rel_perm.sw_resid),1);
end

function pc = brooks_corey(sw,sw_resid,p_entry,lambda)
if sw <= sw_resid
    pc = Inf;
    return;
end
sw = min(sw,1);
pc = p_entry .* ((1-sw_resid)./(sw-sw_resid)).^(1/lambda);
end

function dpc_dsw = brooks_corey_deriv(sw,sw_resid,p_entry,lambda)
A = p_entry .* (1-sw_resid).^(1/lambda);
B = sw_resid;
C = -(1/lambda);
dpc_dsw = A.*C .* (sw - B).^(C-1);
end