function sw = calc_capillary_pressure_inv(pc,poro,perm,sw_barrier,lambda,contact_angle,surface_tension)
arguments
    pc (1,1) double
    poro double
    perm double
    sw_barrier (1,1) double
    lambda (1,1) double
    contact_angle (1,1) double
    surface_tension (1,1) double
end

leverett_j = pc ./ (cos(contact_angle) * surface_tension * sqrt(poro./perm));

    function sw = calc_leverett_j_inv(leverett_j,sw_barrier,lambda)
        sw_normalized = leverett_j.^(-lambda);
        sw = sw_normalized .* (1-sw_barrier) + sw_barrier;
    end

sw = calc_leverett_j_inv(leverett_j,sw_barrier,lambda);

end
