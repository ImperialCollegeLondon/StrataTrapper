function [pc] = calc_capillary_pressure(sw,poro,perm,sw_barrier,lambda,contact_angle,surface_tension)
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
    pc = Inf;
    return;
end
sw = min(sw,1);

    function leverett_j = calc_leverett_j(sw,sw_barrier,lambda)
        sw_normalized = (sw-sw_barrier)/(1-sw_barrier);
        leverett_j = sw_normalized^(-1/lambda);
    end

pc = cos(contact_angle) * surface_tension * calc_leverett_j(sw,sw_barrier,lambda) * sqrt(poro./perm);
end
