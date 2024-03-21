function entry_pressure = calc_entry_pressure(poro, perm, j_entry, contact_angle, surface_tension)
arguments
    poro                  double
    perm                  double
    j_entry         (1,1) double
    contact_angle   (1,1) double
    surface_tension (1,1) double
end

entry_pressure = j_entry * cos(contact_angle) * surface_tension * sqrt(poro./perm);
end