%% ------- Globals_base input parameters -------
rng(1) % set seed, random number generation
%These are used only in A5_1, not before

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
    if tline(1:6)=="*Qplan"
        B = regexp(tline,vformat,'match');
        Q_plan_mass = cellfun(@str2num,B)*10^6;
    end
    if tline(1:6)=="*Densi"
        B = regexp(tline,vformat,'match');
        CO2_den = cellfun(@str2num,B);
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
%[x_grid, z_grid] = meshgrid(x_vec,-z_vec);

A1_1_Generate_global_parameters2

disp('Finished inputting base parameters')
save("./Output/post_A1_1", '-v7.3')