function [dpc_dsw] = calc_capillary_pressure_deriv(sw,poro,perm,sw_barrier,lambda,contact_angle,surface_tension)
arguments
    sw (1,1) double
    poro double
    perm double
    sw_barrier (1,1) double
    lambda (1,1) double
    contact_angle (1,1) double
    surface_tension (1,1) double
end
if sw <= sw_barrier
    dpc_dsw = Inf;
    return;
end
sw = min(sw,1);

    function dj_dsw = calc_leverett_j_deriv(sw,sw_barrier,lambda)
        pow = (-1/lambda);
        mult = (1-sw_barrier)^(-pow);
        dj_dsw = mult * pow * (sw-sw_barrier)^(pow-1);
    end

dpc_dsw = cos(contact_angle) * surface_tension * calc_leverett_j_deriv(sw,sw_barrier,lambda) * sqrt(poro./perm);
end
