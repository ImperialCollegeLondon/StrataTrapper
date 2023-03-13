%With all the upcaled parameters now generated, we generate upscaled
%multiphase flow simulation files, to mimic the fine scale files. These are
%generated in eclipse.

%Generate files for each flow rate, We generate several upscaled cases,
%namely one with the full CL upscaling, one with VL rel perms and CL Pc,
%and one with Vl rel perms and Pc = 0.

        load('4_post_processing.mat')

%%
for qq = 1:N_Qg

    % ASK ABOUT VL REL PERMS - WHICH ONES DO I USE FOR ENDURANCE??
    
        LGR_s_zones = 0;

    
    fid = fopen(['ECLIPSE_full_heterog_FINE.data'],'w');
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'RUNSPEC');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'TITLE'); %title
    fprintf(fid, '%s\r\n', '''ECLIPSE RUN''');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'START'); %start date of simulation
    fprintf(fid, '%s\r\n', '1 JAN 2019 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'CPR'); %activate the CPR linear solver
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MESSAGES'); %modify default print /stop limits
    %e.g. 1* at beginning - sets limit for normal messages to 1
    fprintf(fid, '%s\r\n', '1* 1* 1* 100000 1* 1* 1* 1* 1* 100000 /');
    fprintf(fid, '%s\r\n', '');

 %%%% THIS WILL HAVE TO CHANGE DEPENDING ON HPC

    fprintf(fid, '%s\r\n', '--NPROCS MACHINE TYPE'); %this selects a parallel run, first num of domains (NPROCS), then type of run
    fprintf(fid, '%s\r\n', '4 DISTRIBUTED /');
    fprintf(fid, '%s\r\n', '');

    fprintf(fid, '%s\r\n', 'DIMENS'); %number of blocks in all directions
    fprintf(fid, '%s\r\n',  [int2str(Nx),' ', int2str(Ny),' ', int2str(Nz), ' /']);
    fprintf(fid, '%s\r\n', '');
    %the active phases present 
    fprintf(fid, '%s\r\n', 'WATER');
    fprintf(fid, '%s\r\n', 'OIL');
    fprintf(fid, '%s\r\n', 'METRIC'); %what unit
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'NSTACK'); %set linear solver stack size
    fprintf(fid, '%s\r\n', '25 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'WELLDIMS'); %set dimensions for well data
    %max no of wells in the model
    %max no of connections (== max no of grid blocks connected to a well)
    % max no of groups
    %max no of wells in any group
    
    fprintf(fid, '%s\r\n',  [int2str(Nz*2),' ', int2str(Nz*2),' ', int2str(Nz*2),' ',  int2str(Nz*2), ' /']);
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MONITOR'); %request output for run-time monitoring
    fprintf(fid, '%s\r\n', 'MULTOUT'); %output files are multiple
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATOPTS'); %set options for directional and hysteretic kr
    fprintf(fid, '%s\r\n', 'DIRECT /'); %directional kr tables are to be used (use KRNUMX keywords)
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'FMTOUT'); %output files are to be formatted
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SMRYDIMS'); %set max no of summary file quantities
    fprintf(fid, '%s\r\n', '10000000 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'TABDIMS');  %table dimensions
    fprintf(fid, '%s\r\n', [int2str((Nx*Ny*Nz)), ' 1 100 100 1 1 1 /']);
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
    fprintf(fid, '%s\r\n',  [int2str(Nx*Ny*Nz), '*', num2str(ds_x, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DY');
    fprintf(fid, '%s\r\n',  [int2str(Nx*Ny*Nz), '*', num2str(ds_y, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DZ');
    fprintf(fid, '%s\r\n',  [int2str(Nx*Ny*Nz), '*', num2str(ds_z, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'TOPS'); %depths of the top face of each grid block
    fprintf(fid, '%s\r\n',  [int2str(Nx*Ny), '*', num2str(Reservior_top, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO'); %specifies porosity, x-axis indexes fastest, followed by Y followed by Z
    
     for i = 1:Nz
            for k = 1:Ny
                for j = 1:Nx
                    fprintf(fid, '%s\r\n',  num2str(por_mat_corr(i,j,k), '%25.15e'));
                end
            end
     end
     
     fprintf(fid, '%s\r\n',  ' / ');

    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMX'); %specifies porosity, x-axis indexes fastest, followed by Y followed by Z
    
     for i = 1:Nz
            for k = 1:Ny
                for j = 1:Nx
                    fprintf(fid, '%s\r\n',  num2str(perm_mat_corr(i,j,k), '%25.15e'));
                end
            end
     end
     
     fprintf(fid, '%s\r\n',  ' / ');

    fprintf(fid, '%s\r\n', '');
    
fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMY'); %specifies porosity, x-axis indexes fastest, followed by Y followed by Z
    
     for i = 1:Nz
            for k = 1:Ny
                for j = 1:Nx
                    fprintf(fid, '%s\r\n',  num2str(perm_mat_corr(i,j,k), '%25.15e'));
                end
            end
     end
     
     fprintf(fid, '%s\r\n',  ' / ');

    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMZ'); %specifies porosity, x-axis indexes fastest, followed by Y followed by Z
    
     for i = 1:Nz
            for k = 1:Ny
                for j = 1:Nx
                    fprintf(fid, '%s\r\n',  num2str(perm_mat_corr(i,j,k), '%25.15e'));
                end
            end
     end
     
     fprintf(fid, '%s\r\n',  ' / ');

    fprintf(fid, '%s\r\n', '');
    

    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'INIT'); %requests output of an init file - contains sumary of data entered in GRID,PROPS,REGIONS
    fprintf(fid, '%s\r\n', 'EDIT');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'PROPS');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SWOF');

        table_number = 1;


    for i = 1:Nz
        for k = 1:Ny
            for j = 1:Nx
                
                 fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
                 
                 if (j == 1) %if we are at the inlet, we want Pc = 0
                     for ii = 1:n_pts
                     
                        fprintf(fid, '%s\r\n',  [num2str(sw_aim(ii), '%25.5e'),'   ',num2str(kw_fine_VL(ii) , '%25.5e'),'   ',num2str(kg_fine_VL(ii), '%25.5e'),'   ',num2str(0, '%25.5e')]);
                     end
                     
                 else %if we are not at the inlet, then we set Pc to the normal value
                     for ii = 1:n_pts
                         
                         pc_block = pc_fine(ii)*(pe_mat_corr(i,j,k)/pe);
                     
                        fprintf(fid, '%s\r\n',  [num2str(sw_aim(ii), '%25.5e'),'   ',num2str(kw_fine_VL(ii) , '%25.5e'),'   ',num2str(kg_fine_VL(ii), '%25.5e'),'   ',num2str(pc_block/100, '%25.5e')]);
                     end
                     
                 end
                 
                 fprintf(fid, '%s\r\n', '/');
                 fprintf(fid, '%s\r\n', '');

                table_number = table_number +1;
                
            end
        end
    end
    

    fprintf(fid, '%s\r\n',  ' / ');
    
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVTW');
    %%--Water compressibility table. 1. Reference pressure (barsa). 2. Formation volume factor (rm^3/sm^3) (Reservior/standard). 3. Water compressiblity (1/bars). 4. Water viscosity (cP (metric)) 5. Viscosibility (1/bars).
    fprintf(fid, '%s\r\n',  ['200 1.00 0.00     ', num2str(mu_w*1000, '%25.15f'), ' 0.00     /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVDO');
    %--Tables of dead oil (no gas present)
    %--1. Oil Phase pressure (barsa). 2. Oil formation volume factor, decreasing. 3. Oil viscosity (cP).
    fprintf(fid, '%s\r\n',  ['0.0000    1.00000000001   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['400.00    1.00000000000   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['800.00    0.99999999999   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1200.0    0.99999999998   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1600.0    0.99999999997   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2000.0    0.99999999996   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2400.0    0.99999999995   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2800.0    0.99999999994   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3200.0    0.99999999993   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3600.0    0.99999999992   ', num2str(mu_g*1000, '%25.15f') , ' /  ']);
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
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Ny*Nz), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Ny*Nz), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');

% CHECK IF THE RIGHT TABLES ARE ASSIGNED TO THE RIGHT GRID BLOCKS!


% This defines the sat function region to which each grid block belongs,
% keyword will be followed by one integer for every block to specify the
% table number to which this grid block belongs to

    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    table_number_2 = 1;

    
    for i = 1:Nz
        for k = 1:Ny
            for j = 1:Nx

                fprintf(fid, '%s\r\n',  int2str(table_number_2));
                table_number_2 = table_number_2 + 1;

            end
        end
    end
    
    fprintf(fid, '%s\r\n',  ' / ');
    
    fprintf(fid, '%s\r\n', '');

    
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
    
%     fprintf(fid, '%s\r\n', '');
%     fprintf(fid, '%s\r\n', 'PRVD');
%     for i = 1:Nz
%         fprintf(fid, '%s\r\n',  [num2str(z_vec(i), '%25.15f'),'    ', num2str(bound_press(i)/100, '%25.15f')]);
%     end
%     fprintf(fid, '%s\r\n', '/');
%     fprintf(fid, '%s\r\n', '');
%     fprintf(fid, '%s\r\n', 'SWAT');
%     fprintf(fid, '%s\r\n',  [  num2str(Ny*Nx*Nz), '*1.00 / ']);
    fprintf(fid, '%s\r\n', '');
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
    fprintf(fid, '%s\r\n',  'BPR');
    
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'BSWAT');
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    
    fprintf(fid, '%s\r\n',  'BWPC');
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    
    fprintf(fid, '%s\r\n',  'BPR');
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    
    
    fprintf(fid, '%s\r\n',  'BWPR');
    for i = 1:Nx
        for j = 1:Ny
            for k = 1:Nz
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SCHEDULE');
    fprintf(fid, '%s\r\n', '------------------------------------------');

    %--The SCHEDULE section specifies the operations to be simulated (production and injection controls and
    %--constraints) and the times at which output reports are required
    %tuning helps with numerical solution 
    
% THIS WILL HAVE TO BE UPDATED IF SIMULATOR DOESNT RUN
    fprintf(fid, '%s\r\n',  'RPTSCHED PRESSURE SOIL WELLS /');
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  '  ');
    
    fprintf(fid, '%s\r\n',  'TUNING');

    %Timestepping controls

    fprintf(fid, '%s\r\n',  '0.1 1 0.0001 0.0002 3 0.3 0.1 1.25 0.75 / ');

    %TIme truncation and convergence controls

    fprintf(fid, '%s\r\n',  '0.1 0.001 1E-7 0.0001 ');

    %Newton/linear iterations

    fprintf(fid, '%s\r\n',  '10 0.01 1E-6 0.001 0.001 /');

    %not sure what this one does??
    fprintf(fid, '%s\r\n',  '40 1 400 1 50 8 4*1E6 /');
    
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    %this sets it up so that the LGR are solved within the global grid and
    %not seperate 

    
    fprintf(fid, '%s\r\n',  'WELSPECS'); %WELSPECL must be used in place of WELSPECS to set the general specification data for wells in local refined grids. 
    %The keyword data is similar to that for WELSPECS, except there is an additional item at position 3 which gives the name of the local grid refinement in which the well is located. 
    %--The keyword introduces a new well, defining its name, the position of the wellhead, its bottom hole
    %--reference depth and other specification data.
    %-- 1. Well name 2. Group name , Name of LRG where located 3. I location of well head 4. J location of well head. 5. Reference depth for bottom hole pressure (m). 6. Preferred phase of well.
    count = 0;
    for ii  = 1:1 %we only want 1 well, well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G',' 1 ', int2str(ceil(Ny/2)),' 1* OIL	/' ]);
    end
    for ii  = 1:1 %we only want 1 well well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G  ',int2str(Nx),'	', int2str(ceil(Ny/2)), ' 1* LIQ	/' ]);
    end
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'COMPDAT'); %completion data for wells in a local grid
    fprintf(fid, '%s\r\n',  ' ');
    %-- 1. well name 2. I location of connecting grid blocks. 3. J location of connecting grid blocks. 4. K location of upper connection blocks.
    %-- 5. k location of bottom connection blocks. 6. OPEN/SHUT connection of well. 7. Saturation table number. 8. Tramissibility of well.
    %-- 9. well bore diameter at the connection (m). 10. Effective kh. If default the Kh value is calcaulted from grid block data.
    %-- 11. Skin factor. 12. D factor for non-darcy flow (0.0). 13. Direction of the well (Z). 14. Pressure equivalent radius.
    %int2str((count-1)*well_perforations_fine+1)
    count = 0;
    for ii  = 1:1 %well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count), ' 1 ',int2str(ceil(Ny/2)),' 1 ',int2str(Nz) ,' OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/'  ]);
    end
    %start = count;
   % count = 0;
    for ii  = 1:1 %well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
                fprintf(fid, '%s\r\n', ['W', int2str(count),' ', int2str(Nx),' ',int2str(ceil(Ny/2)),' 1 ',int2str(Nz) ,' OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/'  ]);

       % fprintf(fid, '%s\r\n', ['W', int2str(start+count),final_LGR, '  ', int2str(final_refined_cell),'	1	', int2str((count-1)*well_perforations_fine+1),'    ', int2str(count*well_perforations_fine),'  OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/' ]);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'WCONINJE');
    %-- Control data for injection wells
    %--1. Well name. 2. Injector type. 3. Open/Shut flag for the well. 4. Control mode (rate)  5. Rate (surface m^3/day)
    count = 0;
    for ii  = 1:1 %well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' OIL    OPEN    RATE    ',num2str(Qg(qq), '%20.12e'), ' 1* 500 / ']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'WCONPROD');
    %control data for production well
    start = count;
    count = 0;
    for ii  = 1:1 %well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(start+count),' OPEN    LRAT    3* ',num2str(Qg(qq), '%20.12e'), '  /']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'TIME');
    
    for i = 1:Nt
            if (rem(i,skip_nt) == 0)


                fprintf(fid, '%s\r\n', num2str(Times(qq,i), '%25.15f'));
            end
    end
    
    fprintf(fid, '%s\r\n',  ' / ');

    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'END');
    fclose(fid);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{


%VISCOUS LIMIT

    fid = fopen(['ECLIPSE_VL_upscaling', s_append_base{qq}, '.data'],'w');
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'RUNSPEC');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'TITLE');
    fprintf(fid, '%s\r\n', '''ECLIPSE RUN''');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'START');
    fprintf(fid, '%s\r\n', '1 JAN 2019 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'CPR');
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MESSAGES');
    fprintf(fid, '%s\r\n', '1* 1* 1* 100000 1* 1* 1* 1* 1* 100000 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '--NPROCS MACHINE TYPE');
    fprintf(fid, '%s\r\n', '4 DISTRIBUTED /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DIMENS');
    fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x),' ', int2str(N_coar_subs_y),' ', int2str(N_coar_subs_z), ' /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'WATER');
    fprintf(fid, '%s\r\n', 'OIL');
    fprintf(fid, '%s\r\n', 'METRIC');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'NSTACK');
    fprintf(fid, '%s\r\n', '25 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'LGR');
    fprintf(fid, '%s\r\n',  [int2str(LGR_p_zones*2 + LGR_s_zones),' ', int2str(Nz.*Nx),' ', int2str(0),' ', int2str(LGR_p_zones*2 + LGR_s_zones),' ', int2str(LGR_p_zones*2 + LGR_s_zones),' 1* INTERP /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'WELLDIMS');
    
    fprintf(fid, '%s\r\n',  [int2str(Nz*2),' ', int2str(Nz*2),' ', int2str(Nz*2),' ',  int2str(Nz*2), ' /']);
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MONITOR');
    fprintf(fid, '%s\r\n', 'MULTOUT');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'FMTOUT');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SMRYDIMS');
    fprintf(fid, '%s\r\n', '10000000 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'TABDIMS');
    fprintf(fid, '%s\r\n', [int2str(N_hom_subs_x*N_hom_subs_z + Nz.*Nx_sub*LGR_p_zones*2), ' 1 100 100 1 1 1 /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'EQLDIMS');
    fprintf(fid, '%s\r\n', ['1 100 ', int2str(N_coar_subs_z*N_coar_subs_x ),' 30 /']);
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'ROCKCOMP');
    fprintf(fid, '%s\r\n', 'REVERS 1 NO /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'GRID ');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DX');
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
    fprintf(fid, '%s\r\n', 'TOPS');
    fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x), '*', num2str(Reservior_top, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    div_x = N_coar_subs_x/N_hom_subs_x;
    div_z = N_coar_subs_z/N_hom_subs_z;
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).por_upscaled, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMX');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_hor, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMY');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_hor, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_vert, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'CARFIN');
    %-- NAME I1-I2 J1-J2 K1-K2 NX NY NZ NWMAX--
    if (Nz < Nx)
        fprintf(fid, '%s\r\n',  [' ''LGR'' ',' 1 ', int2str(LGR_p_zones),' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nz), ' / ']);
    else
        fprintf(fid, '%s\r\n',  [' ''LGR'' ', '1 ', int2str(LGR_p_zones),' 1 1 1 ' int2str(N_hom_subs_z),' ' , int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nx), ' / ' ]);
    end
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).porMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMX');
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMY');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    
    
    
    for i = 1:LGR_s_zones
        fprintf(fid, '%s\r\n', 'CARFIN');
        
        if (i == LGR_s_zones)
            fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', int2str((i-1)*s_zone_width + 1 + LGR_p_zones), ' ',int2str(N_hom_subs_x-1),' ', ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str( ((N_hom_subs_x) - ((i-1)*s_zone_width + 1 + LGR_p_zones) +0)*ref1/(2^(i-1))*upscaling_aspect_ratio),' ', ' 1 ' ,int2str((ref1/(2^(i-1)))*N_hom_subs_z),' ' ,int2str(Nz), ' / ']);
            
        else
            fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', int2str((i-1)*s_zone_width + 1 + LGR_p_zones), ' ',int2str((i-1)*s_zone_width  + LGR_p_zones+ s_zone_width),' ', ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str((ref1/(2^(i-1)))*s_zone_width*upscaling_aspect_ratio),' ', ' 1 ' ,int2str((ref1/(2^(i-1)))*N_hom_subs_z),' ' ,int2str(Nz), ' / ']);
            
        end
        
    end
    
    
    fprintf(fid, '%s\r\n', 'CARFIN');
    %-- NAME I1-I2 J1-J2 K1-K2 NX NY NZ NWMAX--
    
    fprintf(fid, '%s\r\n',  [' ''LGR',int2str(i+2),''' ', int2str(N_hom_subs_x),' ', int2str(N_hom_subs_x), ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nz), ' / ']);
    
    final_refined_cell = Nx_up;
    final_LGR = [' ''LGR' ,int2str(i+2),''' '];
    final_refined_Nz = Nz;
    
    final_refined_dz = (Reservior_bottom - Reservior_top)./final_refined_Nz;
    z_vec_up_ref = ((Reservior_top + final_refined_dz/2):final_refined_dz:(Reservior_bottom-final_refined_dz/2))';
    bound_press_up_ref = (g_accel/1000).*rho_w.*z_vec_up_ref;
    
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).porMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMX');
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMY');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'AMALGAM');
    
    if (LGR_s_zones == 1)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3''  /');
    elseif (LGR_s_zones == 2)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' /');
    elseif (LGR_s_zones == 3)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5''  /');
    elseif (LGR_s_zones == 4)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5'' ''LGR6''  /');
    elseif (LGR_s_zones == 5)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5'' ''LGR6'' ''LGR7''  /');
    end
    
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ENDFIN');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'INIT');
    fprintf(fid, '%s\r\n', 'EDIT');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'PROPS');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SWOF');
    
    for iii = 1:N_hom_subs_z
        for jjj = 1:N_hom_subs_x
            kw_last = 0;
            kg_last = 1;
            
            sw_last = swirr;
            pc_last = subvol_struct(iii,jjj).pc_upscaled(1)*1.1;
            
            [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
            
            for i = 1:n_pts
                if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)) && ((subvol_struct(iii,jjj).pc_upscaled(i) < pc_last)))
                    
                    fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj).kw_VL_numerical(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj).kg_VL_numerical(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj).pc_upscaled(i)/100, '%25.15e')]);
                    
                    pc_last = subvol_struct(iii,jjj).pc_upscaled(i);
                    sw_last = subvol_struct(iii,jjj).sw_upscaled(i);
                    
                end
            end
            fprintf(fid, '%s\r\n', '/');
            fprintf(fid, '%s\r\n', '');
        end
    end
    
    
    for iii = 1:N_hom_subs_z
        
        for ii = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for jj = 1:Nx_up
                    
                    kw_last = 0;
                    kg_last = 1;
                    
                    sw_last = swirr;
                    
                    [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
                    
                    for i = 1:n_pts
                        if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)))
                            
                            sw_loop = subvol_struct(iii,jjj).sw_upscaled(i);
                            kw_loop  = subvol_struct(iii,jjj).kw_VL_numerical(i);
                            ko_loop  = subvol_struct(iii,jjj).kg_VL_numerical(i);
                            
                            if (jj == 1) && (jjj == 1)
                                pc_loop = 0;
                            else
                                pc_loop  = Brooks_corey_Pc( sw_loop , subvol_struct(iii,jjj).peMat(ii,jj), swirr,lambda);
                            end
                            
                            fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'),'   ',num2str(pc_loop/100, '%25.15e')]);
                            sw_last = sw_loop;
                            
                        end
                    end
                    fprintf(fid, '%s\r\n', '/');
                    fprintf(fid, '%s\r\n', '');
                end
            end
        end
    end
    
    for iii = 1:N_hom_subs_z
        for ii = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                
                for jj = 1:Nx_up
                    
                    kw_last = 0;
                    kg_last = 1;
                    
                    sw_last = swirr;
                    
                    [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
                    
                    for i = 1:n_pts
                        if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)))
                            
                            sw_loop = subvol_struct(iii,jjj).sw_upscaled(i);
                            kw_loop  = subvol_struct(iii,jjj).kw_VL_numerical(i);
                            ko_loop  = subvol_struct(iii,jjj).kg_VL_numerical(i);
                            
                            pc_loop  = Brooks_corey_Pc( sw_loop , subvol_struct(iii,jjj).peMat(ii,jj), swirr,lambda);
                            
                            fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'),'   ',num2str(pc_loop/100, '%25.15e')]);
                            sw_last = sw_loop;
                            
                        end
                    end
                    fprintf(fid, '%s\r\n', '/');
                    fprintf(fid, '%s\r\n', '');
                end
            end
        end
    end
    
    
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVTW');
    %%--Water compressibility table. 1. Reference pressure (barsa). 2. Formation volume factor (rm^3/sm^3) (Reservior/standard). 3. Water compressiblity (1/bars). 4. Water viscosity (cP (metric)) 5. Viscosibility (1/bars).
    fprintf(fid, '%s\r\n',  ['200 1.00 0.00     ', num2str(mu_w*1000, '%25.15f'), ' 0.00     /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVDO');
    %--Tables of dead oil (no gas present)
    %--1. Oil Phase pressure (barsa). 2. Oil formation volume factor, decreasing. 3. Oil viscosity (cP).
    fprintf(fid, '%s\r\n',  ['0.0000    1.00000000001   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['400.00    1.00000000000   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['800.00    0.99999999999   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1200.0    0.99999999998   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1600.0    0.99999999997   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2000.0    0.99999999996   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2400.0    0.99999999995   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2800.0    0.99999999994   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3200.0    0.99999999993   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3600.0    0.99999999992   ', num2str(mu_g*1000, '%25.15f') , ' /  ']);
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
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  int2str(j_sub + (i_sub-1).*N_hom_subs_x));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'REFINE');
    fprintf(fid, '%s\r\n', ' ''LGR'' / ');
    
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    count = 0;
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    count = count+1;
                    fprintf(fid, '%s\r\n',  int2str((N_hom_subs_x.*N_hom_subs_z) +count));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', 'REFINE');
    fprintf(fid, '%s\r\n', final_LGR, ' / ');
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_coar_subs_x:N_coar_subs_x
                
                for j = 1:Nx_up
                    count = count+1;
                    fprintf(fid, '%s\r\n',  int2str((N_hom_subs_x.*N_hom_subs_z) +count));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ENDFIN');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SOLUTION');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--The SOLUTION section contains sufficient data to define the initial state (pressure, saturations,
    %--compositions) of every grid block in the reservoir.
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PRVD');
    for i = 1:N_coar_subs_z
        fprintf(fid, '%s\r\n',  [num2str(z_vec_up(i), '%25.15f'),'    ', num2str(bound_press_up(i)/100, '%25.15f')]);
    end
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SWAT');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1.00 / ']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SUMMARY');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--Specifies number of variables to be written to summary files.
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'RPTONLY');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'RUNSUM');
    %--This specifies that run summary is written to a seperated excel file on completion.
    fprintf(fid, '%s\r\n', 'SEPERATE');
    fprintf(fid, '%s\r\n',  'BPR');
    
    for i = 1:N_coar_subs_x
        for j = 1:N_coar_subs_y
            for k = 1:N_coar_subs_z
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'BSWAT');
    for i = 1:N_coar_subs_x
        for j = 1:N_coar_subs_y
            for k = 1:N_coar_subs_z
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SCHEDULE');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--The SCHEDULE section specifies the operations to be simulated (production and injection controls and
    %--constraints) and the times at which output reports are required
    fprintf(fid, '%s\r\n',  'TUNING');
    fprintf(fid, '%s\r\n',  '1 365 0.0001 0.0002 3 0.3 0.1 1.25 0.75 / ');
    fprintf(fid, '%s\r\n',  '0.1 0.001 1E-7 0.0001 ');
    fprintf(fid, '%s\r\n',  '10 0.01 1E-6 0.001 0.001 /');
    fprintf(fid, '%s\r\n',  '12 1 400 1 50 8 4*1E6 /');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'LGRLOCK ');
    fprintf(fid, '%s\r\n',  [' ''LGR'' ', ' / ']);
    for i = 1:LGR_s_zones + LGR_p_zones
        fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', ' / ']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'WELSPECL');
    %--The keyword introduces a new well, defining its name, the position of the wellhead, its bottom hole
    %--reference depth and other specification data.
    %-- 1. Well name 2. Group name 3. I location of well head 4. J location of well head. 5. Reference depth for bottom hole pressure (m). 6. Preferred phase of well.
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G', ' ''LGR''  ', ' 1	 1	1* OIL	/' ]);
    end
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G  ',final_LGR ,	 int2str(final_refined_cell),'	 1	 1* LIQ	/' ]);
    end
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'COMPDATL');
    fprintf(fid, '%s\r\n',  ' ');
    %-- 1. well name 2. I location of connecting grid blocks. 3. J location of connecting grid blocks. 4. K location of upper connection blocks.
    %-- 5. k location of bottom connection blocks. 6. OPEN/SHUT connection of well. 7. Saturation table number. 8. Tramissibility of well.
    %-- 9. well bore diameter at the connection (m). 10. Effective kh. If default the Kh value is calcaulted from grid block data.
    %-- 11. Skin factor. 12. D factor for non-darcy flow (0.0). 13. Direction of the well (Z). 14. Pressure equivalent radius.
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' ''LGR'' ', ' 1	 1	', int2str((count-1)*well_perforations_fine+1),'    ', int2str(count*well_perforations_fine),'	OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/'  ]);
    end
    start = count;
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(start+count),final_LGR, '  ', int2str(final_refined_cell),'	1	', int2str((count-1)*well_perforations_fine+1),'    ', int2str(count*well_perforations_fine),'  OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/' ]);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'WCONINJE');
    %-- Control data for injection wells
    %--1. Well name. 2. Injector type. 3. Open/Shut flag for the well. 4. Control mode (rate)  5. Rate (surface m^3/day)
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' OIL    OPEN    RATE    ',num2str(Qg(qq), '%20.12e'), ' 1* 500 / ']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'WCONPROD');
    start = count;
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(start+count),' OPEN    BHP    1*   1*     1*   1*    1* ',num2str(mean(bound_press_up_ref(((count-1)*well_perforations_fine+1):((count-1)*well_perforations_fine+well_perforations_fine)))/100, '%20.12e'), '  /']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'TIME');
    
    for i = 1:Nt
        if (rem(i,skip_nt) == 0)
            
            
            fprintf(fid, '%s\r\n', num2str(Times(qq,i), '%25.15f'));
        end
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'END');
    fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%NO CAPILLARY PRESSURE

    fid = fopen(['ECLIPSE_VL_PC0_upscaling', s_append_base{qq}, '.data'],'w');
    
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'RUNSPEC');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'TITLE');
    fprintf(fid, '%s\r\n', '''ECLIPSE RUN''');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'START');
    fprintf(fid, '%s\r\n', '1 JAN 2019 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'CPR');
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MESSAGES');
    fprintf(fid, '%s\r\n', '1* 1* 1* 100000 1* 1* 1* 1* 1* 100000 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '--NPROCS MACHINE TYPE');
    fprintf(fid, '%s\r\n', '4 DISTRIBUTED /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DIMENS');
    fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x),' ', int2str(N_coar_subs_y),' ', int2str(N_coar_subs_z), ' /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'WATER');
    fprintf(fid, '%s\r\n', 'OIL');
    fprintf(fid, '%s\r\n', 'METRIC');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'NSTACK');
    fprintf(fid, '%s\r\n', '25 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'LGR');
    fprintf(fid, '%s\r\n',  [int2str(LGR_p_zones*2 + LGR_s_zones),' ', int2str(Nz.*Nx),' ', int2str(0),' ', int2str(LGR_p_zones*2 + LGR_s_zones),' ', int2str(LGR_p_zones*2 + LGR_s_zones),' 1* INTERP /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'WELLDIMS');
    
    fprintf(fid, '%s\r\n',  [int2str(Nz*2),' ', int2str(Nz*2),' ', int2str(Nz*2),' ',  int2str(Nz*2), ' /']);
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'MONITOR');
    fprintf(fid, '%s\r\n', 'MULTOUT');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'FMTOUT');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SMRYDIMS');
    fprintf(fid, '%s\r\n', '10000000 /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'TABDIMS');
    fprintf(fid, '%s\r\n', [int2str(N_hom_subs_x*N_hom_subs_z + Nz.*Nx_sub*LGR_p_zones*2), ' 1 100 100 1 1 1 /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'EQLDIMS');
    fprintf(fid, '%s\r\n', ['1 100 ', int2str(N_coar_subs_z*N_coar_subs_x ),' 30 /']);
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'ROCKCOMP');
    fprintf(fid, '%s\r\n', 'REVERS 1 NO /');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'GRID ');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DX');
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
    fprintf(fid, '%s\r\n', 'TOPS');
    fprintf(fid, '%s\r\n',  [int2str(N_coar_subs_x), '*', num2str(Reservior_top, '%50g')]);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    div_x = N_coar_subs_x/N_hom_subs_x;
    div_z = N_coar_subs_z/N_hom_subs_z;
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).por_upscaled, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMX');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_hor, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMY');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_hor, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub).k_eff_mD_vert, '%25.15e'));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'CARFIN');
    %-- NAME I1-I2 J1-J2 K1-K2 NX NY NZ NWMAX--
    if (Nz < Nx)
        fprintf(fid, '%s\r\n',  [' ''LGR'' ',' 1 ', int2str(LGR_p_zones),' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nz), ' / ']);
    else
        fprintf(fid, '%s\r\n',  [' ''LGR'' ', '1 ', int2str(LGR_p_zones),' 1 1 1 ' int2str(N_hom_subs_z),' ' , int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nx), ' / ' ]);
    end
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).porMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMX');
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMY');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    
    
    for i = 1:LGR_s_zones
        fprintf(fid, '%s\r\n', 'CARFIN');
        
        if (i == LGR_s_zones)
            fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', int2str((i-1)*s_zone_width + 1 + LGR_p_zones), ' ',int2str(N_hom_subs_x-1),' ', ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str( ((N_hom_subs_x) - ((i-1)*s_zone_width + 1 + LGR_p_zones) +0)*ref1/(2^(i-1))*upscaling_aspect_ratio),' ', ' 1 ' ,int2str((ref1/(2^(i-1)))*N_hom_subs_z),' ' ,int2str(Nz), ' / ']);
            
        else
            fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', int2str((i-1)*s_zone_width + 1 + LGR_p_zones), ' ',int2str((i-1)*s_zone_width  + LGR_p_zones+ s_zone_width),' ', ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str((ref1/(2^(i-1)))*s_zone_width*upscaling_aspect_ratio),' ', ' 1 ' ,int2str((ref1/(2^(i-1)))*N_hom_subs_z),' ' ,int2str(Nz), ' / ']);
            
        end
        
    end
    
    
    fprintf(fid, '%s\r\n', 'CARFIN');
    %-- NAME I1-I2 J1-J2 K1-K2 NX NY NZ NWMAX--
    
    fprintf(fid, '%s\r\n',  [' ''LGR',int2str(i+2),''' ', int2str(N_hom_subs_x),' ', int2str(N_hom_subs_x), ' 1 1 1 ', int2str(N_hom_subs_z),' ', int2str(Nx_up*LGR_p_zones),' ', ' 1 ' ,int2str(Nz),' ' ,int2str(Nz), ' / ']);
    
    final_refined_cell = Nx_up;
    final_LGR = [' ''LGR' ,int2str(i+2),''' '];
    final_refined_Nz = Nz;
    
    final_refined_dz = (Reservior_bottom - Reservior_top)./final_refined_Nz;
    z_vec_up_ref = ((Reservior_top + final_refined_dz/2):final_refined_dz:(Reservior_bottom-final_refined_dz/2))';
    bound_press_up_ref = (g_accel/1000).*rho_w.*z_vec_up_ref;
    
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PORO');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).porMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMX');
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', 'PERMY');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PERMZ');
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                
                for j = 1:Nx_up
                    fprintf(fid, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'AMALGAM');
    
    if (LGR_s_zones == 1)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3''  /');
    elseif (LGR_s_zones == 2)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' /');
    elseif (LGR_s_zones == 3)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5''  /');
    elseif (LGR_s_zones == 4)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5'' ''LGR6''  /');
    elseif (LGR_s_zones == 5)
        fprintf(fid, '%s\r\n', ' ''LGR'' ''LGR2'' ''LGR3'' ''LGR4'' ''LGR5'' ''LGR6'' ''LGR7''  /');
    end
    
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ENDFIN');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'INIT');
    fprintf(fid, '%s\r\n', 'EDIT');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'PROPS');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SWOF');
    
    for iii = 1:N_hom_subs_z
        for jjj = 1:N_hom_subs_x
            kw_last = 0;
            kg_last = 1;
            
            sw_last = swirr;
            pc_last = subvol_struct(iii,jjj).pc_upscaled(1)*1.1;
            
            [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
            
            for i = 1:n_pts
                if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)))
                    
                    fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj).kw_VL_numerical(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj).kg_VL_numerical(i), '%25.15e'), '   ',int2str(0)]);
                    
                    sw_last = subvol_struct(iii,jjj).sw_upscaled(i);
                    
                end
            end
            fprintf(fid, '%s\r\n', '/');
            fprintf(fid, '%s\r\n', '');
        end
    end
    
    
    for iii = 1:N_hom_subs_z
        
        for ii = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for jj = 1:Nx_up
                    
                    kw_last = 0;
                    kg_last = 1;
                    
                    sw_last = swirr;
                    
                    [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
                    
                    for i = 1:n_pts
                        if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)))
                            
                            sw_loop = subvol_struct(iii,jjj).sw_upscaled(i);
                            kw_loop  = subvol_struct(iii,jjj).kw_VL_numerical(i);
                            ko_loop  = subvol_struct(iii,jjj).kg_VL_numerical(i);
                            
                            if (jj == 1) && (jjj == 1)
                                pc_loop = 0;
                            else
                                pc_loop  = 0;
                            end
                            
                            fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'), '   ',int2str(0)]);
                            sw_last = sw_loop;
                            
                        end
                    end
                    fprintf(fid, '%s\r\n', '/');
                    fprintf(fid, '%s\r\n', '');
                end
            end
        end
    end
    
    for iii = 1:N_hom_subs_z
        
        for ii = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for jj = 1:Nx_up
                    
                    kw_last = 0;
                    kg_last = 1;
                    
                    sw_last = swirr;
                    
                    [subvol_struct(iii,jjj).kg_VL_numerical, subvol_struct(iii,jjj).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
                    
                    for i = 1:n_pts
                        if (i == 1) || (((subvol_struct(iii,jjj).sw_upscaled(i) > sw_last)))
                            
                            sw_loop = subvol_struct(iii,jjj).sw_upscaled(i);
                            kw_loop  = subvol_struct(iii,jjj).kw_VL_numerical(i);
                            ko_loop  = subvol_struct(iii,jjj).kg_VL_numerical(i);
                            
                            
                            pc_loop  = 0;
                            
                            
                            fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'), '   ',int2str(0)]);
                            sw_last = sw_loop;
                            
                        end
                    end
                    fprintf(fid, '%s\r\n', '/');
                    fprintf(fid, '%s\r\n', '');
                end
            end
        end
    end
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVTW');
    %%--Water compressibility table. 1. Reference pressure (barsa). 2. Formation volume factor (rm^3/sm^3) (Reservior/standard). 3. Water compressiblity (1/bars). 4. Water viscosity (cP (metric)) 5. Viscosibility (1/bars).
    fprintf(fid, '%s\r\n',  ['200 1.00 0.00     ', num2str(mu_w*1000, '%25.15f'), ' 0.00     /']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVDO');
    %--Tables of dead oil (no gas present)
    %--1. Oil Phase pressure (barsa). 2. Oil formation volume factor, decreasing. 3. Oil viscosity (cP).
    fprintf(fid, '%s\r\n',  ['0.0000    1.00000000001   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['400.00    1.00000000000   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['800.00    0.99999999999   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1200.0    0.99999999998   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['1600.0    0.99999999997   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2000.0    0.99999999996   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2400.0    0.99999999995   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['2800.0    0.99999999994   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3200.0    0.99999999993   ', num2str(mu_g*1000, '%25.15f')]);
    fprintf(fid, '%s\r\n',  ['3600.0    0.99999999992   ', num2str(mu_g*1000, '%25.15f') , ' /  ']);
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
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    for i = 1:N_coar_subs_z
        for j = 1:N_coar_subs_x
            i_sub = ceil(i/div_z);
            j_sub = ceil(j/div_x);
            fprintf(fid, '%s\r\n',  int2str(j_sub + (i_sub-1).*N_hom_subs_x));
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'REFINE');
    fprintf(fid, '%s\r\n', ' ''LGR'' / ');
    
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    count = 0;
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = 1:LGR_p_zones
                for j = 1:Nx_up
                    count = count+1;
                    fprintf(fid, '%s\r\n',  int2str((N_hom_subs_x.*N_hom_subs_z) +count));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', 'REFINE');
    fprintf(fid, '%s\r\n', final_LGR, ' / ');
    fprintf(fid, '%s\r\n', 'PVTNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ROCKNUM');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_z*Nx_up*Nz_up*LGR_p_zones), '*1']);
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SATNUM');
    fprintf(fid, '%s\r\n', '');
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_coar_subs_x:N_coar_subs_x
                
                for j = 1:Nx_up
                    count = count+1;
                    fprintf(fid, '%s\r\n',  int2str((N_hom_subs_x.*N_hom_subs_z) +count));
                end
            end
        end
    end
    fprintf(fid, '%s\r\n',  ' / ');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'ENDFIN');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SOLUTION');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--The SOLUTION section contains sufficient data to define the initial state (pressure, saturations,
    %--compositions) of every grid block in the reservoir.
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'PRVD');
    for i = 1:N_coar_subs_z
        fprintf(fid, '%s\r\n',  [num2str(z_vec_up(i), '%25.15f'),'    ', num2str(bound_press_up(i)/100, '%25.15f')]);
    end
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'SWAT');
    fprintf(fid, '%s\r\n',  [  num2str(N_coar_subs_x*N_coar_subs_z*N_coar_subs_y), '*1.00 / ']);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SUMMARY');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--Specifies number of variables to be written to summary files.
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'RPTONLY');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'RUNSUM');
    %--This specifies that run summary is written to a seperated excel file on completion.
    fprintf(fid, '%s\r\n', 'SEPERATE');
    fprintf(fid, '%s\r\n',  'BPR');
    
    for i = 1:N_coar_subs_x
        for j = 1:N_coar_subs_y
            for k = 1:N_coar_subs_z
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'BSWAT');
    for i = 1:N_coar_subs_x
        for j = 1:N_coar_subs_y
            for k = 1:N_coar_subs_z
                
                fprintf(fid, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), ' / ']);
                
            end
        end
    end
    
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n', '------------------------------------------');
    fprintf(fid, '%s\r\n', 'SCHEDULE');
    fprintf(fid, '%s\r\n', '------------------------------------------');
    %--The SCHEDULE section specifies the operations to be simulated (production and injection controls and
    %--constraints) and the times at which output reports are required
    fprintf(fid, '%s\r\n',  'TUNING');
    fprintf(fid, '%s\r\n',  '1 365 0.0001 0.0002 3 0.3 0.1 1.25 0.75 / ');
    fprintf(fid, '%s\r\n',  '0.1 0.001 1E-7 0.0001 ');
    fprintf(fid, '%s\r\n',  '10 0.01 1E-6 0.001 0.001 /');
    fprintf(fid, '%s\r\n',  '12 1 400 1 50 8 4*1E6 /');
    fprintf(fid, '%s\r\n',  ' ');
    
    
    fprintf(fid, '%s\r\n',  'LGRLOCK ');
    fprintf(fid, '%s\r\n',  [' ''LGR'' ', ' / ']);
    for i = 1:LGR_s_zones + LGR_p_zones
        fprintf(fid, '%s\r\n',  [' ''LGR' ,int2str(i+1),''' ', ' / ']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    
    fprintf(fid, '%s\r\n',  'WELSPECL');
    %--The keyword introduces a new well, defining its name, the position of the wellhead, its bottom hole
    %--reference depth and other specification data.
    %-- 1. Well name 2. Group name 3. I location of well head 4. J location of well head. 5. Reference depth for bottom hole pressure (m). 6. Preferred phase of well.
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G', ' ''LGR''  ', ' 1	 1	1* OIL	/' ]);
    end
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' G  ',final_LGR ,	 int2str(final_refined_cell),'	 1	 1* LIQ	/' ]);
    end
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n', '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'COMPDATL');
    fprintf(fid, '%s\r\n',  ' ');
    %-- 1. well name 2. I location of connecting grid blocks. 3. J location of connecting grid blocks. 4. K location of upper connection blocks.
    %-- 5. k location of bottom connection blocks. 6. OPEN/SHUT connection of well. 7. Saturation table number. 8. Tramissibility of well.
    %-- 9. well bore diameter at the connection (m). 10. Effective kh. If default the Kh value is calcaulted from grid block data.
    %-- 11. Skin factor. 12. D factor for non-darcy flow (0.0). 13. Direction of the well (Z). 14. Pressure equivalent radius.
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' ''LGR'' ', ' 1	 1	', int2str((count-1)*well_perforations_fine+1),'    ', int2str(count*well_perforations_fine),'	OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/'  ]);
    end
    start = count;
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(start+count),final_LGR, '  ', int2str(final_refined_cell),'	1	', int2str((count-1)*well_perforations_fine+1),'    ', int2str(count*well_perforations_fine),'  OPEN	1*	1*	0.00002	1*	0	0	Z	1*	/' ]);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'WCONINJE');
    %-- Control data for injection wells
    %--1. Well name. 2. Injector type. 3. Open/Shut flag for the well. 4. Control mode (rate)  5. Rate (surface m^3/day)
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(count),' OIL    OPEN    RATE    ',num2str(Qg(qq), '%20.12e'), ' 1* 500 / ']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'WCONPROD');
    start = count;
    count = 0;
    for ii  = well_perforations_fine:well_perforations_fine:final_refined_Nz
        count = count + 1;
        fprintf(fid, '%s\r\n', ['W', int2str(start+count),' OPEN    BHP    1*   1*     1*   1*    1* ',num2str(mean(bound_press_up_ref(((count-1)*well_perforations_fine+1):((count-1)*well_perforations_fine+well_perforations_fine)))/100, '%20.12e'), '  /']);
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'TIME');
    
    for i = 1:Nt
        if (rem(i,skip_nt) == 0)
            
            
            fprintf(fid, '%s\r\n', num2str(Times(qq,i), '%25.15f'));
        end
    end
    fprintf(fid, '%s\r\n',  '/');
    fprintf(fid, '%s\r\n',  ' ');
    fprintf(fid, '%s\r\n',  'END');
    fclose(fid);


%}
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



