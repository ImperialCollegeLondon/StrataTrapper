%%Globals_base input parameters
rng(1) % set seed, random number generation

fid = fopen('A_input.txt','r');
eformat = '[+-]?\d+\.?\d*([eE][+-]?\d+)?';
vformat = '\d+\.?\d*';
tline=0;
while tline~=-1
    tline = fgetl(fid); 
    while isempty(tline); tline = fgetl(fid); end
    if tline==-1; break; end
    if tline(1:5)=="*Rtop"
        B = regexp(tline,vformat,'match');
        Reservior_top = cellfun(@str2num,B);
    end
    if tline(1:5)=="*Rbom"
        B = regexp(tline,vformat,'match');
        Reservior_bottom = cellfun(@str2num,B);
    end
    if tline(1:3)=="*Lx"
        B = regexp(tline,vformat,'match');
        Lx = cellfun(@str2num,B);
    end
    if tline(1:3)=="*Ly"
        B = regexp(tline,vformat,'match');
        Ly = cellfun(@str2num,B);
    end
    if tline(1:5)=="*ds_x"
        B = regexp(tline,vformat,'match');
        ds_x = cellfun(@str2num,B);
    end
    if tline(1:5)=="*ds_y"
        B = regexp(tline,vformat,'match');
        ds_y = cellfun(@str2num,B);
    end
    if tline(1:5)=="*ds_z"
        B = regexp(tline,vformat,'match');
        ds_z = cellfun(@str2num,B);
    end
    if tline(1:7)=="*Nx_sub"
        B = regexp(tline,vformat,'match');
        Nx_sub = cellfun(@str2num,B);
    end
    if tline(1:7)=="*Ny_sub"
        B = regexp(tline,vformat,'match');
        Ny_sub = cellfun(@str2num,B);
    end
    if tline(1:7)=="*Nz_sub"
        B = regexp(tline,vformat,'match');
        Nz_sub = cellfun(@str2num,B);
    end
    if tline(1:4)=="*PVt"
        B = regexp(tline,vformat,'match');
        pore_vol_injected = cellfun(@str2num,B);
    end
    if tline(1:4)=="*dtn"
        B = regexp(tline,vformat,'match');
        dt_nd = cellfun(@str2num,B);
    end
end
fclose(fid);
fclose('all');

%Height of reservior (m)
Lz = Reservior_bottom - Reservior_top; 
%Number of cells in each directions
Nx = round(Lx/ds_x);
Ny = round(Ly/ds_y);
Nz = round(Lz/ds_z);
Ntot = Nx*Ny*Nz;
%Number of timesteps to enquire
Nt_enquire_results = pore_vol_injected/dt_nd; 

% %These are used only in A5_1, not before
% LGR_p_zones = 1;  %Number of primary refinements zones (with same refinement as fine scale grid)
% LGR_s_zones =  0; %Number of secondary refinement zones
% s_zone_width = 1; %Width of each secondary zone, in upscaled grid units
% ref1 = 8; %Refinement level. THe first zone will be refined by this amount, the next by ref1/2^n where n is the refinement zone.
% 
% %Legacy variables, keep fixed
% dist_type = 1;
% n_layers = 250;
% 
% %Number of timesteps to skip outputting data,.
% skip_nt = 1;
% processor_threads = 12;

tic
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%upscaling_aspect_ratio = Nx_sub/Nz_sub;
%Nsub_tot = Nx_sub.*Ny_sub.*Nz_sub;

Lx_sub = Nx_sub.*ds_x;
Ly_sub = Ny_sub.*ds_y;
Lz_sub = Nz_sub.*ds_z;

%Number of homogenised volumes
%Nx = number of fine scale grid blocks, Nx_sub = size of upscaled
N_hom_subs_x = Nx/Nx_sub; 
N_hom_subs_y = Ny/Ny_sub;
N_hom_subs_z = Nz/Nz_sub;

%Coarsening grid block sizes. This is now defunct, as the coarsened blocks
%are the same as the upscaled blocks. It can be set differently to have
%different coarse blocks to upscaled blocks, essentially allowing extra
%levels of coarsening/refinement if needed.

Nx_up = Nx_sub;
Ny_up = Ny_sub;
Nz_up = Nz_sub;

N_coar_subs_x = Nx/Nx_up;
N_coar_subs_y = Ny/Ny_up;
N_coar_subs_z = Nz/Nz_up;

dx_up = Lx/N_coar_subs_x;
dy_up = Ly/N_coar_subs_y;
dz_up = Lz/N_coar_subs_z;

z_vec_up = ceil(((Reservior_top + dz_up/2):dz_up:(Reservior_bottom-dz_up/2)))';
x_vec_up = (dx_up/2:dx_up:(Lx-dx_up/2));
y_vec_up = (dy_up/2:dy_up:(Ly-dy_up/2));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%number of intervals for sw etc 
n_intervals = 42;

% layers_x = zeros(n_layers, 2);
% layers_y = zeros(n_layers, 2);
% layers_z = zeros(n_layers, 2);
% 
% for i = 1:n_layers
%     layers_x(i,1) = Nx./n_layers*(i-1) + 1;
%     layers_x(i,2) = Nx./n_layers*(i);
%     
%     layers_y(i,1) = Ny./n_layers*(i-1) + 1;
%     layers_y(i,2) = Ny./n_layers*(i);
%     
%     layers_z(i,1) = Nz./n_layers*(i-1) + 1; %this is for the vertical direction
%     layers_z(i,2) = Nz./n_layers*(i);
% end

%Geometry vectors, cell centred akin to CMG IMEX.
z_vec = ((Reservior_top + ds_z/2):ds_z:(Reservior_bottom-ds_z/2))'; %vetical direction
x_vec = (ds_x/2:ds_x:(Lx-ds_x/2));
y_vec = (ds_y/2:ds_y:(Ly-ds_y/2));





%% Petrophysical parameters %%%%%%%%%%%%%%%%%%%%%%%%%
%These are the chierici rel perm parameters
kwsirr = 1.0;
kgsgi = 1;%0.6;
A_water = 3;
L_water = 0.9;
B_gas = 3.75;
M_gas = 0.4;

swirr = 0.08;    %Resdiual water saturation
sw_end = 0.09;   %End point of saturation table
sw_start = 1;    %Starting point of saturation table.

g_accel = 9.80665; %gravitational accel
temp_av = 56;      %average reservior temp, degreees C from K40 report

press_av = 1000*mean(z_vec)*g_accel*1e-5; %Average hydrostatic pressure
tol = 1e-4; %Tolerance for dens calc below
err = 1;    %initial error
perm_multiplier = 1/1.01325E+15;   %Darcy to m^2 conversion

%Generate average pressure in the domain from density and temp of the
%brine, Have to iterate, as density function of these too. 
while err > tol
    rho_w = griddata(One_M_NaCL_temp_press_density(:,1),One_M_NaCL_temp_press_density(:,2),One_M_NaCL_temp_press_density(:,3),temp_av,press_av, 'linear');
    press_new = rho_w*mean(z_vec)*g_accel*1e-5;
    err = (press_new - press_av)./press_av;
    press_av = press_new;
end

%calc viscosity (mu) and density (rho) and surface tension of the fluids
%from table data. All quantities are SI units.
mu_g = griddata(CO2_temp_press_density_viscosity(:,1),CO2_temp_press_density_viscosity(:,2),CO2_temp_press_density_viscosity(:,4),temp_av,press_av, 'linear');
mu_w = griddata(One_M_NaCL_temp_press_viscosity(:,1),One_M_NaCL_temp_press_viscosity(:,2),One_M_NaCL_temp_press_viscosity(:,3),temp_av,press_av, 'linear');
rho_g = griddata(CO2_temp_press_density_viscosity(:,1),CO2_temp_press_density_viscosity(:,2),CO2_temp_press_density_viscosity(:,3),temp_av,press_av, 'linear');
surface_tension = griddata(CO2_brine_temp_press_IFT(:,1),CO2_brine_temp_press_IFT(:,2),CO2_brine_temp_press_IFT(:,3), temp_av, press_av, 'linear');

%% --------These are all from the K40 reports-------
por_av = ((z_vec - 5331.5)/(-171.68))/100; %K40 report, total por depth trend equation
por_av_start = por_av(1);  %Top porosity
por_std = 0.02;            %standard deviation of the por field
por_var = (por_std).^2;    %Variance of porosity
perm_av = ((2*10^6).*(por_av.^5.4833)); %perm equation from K40 report, perm is in mD

por_av_domain = mean(por_av);
perm_av_domain = mean(perm_av);

%Pc brooks-corey parameters and Leverett - J scaling.
lambda = 0.75;   %Brooks corey Pc curve Lambda  
jsw1 = 0.25;     %Leverett-J function J(sw = 1) value.

pe = (jsw1/1000)*sqrt(por_av_domain./((perm_av_domain)*perm_multiplier))*(surface_tension*0.001*cos(50*pi/180)); %Nele's version
jsw_end = jsw1*(((sw_end) - swirr)/(1-swirr)).^(-1/lambda);
pc_end = (jsw_end/1000)*sqrt(por_av_domain./((perm_av_domain)*perm_multiplier))*(surface_tension*0.001*cos(50*pi/180)); % I removed the exponent - dont relaly get

%well perforation for fine and upscaled wells,
well_perforations = Nz_sub;
well_perforations_x = Nx_sub;
well_perforations_fine = 1;

%End of base input paramters

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%Generate the fine scale saturation, rel perm and Pc functions. These are
%done with chierici and brooks-corey functions respectively.
%sw_aim = (sw_end:0.02175/n_intervals:sw_start)';

sw_aim = linspace(sw_end,sw_start,n_intervals);
sw_aim = sw_aim(:);
[n_pts, ~] = size(sw_aim);
[kg_fine_VL, kw_fine_VL] = Chierici_rel_perm(sw_aim, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);

%{
%For simplicity for imbibition, switch rel perms to Corey relations
cl = 1.7; 
swi = 0.13;
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

pc_fine =  Brooks_corey_Pc(sw_aim, pe, swirr,lambda);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Injection rates
%Initial plan: 2.65Mt CO2 injected per year.
%density of CO2 = 600kg/m3
%eclipse metric unit inject rate is m3/day

Q_plan_mass = 2.65*10^6;
Q_plan_vol = Q_plan_mass/600; %this is inj rate in m3/yr
Q_plan_vol_day = Q_plan_vol/(365*24); %this is the planned inj rate in m3/day
Qg = Q_plan_vol_day;

%injection rates and boundary pressures for fine and upscaled solution.
%Qg =  Qg_tot./(Nz./well_perforations_fine);
%Qg_up = Qg*Nz./N_coar_subs_z;

bound_press = (g_accel./1000).*rho_w.*z_vec;        %RHS boundary pressure (kPa)
bound_press_up = (g_accel./1000).*rho_w.*z_vec_up;  %RHS boundary pressure (kPa)

pore_volume = Lz*Lx*Ly*por_av_domain;
pore_volume_sub = Nx_sub.*Ny_sub.*Nz_sub.*ds_x*ds_y*ds_z; %pore volume in a subvolume

t_mult = Qg*(Nz./well_perforations_fine)./(pore_volume*(1-swirr));
non_dim_times = dt_nd:dt_nd:pore_vol_injected;
Times = non_dim_times./t_mult;

dt_max = ((ds_x*ds_y*ds_z)./Qg);
Nt_iterations = Times(end)/dt_max;

[~,Nt] = size(Times);

s_append_Q = strrep(num2str(Qg_tot(qq)),'.','_');
s_append_base{qq} = ['Qg_', s_append_Q, '_rx_', int2str(corr_lengthx), '_ry_',int2str(corr_lengthy), '_rz_',int2str(corr_lengthz), '_rlsn_', int2str(realization)] ;  

disp('Finished inputting base parameters')