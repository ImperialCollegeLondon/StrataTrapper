%With all the upcaled parameters now generated, we generate upscaled
%multiphase flow simulation files, to mimic the fine scale files. These are
%generated in eclipse.
%With all the upcaled parameters now generated, we generate upscaled
%multiphase flow simulation files, to mimic the fine scale files. These are
%generated in eclipse.
%Generate files for each flow rate, We generate several upscaled cases,
%namely one with the full CL upscaling, one with VL rel perms and CL Pc,
%and one with Vl rel perms and Pc = 0.
% clc
% clear
% close all

addpath('Result')
fid = fopen('A_input.txt','r');
eformat = '[+-]?\d+\.?\d*([eE][+-]?\d+)?';
vformat = '\d+\.?\d*';
tline=0;
while tline~=-1
 tline = fgetl(fid); 
 while isempty(tline); tline = fgetl(fid); end
 if tline==-1; break; end
 if tline(1:6)=="*SkipN"
  B = regexp(tline,vformat,'match');
  skip_nt = cellfun(@str2num,B);
 end
 if tline(1:6)=="*ProNo"
  B = regexp(tline,vformat,'match');
  processor_threads = cellfun(@str2num,B);
 end
 if tline(1:4)=="*PVt"
  B = regexp(tline,vformat,'match');
  pore_vol_injected = cellfun(@str2num,B);
 end
 if tline(1:4)=="*dtn"
  B = regexp(tline,vformat,'match');
  dt_nd = cellfun(@str2num,B);
 end
 if tline(1:6)=="*Qplan"
  B = regexp(tline,vformat,'match');
  Q_plan_mass = cellfun(@str2num,B)*10^9;
 end
 if tline(1:6)=="*Densi"
  B = regexp(tline,vformat,'match');
  CO2_den = cellfun(@str2num,B);
 end
end
fclose(fid);
fclose('all');

%% Injection rates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%well perforation for wells,
well_perforations_n = 1; %no of injection well

%eclipse metric unit inject rate is m3/day
Q_plan_vol = Q_plan_mass/CO2_den;  %this is inj rate in m3/yr
Qg = Q_plan_vol/(365*24);          %this is the planned inj rate in m3/day

pore_volume = Lz*Lx*Ly*por_av_domain;

t_mult = Qg/well_perforations_n/(pore_volume*(1-swirr));
non_dim_times = dt_nd:dt_nd:pore_vol_injected;
Times = non_dim_times./t_mult;

%Times = [1, 10];
[~,Nt] = size(Times);

%% load data
% load(['./Output/post_A4_1_3D_',num2str(10),'.mat']);
% subvol_struct2=subvol_struct;
% for m =9:-1:1
%  load(['./Output/post_A4_1_3D_',num2str(m),'.mat']);
%  subvol_struct2(1:m*20,:,:) = subvol_struct;
% end
% subvol_struct = subvol_struct2;
if Step_save
    load ("./Output/post_A4_1")
end
%[N_coar_subs_z,N_coar_subs_x,N_coar_subs_y]=size(N_coar_subs);
%%
fid = fopen(['./Result/ECLIPSE_RUN.DATA'],'w'); 
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'RUNSPEC');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'TITLE'); %title
fprintf(fid, '%s\r\n', '''ECLIPSE RUN''');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'START'); %start date of simulation
fprintf(fid, '%s\r\n', '1 JAN 2050 /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'CPR', '/'); %activate the CPR linear solver
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'MESSAGES'); %modify default print /stop limits
%e.g. 1* at beginning - sets limit for normal messages to 1
fprintf(fid, '%s\r\n', '1* 1* 1* 100000 1* 1* 1* 1* 1* 100000 /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'DEBUG');
fprintf(fid, '%s\r\n', '15* -1/');
fprintf(fid, '%s\r\n', '');

%%%% THIS WILL HAVE TO CHANGE DEPENDING ON HPC

fprintf(fid, '%s\r\n', '--NPROCS MACHINE TYPE'); %this selects a parallel run, first num of domains (NPROCS), then type of run
fprintf(fid, '%s\r\n', '4 DISTRIBUTED /');
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', 'DIMENS'); %number of blocks in all directions
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x),' ', int2str(N_coar_subs_y),' ', int2str(N_coar_subs_z), ' /']);
fprintf(fid, '%s\r\n', '');
%the active phases present 
fprintf(fid, '%s\r\n', 'WATER');
fprintf(fid, '%s\r\n', 'OIL');
fprintf(fid, '%s\r\n', 'METRIC'); %UNITS: barsa (METRIC), psia (FIELD), atma (LAB), atma (PVT-M)
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'NSTACK'); %set linear solver stack size
fprintf(fid, '%s\r\n', '25 /');
fprintf(fid, '%s\r\n', '');
%local grid refignment
% fprintf(fid, '%s\r\n', 'LGR'); 
% fprintf(fid, '%s\r\n', ['4 ', int2str(N_coar_subs_x*N_coar_subs_y*N_coar_subs_z*4^3), '0 4 4 1* INTERP /']); %Local grid refinement
% fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'WELLDIMS'); %set dimensions for well data
%max no of wells in the model
%max no of connections (== max no of grid blocks connected to a well)
% max no of groups
%max no of wells in any group
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_z*2),' ', int2str(N_coar_subs_z*2),' ', int2str(N_coar_subs_z*2),' ',  int2str(N_coar_subs_z*2), ' /']);

fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'MONITOR'); %request output for run-time monitoring
fprintf(fid, '%s\r\n', 'MULTOUT'); %output files are multiple
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'SATOPTS'); %set options for directional and hysteretic kr
fprintf(fid, '%s\r\n', 'DIRECT /'); %directional kr tables are to be used (use KRNUMX keywords)
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'FMTOUT'); %output files are to be formatted
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'SMRYDIMS'); %set max no of summary file quantities
fprintf(fid, '%s\r\n', '10000000 /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'TABDIMS');  %table dimensions
fprintf(fid, '%s\r\n', [int2str((N_coar_subs_x*N_coar_subs_y*N_coar_subs_z*3)), ' 1 100 100 /']);% 1 1 1 /']);
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'EQLDIMS'); %dimensions of equilibration tables
fprintf(fid, '%s\r\n', ['1 100 ', int2str(N_coar_subs_z*N_coar_subs_x*N_coar_subs_y ),' 30 /']);
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', 'ROCKCOMP'); %Set dimensions for rock over and underburden data in thermal simulations.
fprintf(fid, '%s\r\n', 'REVERS 1 NO /'); 
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'GRID ');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'DX'); %this defines the x-direction grid block sizes
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*', num2str(dx_up, '%50g')]);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'DY');
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*', num2str(dy_up, '%50g')]);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'DZ');
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*', num2str(dz_up, '%50g')]);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'TOPS'); %depths of the top face of each grid block
fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x*N_coar_subs_y), '*', num2str(Reservior_top, '%50g')]);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE'); %specifies porosity, x-axis indexes fastest, followed by Y followed by Z
fprintf(fid, '%s\r\n', 'por_include.txt /');
fprintf(fid, '%s\r\n', '');
%PERM IN X DIRECTION
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'perm_horz_include.txt /');
fprintf(fid, '%s\r\n', ''); 
%PERM IN Y DIRECTION
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'perm_horz_2_include.txt /');
fprintf(fid, '%s\r\n', '');

%PERM IN Z DIRECTION
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'perm_vert_include.txt /');
fprintf(fid, '%s\r\n', '');
% locaal refignment
% fprintf(fid, '%s\r\n', 'CARFIN');%change
% fprintf(fid, '%s\r\n', " 'LGR1' 1 30 1 1  1 192 120 4 192 192 / ");
% fprintf(fid, '%s\r\n', 'LGRCOPY');
% fprintf(fid, '%s\r\n', '');
% fprintf(fid, '%s\r\n', 'CARFIN');
% fprintf(fid, '%s\r\n', " 'LGR2' 1 30 2 2 1 192 240 8 192 192 / ");
% fprintf(fid, '%s\r\n', 'LGRCOPY');
% fprintf(fid, '%s\r\n', '');
% fprintf(fid, '%s\r\n', 'CARFIN');
% fprintf(fid, '%s\r\n', " 'LGR3' 1 30 3 3 1 192 600 20 192 192 / ");
% fprintf(fid, '%s\r\n', 'LGRCOPY');
% fprintf(fid, '%s\r\n', '');
% fprintf(fid, '%s\r\n', 'CARFIN');
% fprintf(fid, '%s\r\n', " 'LGR4' 1 30 4 4 1 192 240 8 192 192 / ");
% fprintf(fid, '%s\r\n', 'LGRCOPY');
% fprintf(fid, '%s\r\n', '');
% fprintf(fid, '%s\r\n', 'AMALGAM');
% fprintf(fid, '%s\r\n', " 'LGR1' 'LGR2' 'LGR3' 'LGR4' /");
% fprintf(fid, '%s\r\n', ' / ');
% fprintf(fid, '%s\r\n', '');
% fprintf(fid, '%s\r\n', 'ENDFIN');
% fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INIT'); %requests output of an init file - contains sumary of data entered in GRID,PROPS,REGIONS
fprintf(fid, '%s\r\n', 'EDIT');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'PROPS');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE'); %water-oil sat functions versus water sat aka: Pc, kr functions 
fprintf(fid, '%s\r\n', 'kr_all_include.txt /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'PVTW');

%%--Water compressibility table. 1. Reference pressure (barsa). 2. Formation volume factor (rm^3/sm^3) (Reservior/standard). 3. Water compressiblity (1/bars). 4. Water viscosity (cP (metric)) 5. Viscosibility (1/bars).
fprintf(fid, '%s\r\n',  ['200 1.00 0.00 ', num2str(mu_w*1000, '%25.15f'), ' 0.00 /']);
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'PVDO');
%--Tables of dead oil (no gas present)
%--1. Oil Phase pressure (barsa). 2. Oil formation volume factor, decreasing. 3. Oil viscosity (cP).
fprintf(fid, '%s\r\n',  ['0.0000 1.00000000001   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['400.00 1.00000000000   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['800.00 0.99999999999   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['1200.0 0.99999999998   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['1600.0 0.99999999997   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['2000.0 0.99999999996   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['2400.0 0.99999999995   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['2800.0 0.99999999994   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['3200.0 0.99999999993   ', num2str(mu_g*1000, '%25.15f')]);
fprintf(fid, '%s\r\n',  ['3600.0 0.99999999992   ', num2str(mu_g*1000, '%25.15f') , ' /  ']);
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'DENSITY');
%--1. Density of oil at surface conditions (kg/m^3). 2. Density of Water at surface conditions. 3. Density of Gas at surface conditions.
fprintf(fid, '%s\r\n',  [num2str(rho_g, '%25.15f'), '  ', num2str(rho_w, '%25.15f'),'  ', num2str(rho_g/100, '%25.15f'), '/']);
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'ROCKTAB');
%--Rock compaction data. 1. Pressure (barsa). 2. Pore volume multiplier (set to 1). 3. Transmissibility multiplier (set to 1).
fprintf(fid, '%s\r\n', '110   1.0   1');
fprintf(fid, '%s\r\n', '160   1.0   1');
fprintf(fid, '%s\r\n', '210   1.0   1');
fprintf(fid, '%s\r\n', '260   1.0   1');
fprintf(fid, '%s\r\n', '310   1.0   1');
fprintf(fid, '%s\r\n', '360   1.0   1');
fprintf(fid, '%s\r\n', '410   1.0   1');
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'REGIONS');
fprintf(fid, '%s\r\n', '------------------------------------------');
%--Divides the computational grid into regions for saturation functions, PVT properties etc.

%THIS IS THE CENTRAL GRID 

fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'PVTNUM');
fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'ROCKNUM');
fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'krnum_x_include.txt /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'krnum_y_include.txt /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', 'krnum_z_include.txt /');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'SOLUTION');
fprintf(fid, '%s\r\n', '------------------------------------------');
%--The SOLUTION section contains sufficient data to define the initial state (pressure, saturations,
%--compositions) of every grid block in the reservoir.
 fprintf(fid, '%s\r\n', '');


fprintf(fid, '%s\r\n', '-- datum depth, P at depth, contact depth, Pc at contact');
fprintf(fid, '%s\r\n', 'EQUIL');
fprintf(fid, '%s\r\n', '0 1 0 0 /');
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', 'RPTSOL');

fprintf(fid, '%s\r\n', ' ''RESTART=1'' ''FIP=1'' ''PRES'' ''SOIL'' ''SWAT'' ');
fprintf(fid, '%s\r\n', '/');

fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'SUMMARY');
fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'FOIR');
fprintf(fid, '%s\r\n', 'FLPR');
fprintf(fid, '%s\r\n', 'FOPR');
fprintf(fid, '%s\r\n', 'FWPR');
fprintf(fid, '%s\r\n', 'FWCT');
fprintf(fid, '%s\r\n', 'FOPT');
fprintf(fid, '%s\r\n', 'FWPT');
fprintf(fid, '%s\r\n', 'FWIR');
fprintf(fid, '%s\r\n', 'FWIT');
fprintf(fid, '%s\r\n', 'WOPR');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WOPT');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WWPR');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WWPT');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WLPR');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WLPT');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WWCT');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WBHP');
fprintf(fid, '%s\r\n',  [' ''W2'' /']);
fprintf(fid, '%s\r\n', 'WBHP');
fprintf(fid, '%s\r\n',  [' ''W1'' /']);
fprintf(fid, '%s\r\n', 'WWIR');
fprintf(fid, '%s\r\n',  [' ''W1'' /']);
fprintf(fid, '%s\r\n', 'WWIT');
fprintf(fid, '%s\r\n',  [' ''W1'' /']);
fprintf(fid, '%s\r\n', '/');

%--Specifies number of variables to be written to summary files.
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'RPTONLY');
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', 'RUNSUM'); % requests that summary output is written at each report time (not every time step)
%--This specifies that run summary is written to a seperated excel file on completion.
fprintf(fid, '%s\r\n', 'SEPARATE'); % summary output wil be written to a separte file rather than to print file
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', 'INCLUDE');
fprintf(fid, '%s\r\n', '''bpr_all_include.txt'' /');
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', '------------------------------------------');
fprintf(fid, '%s\r\n', 'SCHEDULE');
fprintf(fid, '%s\r\n', '------------------------------------------');

%--The SCHEDULE section specifies the operations to be simulated (production and injection controls and
%--constraints) and the times at which output reports are required
%tuning helps with numerical solution 

% THIS WILL HAVE TO BE UPDATED IF SIMULATOR DOESNT RUN
fprintf(fid, '%s\r\n',  'RPTSCHED PRESSURE SOIL WELLS /');
fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n',  'RPTSCHED ''WELLS''=2 ''SUMMARY=2'' /');
fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n',  'RPTPRINT /');

fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n',  '  ');

% fprintf(fid, '%s\r\n',  '-- TUNING');
% %Timestepping controls
% fprintf(fid, '%s\r\n',  '-- 0.1 1 0.0001 0.0002 3 0.3 0.1 1.25 0.75 / ');
% %TIme truncation and convergence controls
% fprintf(fid, '%s\r\n',  '-- 0.1 0.001 1E-7 0.0001 ');
% %Newton/linear iterations
% fprintf(fid, '%s\r\n',  '-- 10 0.01 1E-6 0.001 0.001 /');
% %not sure what this one does??
% fprintf(fid, '%s\r\n',  '-- 12 1 400 1 50 8 4*1E6 /');
% fprintf(fid, '%s\r\n',  ' ');

% fprintf(fid, '%s\r\n',  'LGRLOCK');
% fprintf(fid, '%s\r\n',  ' ''LGR1''  / ');
% fprintf(fid, '%s\r\n',  ' ''LGR2''  / ');
% fprintf(fid, '%s\r\n',  ' ''LGR3''  / ');
% fprintf(fid, '%s\r\n',  ' ''LGR4''  / ');
% fprintf(fid, '%s\r\n',  '/');
% fprintf(fid, '%s\r\n',  '');

fprintf(fid, '%s\r\n',  'WELSPECS'); 
%WELSPECL must be used in place of WELSPECS to set the general specification data for wells in local refined grids. 
%The keyword data WELSPECL is similar to that for WELSPECS, except there is an additional item at position 3 which gives the name of the local grid refinement in which the well is located. 
%--The keyword introduces a new well, defining its name, the position of the wellhead, its bottom hole
%--reference depth and other specification data.
%-- 1. Well name 2. Group name , Name of LRG where located 3. I location of well head 4. J location of well head. 5. Reference depth for bottom hole pressure (m). 6. Preferred phase of well.
% count = 0;
% for ii  = 1:well_perforations_n
%  count = count + 1;
%  fprintf(fid, '%s\r\n', ['W', int2str(count),' G ',' ''LGR3'' ',int2str(160),' ', int2str(10),' 1* LIQ /' ]);
% end
fprintf(fid, '%s\r\n', ['W', int2str(1),' G ', int2str(floor(N_coar_subs_x/2)),' ', int2str(floor(N_coar_subs_y/2)),' 1* LIQ /' ]);
fprintf(fid, '%s\r\n',  '/');

fprintf(fid, '%s\r\n',  'COMPDAT'); 
%completion data for wells in a local grid
%COMPDATL must be used in place of COMPDAT, to set the general specification data for wells in local refined grids. 
%-- 1. well name 2. I location of connecting grid blocks. 3. J location of connecting grid blocks. 4. K location of upper connection blocks.
%-- 5. k location of bottom connection blocks. 6. OPEN/SHUT connection of well. 7. Saturation table number. 8. Tramissibility of well.
%-- 9. well bore diameter at the connection (m). 10. Effective kh. If default the Kh value is calcaulted from grid block data.
%-- 11. Skin factor. 12. D factor for non-darcy flow (0.0). 13. Direction of the well (Z). 14. Pressure equivalent radius.
% count = 0;
% for ii  = 1:well_perforations_n
%  count = count + 1;
%  fprintf(fid, '%s\r\n', ['W', int2str(count),' ','''LGR3''','  ',int2str(160),' 10 ',int2str(112),' ',int2str(145) ,' OPEN 1* 1* 0.00002 1* 0 0 Z 1* /'  ]);
% end
fprintf(fid, '%s\r\n', ['W', int2str(1),' ',int2str(floor(N_coar_subs_x/2)),' ', int2str(floor(N_coar_subs_y/2)),' 2 ', int2str(N_coar_subs_z-2) ,' OPEN 1* 1* 0.00002 1* 0 0 Z 1* /'  ]);
fprintf(fid, '%s\r\n',  '/');

fprintf(fid, '%s\r\n',  'WCONINJE');
%-- Control data for injection wells
%--1. Well name. 2. Injector type. 3. Open/Shut flag for the well. 4. Control mode (rate)  5. Rate (surface m^3/day)
% count = 0;
% for ii  = 1:well_perforations_n
%  count = count + 1;
%  fprintf(fid, '%s\r\n', ['W', int2str(count),' OIL OPEN RATE ',num2str(Qg(qq), '%20.12e'), ' 1* 500 / ']);
% end
fprintf(fid, '%s\r\n', ['W', int2str(1),' OIL OPEN RATE ',num2str(Qg(1), '%20.12e'), ' 1* 500 / ']);
fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n',  ' ');


fprintf(fid, '%s\r\n',  'WELSPECS');
fprintf(fid, '%s\r\n', ['W', int2str(2),' G ',int2str(N_coar_subs_x),' ', int2str(2), ' 1* LIQ /' ]);
fprintf(fid, '%s\r\n', '/');
fprintf(fid, '%s\r\n',  'COMPDAT');
fprintf(fid, '%s\r\n', ['W', int2str(2),' ',int2str(N_coar_subs_x),' ', int2str(2),' 2 ', int2str(N_coar_subs_z-2),' OPEN 1* 1* 0.00002 1* 0 0 Z 1* /'  ]);
fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n',  'WCONPROD');
fprintf(fid, '%s\r\n', ['W', int2str(2),' OPEN BHP 1* 1* 1* 1* 1* 147/']);
fprintf(fid, '%s\r\n',  '/');
fprintf(fid, '%s\r\n',  ' ');

fprintf(fid, '%s\r\n',  'TIME');
for i = 1:Nt
 if (rem(i,skip_nt) == 0)
  fprintf(fid, '%s\r\n', num2str(Times(i), '%25.15f'));
 end
end
fprintf(fid, '%s\r\n',  ' / ');
fprintf(fid, '%s\r\n',  ' ');
fprintf(fid, '%s\r\n',  'END');
fclose(fid);
 
write_ex();
disp('Fininished generating Eclipse files. ALL DONE')
disp('If you would like to run the Eclipse dateset,')
disp('you may need to modify it based on specifics.')
