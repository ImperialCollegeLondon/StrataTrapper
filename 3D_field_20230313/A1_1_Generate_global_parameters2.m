%% Petrophysical parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% change input file
press_av = 1000*mean(z_vec)*g_accel*1e-5; %Average hydrostatic pressure
perm_multiplier = 1/1.01325E+15; %mDarcy to m^2 conversion
tol = 1e-4; %Tolerance for dens calc below
err = 1.0;  %initial error
%Generate average pressure in the domain from density and temp of the brine, Have to iterate, as density function of these too. 
while err > tol
    rho_w = griddata(One_M_NaCL_temp_press_density(:,1),One_M_NaCL_temp_press_density(:,2),One_M_NaCL_temp_press_density(:,3),temp_av,press_av, 'linear');
    press_new = rho_w*mean(z_vec)*g_accel*1e-5;
    err = (press_new - press_av)./press_av;
    press_av = press_new;
end
%calc viscosity (mu) and density (rho) and surface tension of the fluids from table data. All quantities are SI units.
mu_g = griddata(CO2_temp_press_density_viscosity(:,1),CO2_temp_press_density_viscosity(:,2),CO2_temp_press_density_viscosity(:,4),temp_av,press_av, 'linear');
mu_w = griddata(One_M_NaCL_temp_press_viscosity(:,1),One_M_NaCL_temp_press_viscosity(:,2),One_M_NaCL_temp_press_viscosity(:,3),temp_av,press_av, 'linear');
rho_g = griddata(CO2_temp_press_density_viscosity(:,1),CO2_temp_press_density_viscosity(:,2),CO2_temp_press_density_viscosity(:,3),temp_av,press_av, 'linear');
surface_tension = griddata(CO2_brine_temp_press_IFT(:,1),CO2_brine_temp_press_IFT(:,2),CO2_brine_temp_press_IFT(:,3), temp_av, press_av, 'linear');

%% statistic information %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A_input_report %These are all from the K40 reports

por_av = fporosity(z_vec);
por_var = (por_std).^2; %Variance of porosity
por_av_start = por_av(1); %Top porosity
por_av_domain = mean(por_av);
perm_av = fpermeability(por_av); %perm in mD
perm_av_domain = mean(perm_av);
pe = (jsw1/1000)*sqrt(por_av_domain./((perm_av_domain)*perm_multiplier))*(surface_tension*0.001*cos(angle*pi/180)); %Nele's version
jsw_end = jsw1*(((sw_end) - swirr)/(1-swirr)).^(-1/lambda);
pc_end = (jsw_end/1000)*sqrt(por_av_domain./((perm_av_domain)*perm_multiplier))*(surface_tension*0.001*cos(angle*pi/180)); % I removed the exponent - dont relaly get

%well perforation for fine and upscaled wells,
well_perforations = Nz_sub;
well_perforations_x = Nx_sub;
well_perforations_fine = 1;

%End of base input paramters

%% fine scale %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%Generate the fine scale saturation, rel perm and Pc functions. These are
%done with chierici (or VL) and brooks-corey functions respectively.
%sw_aim = (sw_end:0.02175/n_intervals:sw_start)';

sw_aim = linspace(sw_end,sw_start,n_intervals);
sw_aim = sw_aim(:);
[n_pts, ~] = size(sw_aim);
%[kg_fine_VL, kw_fine_VL] = Chierici_rel_perm(sw_aim, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
[kg_fine_VL, kw_fine_VL] = LET_function(sw_aim, swirr, kwsirr, kgsgi, L_w, E_w, T_w, L_g, E_g, T_g);

%{
%For simplicity for imbibition, switch rel perms to Corey relations
cl = 1.7;  swi = 0.13;
[kg_fine_VL, kw_fine_VL] = Ann_rel_perm_cat(sw_aim, swi,swirr);
kg_imb = Ann_rel_perm_cat_imb_mob(sw_aim, swi, swirr, cl);
for row = 1:n_pts
if sw_aim(row)>0.645
    P_CUT = row;
    break
end
end
%}

kw_fine_VL(1) = 0;
kg_fine_VL(end) = 0;

pc_fine = Brooks_corey_Pc(sw_aim, pe, swirr, lambda);

%% Injection rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eclipse metric unit inject rate is m3/day
Q_plan_vol = Q_plan_mass/CO2_den;     %this is inj rate in m3/yr
Q_plan_vol_day = Q_plan_vol/(365*24); %this is the planned inj rate in m3/day

%injection rates and boundary pressures for fine and upscaled solution.
%Qg =  Qg_tot./(Nz./well_perforations_fine);
%Qg_up = Qg*Nz./N_coar_subs_z;
Qg = Q_plan_vol_day;

bound_press = (g_accel./1000).*rho_w.*z_vec;        %RHS boundary pressure (kPa)
bound_press_up = (g_accel./1000).*rho_w.*z_vec_up;  %RHS boundary pressure (kPa)

pore_volume = Lz*Lx*Ly*por_av_domain;%ask Nele
pore_volume_sub = Nx_sub.*Ny_sub.*Nz_sub.*ds_x*ds_y*ds_z; %pore volume in a subvolume
pore_volume_sub_buffer_x = Nx_sub.*(Nx_sub.*10)*Ny_sub.*Nz_sub.*ds_x*ds_y*ds_z; %pore volume in a subvolume
pore_volume_sub_buffer_y = Nx_sub.*(Ny_sub.*10)*Ny_sub.*Nz_sub.*ds_x*ds_y*ds_z; %pore volume in a subvolume
pore_volume_sub_buffer_z = Nx_sub.*(Nz_sub.*10)*Ny_sub.*Nz_sub.*ds_x*ds_y*ds_z; %pore volume in a subvolume

dt_max = ((ds_x*ds_y*ds_z)./Qg);

t_mult = Qg*(Nz./well_perforations_fine)./(pore_volume*(1-swirr));
non_dim_times = dt_nd:dt_nd:pore_vol_injected;
Times = non_dim_times./t_mult;
Times = [1, 10];
[~,Nt] = size(Times);

for qq = 1:N_Qg %looping through all the flow rates
    Nt_iterations = Times(end)/dt_max(qq);
    s_append_Q = strrep(num2str(Qg_tot(qq)),'.','_');
    s_append_base{qq} = ['Qg_', s_append_Q, '_rx_', int2str(corr_lengthx), '_ry_',int2str(corr_lengthy), '_rz_',int2str(corr_lengthz), '_rlsn_', int2str(realization)] ; 
end
