%% ------- Globals_base input parameters -------
% clc
% clear
% close all 

load('Fluid_transport_properties');
fid = fopen('A_input.txt','r');
eformat = '[+-]?\d+\.?\d*([eE][+-]?\d+)?';
vformat = '\d+\.?\d*';
tline=0;
while tline~=-1
    tline = fgetl(fid); 
    while isempty(tline); tline = fgetl(fid); end
    if tline==-1; break; end
    if tline(1:5)=="*corr"
        B = regexp(tline,vformat,'match');
        corr_lengths_iso = reshape(cellfun(@str2num,B),3,[])';
        [size_iso,~]  = size(corr_lengths_iso);
        corr_lengthx = corr_lengths_iso(1); 
        corr_lengthy = corr_lengths_iso(2);
        corr_lengthz = corr_lengths_iso(3); 
    end
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
    if tline(1:5)=="*Nint"
        B = regexp(tline,vformat,'match');
        n_intervals = cellfun(@str2num,B);
    end
    if tline(1:6)=="*swirr"
        B = regexp(tline,vformat,'match');
        swirr = cellfun(@str2num,B);
    end
    if tline(1:6)=="*swend"
        B = regexp(tline,vformat,'match');
        sw_end = cellfun(@str2num,B);
    end
    if tline(1:6)=="*swsta"
        B = regexp(tline,vformat,'match');
        sw_start = cellfun(@str2num,B);
    end
    if tline(1:6)=="*kwsir"
        B = regexp(tline,vformat,'match');
        kwsirr = cellfun(@str2num,B);
    end
    if tline(1:6)=="*kgsgi"
        B = regexp(tline,vformat,'match');
        kgsgi = cellfun(@str2num,B);
    end
    if tline(1:4)=="*L_w"
        B = regexp(tline,vformat,'match');
        L_w = cellfun(@str2num,B);
    end
    if tline(1:4)=="*E_w"
        B = regexp(tline,vformat,'match');
        E_w = cellfun(@str2num,B);
    end
    if tline(1:4)=="*T_w"
        B = regexp(tline,vformat,'match');
        T_w = cellfun(@str2num,B);
    end
    if tline(1:4)=="*L_g"
        B = regexp(tline,vformat,'match');
        L_g = cellfun(@str2num,B);
    end
    if tline(1:4)=="*E_g"
        B = regexp(tline,vformat,'match');
        E_g = cellfun(@str2num,B);
    end
    if tline(1:4)=="*T_g"
        B = regexp(tline,vformat,'match');
        T_g = cellfun(@str2num,B);
    end
    if tline(1:6)=="*gacce"
        B = regexp(tline,vformat,'match');
        g_accel = cellfun(@str2num,B);
    end
    if tline(1:6)=="*temav"
        B = regexp(tline,vformat,'match');
        temp_av = cellfun(@str2num,B);
    end
end
fclose(fid);
fclose('all');

rng(1) % set seed, random number generation
%Height of reservior (m)
Lz = Reservior_bottom - Reservior_top; 
%Number of cells in each directions
Nx = round(Lx/ds_x);
Ny = round(Ly/ds_y);
Nz = round(Lz/ds_z);
Ntot = Nx*Ny*Nz;
tic
%% UPSCALED PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%upscaling_aspect_ratio = Nx_sub/Nz_sub;
%Nsub_tot = Nx_sub.*Ny_sub.*Nz_sub;

Lx_sub = Nx_sub.*ds_x;
Ly_sub = Ny_sub.*ds_y;
Lz_sub = Nz_sub.*ds_z;

%Number of homogenised volumes
%Nx = number of fine scale grid blocks, Nx_sub = size of upscaled
N_hom_subs_x = floor(Nx/Nx_sub); 
N_hom_subs_y = floor(Ny/Ny_sub);
N_hom_subs_z = floor(Nz/Nz_sub);

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

%Geometry vectors, cell centred akin to CMG IMEX.
z_vec = ((Reservior_top + ds_z/2):ds_z:(Reservior_bottom-ds_z/2))'; %vetical direction
x_vec = (ds_x/2:ds_x:(Lx-ds_x/2));
y_vec = (ds_y/2:ds_y:(Ly-ds_y/2));
%[x_grid, z_grid] = meshgrid(x_vec,-z_vec);

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

bound_press = (g_accel./1000).*rho_w.*z_vec;        %RHS boundary pressure (kPa)
bound_press_up = (g_accel./1000).*rho_w.*z_vec_up;  %RHS boundary pressure (kPa)

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

%End of base input paramters

%% fine scale %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
%Generate the fine scale saturation, rel perm and Pc functions. These are
%done with chierici (or VL) and brooks-corey functions respectively.
%sw_aim = (sw_end:0.02175/n_intervals:sw_start)';

sw_aim = linspace(sw_end,sw_start,n_intervals);
sw_aim = sw_aim(:);
[n_pts, ~] = size(sw_aim);
%[kg_fine_VL, kw_fine_VL] = Chierici_rel_perm(sw_aim, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
[kg_fine_VL, kw_fine_VL] = LET_function(sw_aim, swirr, kwsirr, kgsgi, [L_w, E_w, T_w, L_g, E_g, T_g]);

kw_fine_VL(1) = 0;
kg_fine_VL(end) = 0;

disp('Finished inputting base parameters')

if Step_save
    save("./Output/post_A1_1", '-v7.3')
end