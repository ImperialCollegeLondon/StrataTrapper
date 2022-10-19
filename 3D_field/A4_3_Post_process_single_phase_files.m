disp('Now post-process the results and generate upscaled Sw-Kr-Pc relationships');
%Now we post-process the upscaled simulation files, to actually calculate
%k, kr for the subvolumes based on he flow simulations.

AAA = 0;
BBB = 0;
CCC = 0;
DDD = 0;

for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        for kkk = 1: N_hom_subs_y
            
            disp("running horz file")
            
            sub_append = ['_subvol_',int2str(iii),'_', int2str(jjj),'_', int2str(kkk)];
            filename = ['IMEX_upscaling_horizontal',s_append_base{1},sub_append];
            [status, cmdout] = system([exe_path_run, ' -f ', filename, '.dat -wait']);
            k = strfind(cmdout,'End of Simulation: Normal Termination');
%             
            %Run horizontal upscaling files.
            sub_append = ['_subvol_',int2str(iii),'_', int2str(jjj),'_', int2str(kkk)];
            filename = ['IMEX_upscaling_horizontal_2',s_append_base{1},sub_append];
            [status, cmdout] = system([exe_path_run, ' -f ', filename, '.dat -wait']);
            k = strfind(cmdout,'End of Simulation: Normal Termination');
            
            %Now run the vertical case. THIS NEEDS TO BE MOVED BACK TO A4_2
            
             filename = ['IMEX_upscaling_vertical',s_append_base{1},sub_append];
             [status, cmdout] = system([exe_path_run, ' -f ', filename, '.dat -wait']);
             k = strfind(cmdout,'End of Simulation: Normal Termination');
            
            disp("start reading in");
        
            sub_append = ['_subvol_',int2str(iii),'_', int2str(jjj),'_', int2str(kkk)];

            %Run the report programme to generate the simulation results for horizontal
           % and vertical simulations.

            filename = ['IMEX_upscaling_report_gen_horizontal',s_append_base{1},sub_append ];
            [status, ~] = system([exe_path_report, ' -f ', filename, '.rwd -o ', filename, '.out']);

            if (status == 0)
                disp(['Succesfully read horizontal upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj),',',int2str(kkk), ' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            else
                disp(['Error reading horizontal upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj),',',int2str(kkk), ' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            end
            
            
            filename = ['IMEX_upscaling_report_gen_horizontal_2',s_append_base{1},sub_append ];
            [status, ~] = system([exe_path_report, ' -f ', filename, '.rwd -o ', filename, '.out']);

            if (status == 0)
                disp(['Succesfully read horizontal no 2 upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj),',',int2str(kkk), ' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            else
                disp(['Error reading horizontal no 2 upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj),',',int2str(kkk), ' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            end
            
            
            filename = ['IMEX_upscaling_report_gen_vertical',s_append_base{1},sub_append ];
            [status, ~] = system([exe_path_report, ' -f ', filename, '.rwd -o ', filename, '.out']);
            % -o was there .rwd -o '
            if (status == 0)
                disp(['Succesfully read vertical upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj), ',',int2str(kkk),' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            else
                disp(['Error reading vertical upscaling files for  subvolume # ', int2str(iii),',',int2str(jjj),',',int2str(kkk), ' out of ', int2str(N_hom_subs_z), ' ', int2str(N_hom_subs_x), ' ', int2str(N_hom_subs_y)])
            end
            
            
            
            disp("done reading in");

            %Read in fluxes
             well_water_flux_filename_vert = ['IMEX_upscaling_vertical',s_append_base{1},sub_append,'_Well_water_rates','.txt'];
             well_water_flux_filename_hor = ['IMEX_upscaling_horizontal',s_append_base{1},sub_append,'_Well_water_rates','.txt'];
            well_water_flux_filename_hor_2 = ['IMEX_upscaling_horizontal_2',s_append_base{1},sub_append,'_Well_water_rates','.txt'];


            clearvars title
            
           
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
           
            
            %HORIZONTAL DIRECTION 1 
            
            %total_wells_hor = (Nz_sub/well_perforations).*2;
           
            
            
            total_wells_hor = 1;%Ny;
            headers = 6;

            kg_zeros_hor = n_pts - sum(subvol_struct(iii,jjj,kkk).kg_phase_connected(:,3));
            kw_zeros_hor = n_pts - sum(subvol_struct(iii,jjj,kkk).kw_phase_connected(:,3));

            ntt_hor = n_pts*2 - kg_zeros_hor - kw_zeros_hor;



            T = readtable(well_water_flux_filename_hor);
            
            
            S = vartype('numeric');
            
            A = T{:,S};
            
            
            %A = table2array(T);

            count = 0;
            well_flux_kg_hor = zeros(n_pts, total_wells_hor);
            well_flux_kw_hor = zeros(n_pts, total_wells_hor);
            well_flux_ka_hor = 0;
            
            [aa,bb] = size(A);
            
            for i = 1:n_pts+1

                if (i == 1)
                    for j = 1:total_wells_hor
                        well_flux_ka_hor(1,j) = (A(1,j+1));
                    end
                    count = count +1;
                end

                if (i > 1) && (subvol_struct(iii,jjj,kkk).kg_phase_connected(i-1,3) > 0) %this is perm across x plane 
                    count = count+1;
                    for j = 1:total_wells_hor
                        well_flux_kg_hor(i-1,j) = (A(count,j+1));
                    end
                end
            end
            
            xxx = subvol_struct(1,1,1).kw_phase_connected(:,:);

            for i = 1:(n_pts+1)
                
                if (i > 1) && (subvol_struct(iii,jjj,kkk).kw_phase_connected(i-1,3) > 0) %this is perm across x plane
                    count = count+1;
                    for j = 1:total_wells_hor
                        well_flux_kw_hor(i-1,j) = (A(count,j+1));
                    end
                end
            end

            %we only have 1 well, so the flux we calculated will be the
            %average flux 
            
            %{
            for i = 1:n_pts
                well_flux_kw_av_hor(i,1) = sum(well_flux_kw_hor(i, total_wells_hor/2+1:total_wells_hor));
                well_flux_kg_av_hor(i,1) = sum(well_flux_kg_hor(i, total_wells_hor/2+1:total_wells_hor));
            end

            well_flux_ka_av_hor = sum(well_flux_ka_hor(:, total_wells_hor/2+1:total_wells_hor));

            %}
            
            for i = 1:n_pts
                well_flux_kw_av_hor(i,1) = sum(well_flux_kw_hor(i, :));
                well_flux_kg_av_hor(i,1) = sum(well_flux_kg_hor(i, :));
            end

            well_flux_ka_av_hor = sum(well_flux_ka_hor(:, :));
            
            
            %Find pressure in the domain

            string = ['findstr /v "''" ', '"IMEX_upscaling_horizontal',s_append_base{1},sub_append,'_Grid_block_pressure', '.txt"'    '>', 'dummy01.txt'];
            dos(string)
            pressMat_IMEX_q_1 = dlmread('dummy01.txt');
            
            Nx_sub_buffer = (Nx_sub*10) + Nx_sub;

            pressMat_hor = zeros(Nz_sub, Nx_sub_buffer, Ny_sub,ntt_hor);

            [~,n] = size(pressMat_IMEX_q_1);
            count = 0;

            remd =  n - rem(Nz_sub*Nx_sub_buffer*Ny_sub, n);

            if (remd == n)
                remd =0;
            end

            for t = 1:(ntt_hor+2) %1:ntt_hor
                   
                if (t==1)
                    count = 0;
                else
                    count = count + remd;
                end
                
                
               % count = count + remd;
                
%%%%%%%% NOT SURE IF THIS IS RIGHT??

                for i = Nz_sub:-1:1
                    for k = Ny_sub:-1:1 %1:Ny_sub
                        for j = 1:Nx_sub_buffer
                        
                            
                            count  = count + 1 ;
                            row = ceil(count/n);
                            col = rem(count,n);
                                                        
                            if (col==0)
                                col = n;
                            end

                            pressMat_hor(i,j,k,t) = pressMat_IMEX_q_1(row,col);
                        end
                    end
                end
            end

            %Find pressure drops.

            press_drop_av_hor = zeros(ntt_hor+1,1);
           
            
            %Now we need to find the constant Pressure boundary along the
%             buffer zone along the x axis, can be constant Z, only comparing
%             Y pressures along constant X
%             First for the inlet side
%             

            %INLET
            
            countj = 0;
            count2 = 0;
            
            pressureMat_hor_x_inlet_filtered = zeros(ntt_hor+2, ((Nx_sub*10)/2));
            
            

           % j_nonzero_x_inlet = zeros((Nx_sub*10)/2);
            

            
            for t = 2:(ntt_hor+2)
                j_nonzero_x_inlet = [];
                disp("in t loop");
                
                
                for j = ((Nx_sub*10)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                                        
                    disp("in j loop");
                   % count3 = 0;
                    countj = countj +1;
                    disp(j);
                    
                    
                    pressureMat_hor_x_inlet = pressMat_hor(1,j,:,t); %check if P is constant in X-Y plane

                    pressureMat_hor_x_inlet = pressureMat_hor_x_inlet(:);
                    
                    
                    disp(pressureMat_hor_x_inlet(:));
                    
                    diff_p = diff(pressureMat_hor_x_inlet);
                    disp(diff_p);
                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant

                        disp("all zero")
                        count2 = count2+1;
                        disp(j);
                        
                        avg_P = mean(pressureMat_hor_x_inlet);
                        disp("mean:");
                        disp(avg_P);

                        pressureMat_hor_x_inlet_filtered(t,j) = avg_P ;
                    end
                    
                    
                    %j = j+1;
                        
    
                end
                
                count_j = 0;
                
                for j = ((Nx_sub*10)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_hor_x_inlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        disp(j);
                        disp(pressureMat_hor_x_inlet_filtered(t,j));
                        
                        j_nonzero_x_inlet(t,count_j) = j;
                    end
                end
                
                j_best_inlet(t) = min(j_nonzero_x_inlet(t,:));
                
                pressure_hor_x_mean_final_inlet(t,1) = pressureMat_hor_x_inlet_filtered(t,j_best_inlet(t));
                
                
                    
                    
            end
            
%OUTLET HORZ DIR 1

            %OUTLET
            
            countj = 0;
            count2 = 0;
            
            pressureMat_hor_x_outlet_filtered = zeros(ntt_hor+2, ((Nx_sub*10)+Nx_sub));
            
            for t = 2:(ntt_hor+2)
                j_nonzero_x_outlet = [];
                disp("in t loop");
                
                
                for j = (((Nx_sub*10)/2)+Nx_sub+1):((Nx_sub*10)+Nx_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                    
                    countj = countj +1;

                    pressureMat_hor_x_outlet = pressMat_hor(1,j,:,t); %check if P is constant in X-Y plane

                    pressureMat_hor_x_outlet = pressureMat_hor_x_outlet(:);
                    
                    
                    disp(pressureMat_hor_x_outlet(:));
                    
                    diff_p = diff(pressureMat_hor_x_outlet);
                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant

                        count2 = count2+1;
                        
                        avg_P = mean(pressureMat_hor_x_outlet);

                        pressureMat_hor_x_outlet_filtered(t,j) = avg_P ;
                    end
                    
                   
                    j = j+1;
                        
    
                end
                
                count_j = 0;
                
                
                for j = (((Nx_sub*10)/2)+Nx_sub):((Nx_sub*10)+Nx_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_hor_x_outlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        
                        j_nonzero_x_outlet(t,count_j) = j;
                    end
                end
                
                j_best_outlet(t) = max(j_nonzero_x_outlet(t,:));
                
                pressure_hor_x_mean_final_outlet(t,1) = pressureMat_hor_x_outlet_filtered(t,j_best_outlet(t));
                
                
                    
                    
            end
            
            j_best_inlet = j_best_inlet(:);
            j_best_outlet = j_best_outlet(:);
            %{
            
            for k = 1:(ntt_hor+1)
                press_drop_av_hor(k,1) = (mean(pressMat_hor(:,1,:,k),"all")- mean(pressMat_hor(:,end,:,k),"all"));
            end

            k_eff_hor = ((well_flux_ka_av_hor/(24*60*60))*mu_w*(Lx_sub+-ds_x)./((ds_y*ds_z*Ny_sub*Nz_sub)*press_drop_av_ka_hor*1000));


%}

            for k = 2:(ntt_hor+2) %total = 58 times --> t = 1 is for abs perm, but  have time = zero here too
                
                press_drop_av_hor((k-1),1) = pressure_hor_x_mean_final_inlet(k,1) - pressure_hor_x_mean_final_outlet(k,1);
            end

            press_drop_av_ka_hor = press_drop_av_hor(1); % (mean(data_struct.pressMat(:,1,2))- mean(data_struct.pressMat(:,end,2)));

            press_drop_av_new_hor = press_drop_av_hor(2:end); %this should be 57 points
            
            %from 1 to 
            
            press_drop_av_kg_hor = zeros(n_pts,1);
            press_drop_av_kw_hor = zeros(n_pts,1);
            

            press_drop_av_kg_hor(1:(n_pts - kg_zeros_hor),1) =   press_drop_av_new_hor(1:(n_pts - kg_zeros_hor));
            
            press_drop_av_kw_hor(1:(n_pts - kw_zeros_hor),1) =   press_drop_av_new_hor((n_pts - kg_zeros_hor+1):((2*n_pts) - kw_zeros_hor - kg_zeros_hor));

            
          %  pressure_hor_x_mean_final_inlet(3:(n_pts - kg_zeros_hor),1) - pressure_hor_x_mean_final_outlet(3:(n_pts - kg_zeros_hor),1);
            
          %  press_drop_av_kw_hor(((kw_zeros_hor+1):n_pts),1) =pressure_hor_x_mean_final_inlet((n_pts - kg_zeros_hor+1):end,1) - pressure_hor_x_mean_final_outlet((n_pts - kg_zeros_hor+1):end,1);

            
           % press_drop_av_new_hor((1:(n_pts - kg_zeros_hor)),1);

            %Work out effective k, kr based on pressure drops and fluxes.
            % we are calculating p drop over buffer zone too   
            
            %%%%%%%%%% THIS NEEDS TO CHANGE BACK!
            k_eff_hor = 0;
            
            well_flux_ka_av_hor = Qw_upscaling_x(1,1);
            
            k_eff_hor_frac_top = (well_flux_ka_av_hor/(24*60*60))*mu_w*(j_best_outlet(2)-j_best_inlet(2))*ds_x;
            
            k_eff_hor_frac_bottom = ds_y*ds_z*Ny_sub*Nz_sub*press_drop_av_ka_hor*1000;

            k_eff_hor_buffer = (k_eff_hor_frac_top/k_eff_hor_frac_bottom);  
            
            k_eff_mD_hor_buffer = k_eff_hor_buffer*1013250273830886.6;
            
            
            k_eff_mD_hor = (Nx_sub)/((((j_best_outlet(2)-j_best_inlet(2)))/k_eff_mD_hor_buffer)-((j_best_outlet(2)-j_best_inlet(2)-Nx_sub)/perm_mat_buffer));
            
            
            

            disp("keff md horz")
            disp(k_eff_mD_hor);

            disp("keff md incl kr");
            
            k_eff_mD_hor_inclkr = k_eff_mD_hor/kw_fine_VL(end);
            disp(k_eff_mD_hor_inclkr);
            
            
           
            
            
            
            
            
            %this is the kr incl. the buffer zone - we need to assume
            %layers are in series again, follow same principle
            
             %n_pts*2 - kg_zeros_hor
             
             kg_CL_numerical_buffer_2_frac_top = (well_flux_kg_av_hor(1:(n_pts-kg_zeros_hor))./(24*60*60)).*mu_w.*(j_best_outlet(3:(n_pts-kg_zeros_hor+2)) - j_best_inlet(3:(n_pts-kg_zeros_hor+2))).*ds_x;
             kg_CL_numerical_buffer_2_frac_bottom = ds_y*ds_z*Ny_sub*Nz_sub.*press_drop_av_kg_hor(1:(n_pts-kg_zeros_hor)).*1000;
             
            kg_CL_numerical_hor_buffer_2 = kg_CL_numerical_buffer_2_frac_top./kg_CL_numerical_buffer_2_frac_bottom;
            
            kg_CL_numerical_hor_buffer_md = kg_CL_numerical_hor_buffer_2*1013250273830886.6;

            kg_CL_numerical_hor_md = (Nx_sub)./((((j_best_outlet(3:(n_pts-kg_zeros_hor+2))-j_best_inlet(3:(n_pts-kg_zeros_hor+2))))./kg_CL_numerical_hor_buffer_md)-((j_best_outlet(3:(n_pts-kg_zeros_hor+2))-j_best_inlet(3:(n_pts-kg_zeros_hor+2))-Nx_sub)./perm_mat_buffer));
            
            kg_CL_numerical_hor_try =  (kg_CL_numerical_hor_md)./k_eff_mD_hor;
            
            
            
            
            
            
            
            %kw_CL_numerical_hor_buffer_2 = ((well_flux_kw_av_hor((kw_zeros_hor+1):(n_pts))./(24*60*60))*mu_w*(((j_best_outlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))-j_best_inlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))).*ds_x))./((ds_y*ds_z*Ny_sub*Nz_sub).*press_drop_av_kw_hor(1:(n_pts-kw_zeros_hor)).*1000));

            kw_CL_length = (j_best_outlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2)) - j_best_inlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))).*ds_x;
            
            kw_CL_numerical_buffer_2_frac_top = (well_flux_kw_av_hor((kw_zeros_hor+1):(n_pts))./(24*60*60)).*mu_w.*kw_CL_length;
            
            
            
            
            kw_CL_numerical_buffer_2_frac_bottom = ds_y*ds_z*Ny_sub*Nz_sub.*press_drop_av_kw_hor(1:(n_pts-kw_zeros_hor)).*1000;
            
            kw_CL_numerical_hor_buffer_2 = kw_CL_numerical_buffer_2_frac_top./kw_CL_numerical_buffer_2_frac_bottom;
            
            kw_CL_numerical_hor_buffer_md =  (kw_CL_numerical_hor_buffer_2*1013250273830886.6);
            
            
            kw_CL_numerical_hor_mD = (Nx_sub)./((((j_best_outlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))-j_best_inlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))))./kw_CL_numerical_hor_buffer_md)-((j_best_outlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))-j_best_inlet((n_pts-kg_zeros_hor+3):((n_pts*2)-kg_zeros_hor-kw_zeros_hor+2))-Nx_sub)./perm_mat_buffer));
            
            
            
            kw_CL_numerical_hor_try =  (kw_CL_numerical_hor_mD)./k_eff_mD_hor;
            
            
            
            kg_CL_numerical_hor = zeros(n_pts, 1);
            kw_CL_numerical_hor = zeros(n_pts, 1);
            
            
            
            
            
            count_zero = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kg_av_hor(ii) == 0)
                    count_zero = count_zero + 1;
                    kg_CL_numerical_hor(ii,1) = 0;
                    
                end
                
               if (well_flux_kg_av_hor(ii) > 0)
                    kg_CL_numerical_hor((ii+count_zero),1) = kg_CL_numerical_hor_try(ii,1);
                end
                
            end
            
            
           count_zero = 0;
           count_non = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kw_av_hor(ii) == 0)
                    
                    kw_CL_numerical_hor(ii,1) = 0;
                    
                end
                
               if (well_flux_kw_av_hor(ii) > 0)
                   count_non = count_non + 1;
                    kw_CL_numerical_hor((ii),1) = kw_CL_numerical_hor_try(count_non,1);
                end
                
            end
            
            %kg_CL_numerical_hor =kg_CL_numerical_hor_try(1:end,1);
            
            %kw_CL_numerical_hor =kw_CL_numerical_hor_try(1:end,1);
            
            

            sw_kg_hor = 0;
            kg_cl_select_hor = 0;
            kw_cl_select_hor = 0;
            sw_kw_hor = 0;
            count1 = 0;
            count2 = 0;
            
            %{
            ASK SAM J ABOUT THIS - I DONT UNDERSTAND

            %Find limits of numerical kr values.

            hor_kg_lim1 = sum(~isnan(kg_CL_numerical_hor)) - ceil(sum(~isnan(kg_CL_numerical_hor))/4);
            
            hor_kg_lim2 = sum(~isnan(kg_CL_numerical_hor));
            
            hor_kw_lim1 = sum(isnan(kw_CL_numerical_hor))+1;
            hor_kw_lim2 = ceil((n_pts - sum(isnan(kw_CL_numerical_hor)))./4)+sum(isnan(kw_CL_numerical_hor)) ;

            for i = 1:n_pts
                if (~isnan(kg_CL_numerical_hor(i)) && (kg_CL_numerical_hor(i) > 0) && (isinf(kg_CL_numerical_hor(i)) == 0) && (i >= hor_kg_lim1) && (i <= hor_kg_lim2))
                    count1 = count1+1;
                    sw_kg_hor(count1) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kg_cl_select_hor(count1) = kg_CL_numerical_hor(i);

                end

                if (isnan(kw_CL_numerical_hor(i)) == 0) && (kw_CL_numerical_hor(i) > 0) && (isinf(kw_CL_numerical_hor(i)) == 0) && ((kw_CL_numerical_hor(i)) < 1) &&  (i >= hor_kw_lim1) && (i <= hor_kw_lim2)
                    count2 = count2 + 1;
                    sw_kw_hor(count2) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kw_cl_select_hor(count2) = kw_CL_numerical_hor(i);
                end
               
            end
%}
            
            for i = 1:n_pts
            
                if ((kw_CL_numerical_hor(i) < 0))
                    
                    kw_CL_numerical_hor(i) = 0;
                end
                
                if ((kg_CL_numerical_hor(i) < 0))
                    
                    kg_CL_numerical_hor(i) = 0;
                end
                
                
                                
                if ((kw_CL_numerical_hor(i) > 1))
                    
                    kw_CL_numerical_hor(i) = 1;
                end
                
                if ((kg_CL_numerical_hor(i) > 1))
                    
                    kg_CL_numerical_hor(i) = 1;
                end
            end
            
            
            for i = 1:n_pts
                if ((kg_CL_numerical_hor(i) > 0) && (isinf(kg_CL_numerical_hor(i)) == 0) && (kg_CL_numerical_hor(i) < 1))
                    count1 = count1+1;
                    sw_kg_hor(count1) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kg_cl_select_hor(count1) = kg_CL_numerical_hor(i);

                end

                if ((kw_CL_numerical_hor(i) > 0) && (isinf(kw_CL_numerical_hor(i)) == 0) && (kw_CL_numerical_hor(i) < 1))
                    count2 = count2 + 1;
                    sw_kw_hor(count2) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kw_cl_select_hor(count2) = kw_CL_numerical_hor(i);
                end
                
                 
               
                
               
            end
            
            
            %Now fit a chierici function to the numerical kr values, so it is
            %smooth and monotonic for further simulations.

            sw_kg_hor_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kg_CL_numerical_hor));
            sw_kw_hor_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kw_CL_numerical_hor));
            sw_max_kg_hor = max(sw_kg_hor_good);
            sw_min_kw_hor = min(sw_kw_hor_good);
            
            

            estimates = Chierici_optimiser(sw_kg_hor, sw_kw_hor, kg_cl_select_hor, kw_cl_select_hor,kgsgi, kwsirr, swirr,A_water, L_water, B_gas, M_gas);

            A_optim_hor = estimates(1);
            L_optim_hor = estimates(2);
            B_optim_hor= estimates(3);
            M_optim_hor = estimates(4);



            [subvol_struct(iii,jjj,kkk).krg_optim_hor, subvol_struct(iii,jjj,kkk).krw_optim_hor] = Chierici_rel_perm(subvol_struct(iii,jjj,kkk).sw_upscaled,swirr,kwsirr, kgsgi, A_optim_hor, L_optim_hor, B_optim_hor, M_optim_hor);

            subvol_struct(iii,jjj,kkk).krg_optim_hor(end) = 0;
            subvol_struct(iii,jjj,kkk).krw_optim_hor(1) = 0;

            %Assign upscaled values to the matlab data structures.
            subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor = kg_CL_numerical_hor;
            subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor = kw_CL_numerical_hor;
            subvol_struct(iii,jjj,kkk).chierici_estimates_hor = estimates;
            subvol_struct(iii,jjj,kkk).k_eff_mD_hor = k_eff_mD_hor;
            subvol_struct(iii,jjj,kkk).sw_max_kg_hor = sw_max_kg_hor;
            subvol_struct(iii,jjj,kkk).sw_min_kw_hor = sw_min_kw_hor;

            toc
            
            disp('Finished Horizontal upscaling post-processing')
            counttt = 0;
            for z = 1:4
                for x = 1:4
                    for y = 1:4
                        counttt = counttt+1;
                        
                        geo_mean_kr_2 = (subvol_struct(1,1,1).kg_mat(z,x,y,1));
                        
                    end
                end
            end
            
            geo_mean_kr = geomean(geo_mean_kr_2(:));
            
             err_kr2 = geo_mean_kr/geo_mean;
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %HORIZONTAL DIRECTION 2
            
            disp("horz dir 2");
            
            
                        
            total_wells_hor = 1;%Ny;
            headers = 6;

            kg_zeros_hor_2 = n_pts - sum(subvol_struct(iii,jjj,kkk).kg_phase_connected(:,2));
            kw_zeros_hor_2 = n_pts - sum(subvol_struct(iii,jjj,kkk).kw_phase_connected(:,2));

            ntt_hor_2 = n_pts*2 - kg_zeros_hor_2 - kw_zeros_hor_2;



            T = readtable(well_water_flux_filename_hor_2);
            
            
            S = vartype('numeric');
            
            A = T{:,S};
            
            
            %A = table2array(T);

            count = 0;
            well_flux_kg_hor_2 = zeros(n_pts, total_wells_hor);
            well_flux_kw_hor_2 = zeros(n_pts, total_wells_hor);
            well_flux_ka_hor_2 = 0;
            
            [aa,bb] = size(A);
            
            for i = 1:n_pts+1

                if (i == 1)
                    for j = 1:total_wells_hor
                        well_flux_ka_hor_2(1,j) = (A(1,j+1));
                    end
                    count = count +1;
                end

                if (i > 1) && (subvol_struct(iii,jjj,kkk).kg_phase_connected(i-1,2) > 0) %this is perm across x plane 
                    count = count+1;
                    for j = 1:total_wells_hor
                        well_flux_kg_hor_2(i-1,j) = (A(count,j+1));
                    end
                end
            end
            
           % xxx = subvol_struct(1,1,1).kw_phase_connected(:,:);

            for i = 1:(n_pts+1)
                
                if (i > 1) && (subvol_struct(iii,jjj,kkk).kw_phase_connected(i-1,2) > 0) %this is perm across x plane
                    count = count+1;
                    for j = 1:total_wells_hor
                        well_flux_kw_hor_2(i-1,j) = (A(count,j+1));
                    end
                end
            end

            for i = 1:n_pts
                well_flux_kw_av_hor_2(i,1) = sum(well_flux_kw_hor_2(i, :));
                well_flux_kg_av_hor_2(i,1) = sum(well_flux_kg_hor_2(i, :));
            end

            well_flux_ka_av_hor_2 = sum(well_flux_ka_hor_2(:, :));
            
            
            
            
            
            %Find pressure in the domain

            string = ['findstr /v "''" ', '"IMEX_upscaling_horizontal_2',s_append_base{1},sub_append,'_Grid_block_pressure', '.txt"'    '>', 'dummy02.txt'];
            dos(string)
            pressMat_IMEX_q_1 = dlmread('dummy02.txt');
            
            Ny_sub_buffer = (Ny_sub*10) + Ny_sub;

            pressMat_hor_2 = zeros(Nz_sub,Nx_sub, Ny_sub_buffer,ntt_hor_2);

            [~,n] = size(pressMat_IMEX_q_1);
            count = 0;

            remd =  n - rem(Nz_sub*Ny_sub_buffer*Nx_sub, n);

            if (remd == n)
                remd =0;
            end

            for t = 1:(ntt_hor_2+2) %1:ntt_hor
                   
                if (t==1)
                    count = 0;
                else
                    count = count + remd;
                end
                
                
               % count = count + remd;
                
%%%%%%%% NOT SURE IF THIS IS RIGHT??

                for i = Nz_sub:-1:1
                    for k = 1:Ny_sub_buffer %1:Ny_sub %Ny_sub_buffer:-1:1
                        for j = 1:Nx_sub
                        
                            
                            count  = count + 1 ;
                            row = ceil(count/n);
                            col = rem(count,n);
                                                        
                            if (col==0)
                                col = n;
                            end

                            pressMat_hor_2(i,j,k,t) = pressMat_IMEX_q_1(row,col);
                        end
                    end
                end
            end

            %Find pressure drops.

            press_drop_av_hor_2 = zeros(ntt_hor_2,1);
           

            %Now we need to find the constant Pressure boundary along the
%             buffer zone along the x axis, can be constant Z, only comparing
%             Y pressures along constant X
%             First for the inlet side
            

            %INLET
            
            countj = 0;
            count2 = 0;
            j_nonzero_y_inlet = [];
            j_nonzero_y_outlet = [];
            
            pressureMat_hor_y_inlet_filtered = zeros(ntt_hor_2+2, ((Ny_sub*10)/2));
            
                       
            
            
            for t = 2:(ntt_hor_2+2)
                disp("in t loop");
                j_nonzero_y_inlet = [];
                
                
                for j = ((Ny_sub*10)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                    
                    disp("in j loop");
                    
                    countj = countj +1;
                    disp(j);
                    
                    pressureMat_hor_y_inlet = pressMat_hor_2(1,:,j,t); %check if P is constant in X-Y plane
                    
                    
                    
                    pressureMat_hor_y_inlet = pressureMat_hor_y_inlet(:);
                    
                    
                    disp(pressureMat_hor_y_inlet(:));
                    
                    diff_p = diff(pressureMat_hor_y_inlet);
                    %disp(diff_p);
                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant

                        
                        count2 = count2+1;
                        
                        
                        avg_P = mean(pressureMat_hor_y_inlet);
                        disp("mean:");
                        disp(avg_P);

                        pressureMat_hor_y_inlet_filtered(t,j) = avg_P ;
                    end
                    
                    
                        
    
                end
                
                count_j = 0;
                
                for j = ((Ny_sub*10)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_hor_y_inlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        
                        j_nonzero_y_inlet(t,count_j) = j;
                    end

                    
                end
                
                j_best_inlet_y(t) = min(j_nonzero_y_inlet(t,:));
                
                pressure_hor_y_mean_final_inlet(t,1) = pressureMat_hor_y_inlet_filtered(t,j_best_inlet_y(t));
                
                
                    
                    
            end
    
            
            disp("done with inlet cal");
            
            
%OUTLET HORZ DIR 1

            %OUTLET
            
            countj = 0;
            count2 = 0;
            
            
            pressureMat_hor_y_outlet_filtered = zeros(ntt_hor_2+2, ((Ny_sub*10)+Ny_sub));
            
            for t = 2:(ntt_hor_2+2)
                disp("in t loop");
                j_nonzero_y_outlet = [];
                
                
                for j = (((Ny_sub*10)/2)+Ny_sub+1):((Ny_sub*10)+Ny_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                    
                    disp("in j loop");
                    countj = countj +1;
                    disp(j);
                    count3 = 0;
                    
                    pressureMat_hor_y_outlet = pressMat_hor_2(1,:,j,t); %check if P is constant in X-Y plane
                                        
                    
                    pressureMat_hor_y_outlet = pressureMat_hor_y_outlet(:);
                    
                    
                    disp(pressureMat_hor_y_outlet(:));
                    
                    diff_p = diff(pressureMat_hor_y_outlet);
                    disp(diff_p);
                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant

                  
                        count2 = count2+1;
                       
                        
                        avg_P = mean(pressureMat_hor_y_outlet);
                        disp("mean:");
                        disp(avg_P);

                        pressureMat_hor_y_outlet_filtered(t,j) = avg_P ;
                    end
                    
                   
                    j = j+1;
                        
    
                end
                
                count_j = 0;
                
                
                for j = (((Ny_sub*10)/2)+Ny_sub):((Ny_sub*10)+Ny_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_hor_y_outlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        
                        j_nonzero_y_outlet(t,count_j) = j;
                    end
                end
                
                j_best_outlet_y(t) = min(j_nonzero_y_outlet(t,:));
                
                pressure_hor_y_mean_final_outlet(t,1) = pressureMat_hor_y_outlet_filtered(t,j_best_outlet_y(t));
                
                
                    
                    
            end

           
           
            
            
            
            
            
            
            j_best_inlet_y = j_best_inlet_y(:);
            j_best_outlet_y = j_best_outlet_y(:);

            for k = 2:(ntt_hor_2+2) %total = 58 times --> t = 1 is for abs perm, but  have time = zero here too
                
                press_drop_av_hor_2((k-1),1) = pressure_hor_y_mean_final_inlet(k,1) - pressure_hor_y_mean_final_outlet(k,1);
            end

            press_drop_av_ka_hor_2 = press_drop_av_hor_2(1); % (mean(data_struct.pressMat(:,1,2))- mean(data_struct.pressMat(:,end,2)));

            press_drop_av_new_hor_2 = press_drop_av_hor_2(2:end); %this should be 57 points
            
            %from 1 to 
            
            press_drop_av_kg_hor_2 = zeros(n_pts,1);
            press_drop_av_kw_hor_2 = zeros(n_pts,1);
            

            press_drop_av_kg_hor_2(1:(n_pts - kg_zeros_hor_2),1) =   press_drop_av_new_hor_2(1:(n_pts - kg_zeros_hor_2));
            
            press_drop_av_kw_hor_2(1:(n_pts - kw_zeros_hor_2),1) =   press_drop_av_new_hor_2((n_pts - kg_zeros_hor_2+1):((2*n_pts) - kw_zeros_hor_2 - kg_zeros_hor_2));

            


            %Work out effective k, kr based on pressure drops and fluxes.
            % we are calculating p drop over buffer zone too   
            
            
            k_eff_hor_2 = 0;
            
            well_flux_ka_av_hor_2 = Qw_upscaling_y(1,1);
            
            k_eff_hor_2_frac_top = (well_flux_ka_av_hor_2/(24*60*60))*mu_w*(j_best_outlet_y(2)-j_best_inlet_y(2))*ds_y;
            
            k_eff_hor_2_frac_bottom = ds_x*ds_z*Nx_sub*Nz_sub*press_drop_av_ka_hor_2*1000;

            k_eff_hor_2_buffer = (k_eff_hor_2_frac_top/k_eff_hor_2_frac_bottom);  
            
            k_eff_mD_hor_2_buffer = k_eff_hor_2_buffer*1013250273830886.6;
            
            
            k_eff_mD_hor_2 = (Ny_sub)/((((j_best_outlet_y(2)-j_best_inlet_y(2)))/k_eff_mD_hor_2_buffer)-((j_best_outlet_y(2)-j_best_inlet_y(2)-Ny_sub)/perm_mat_buffer));
            
            
            

            disp("keff md horz")
            disp(k_eff_mD_hor_2);

            disp("keff md incl kr");
            
            k_eff_mD_hor_2_inclkr = k_eff_mD_hor_2/kw_fine_VL(end);
            disp(k_eff_mD_hor_2_inclkr);
            
            
           
            
            
            
            
            
            %this is the kr incl. the buffer zone - we need to assume
            %layers are in series again, follow same principle
            
             %n_pts*2 - kg_zeros_hor
             
             kg_CL_numerical_hor_2_buffer_2_frac_top = (well_flux_kg_av_hor_2(1:(n_pts-kg_zeros_hor_2))./(24*60*60)).*mu_w.*(j_best_outlet_y(3:(n_pts-kg_zeros_hor_2+2)) - j_best_inlet_y(3:(n_pts-kg_zeros_hor_2+2))).*ds_y;
             
             kg_CL_numerical_hor_2_buffer_2_frac_bottom = ds_x*ds_z*Nx_sub*Nz_sub.*press_drop_av_kg_hor_2(1:(n_pts-kg_zeros_hor_2)).*1000;
             
            kg_CL_numerical_hor_2_buffer_2 = kg_CL_numerical_hor_2_buffer_2_frac_top./kg_CL_numerical_hor_2_buffer_2_frac_bottom;
            
            kg_CL_numerical_hor_2_buffer_md = kg_CL_numerical_hor_2_buffer_2*1013250273830886.6;

            kg_CL_numerical_hor_2_md = (Ny_sub)./((((j_best_outlet_y(3:(n_pts-kg_zeros_hor_2+2))-j_best_inlet_y(3:(n_pts-kg_zeros_hor_2+2))))./kg_CL_numerical_hor_2_buffer_md)-((j_best_outlet_y(3:(n_pts-kg_zeros_hor_2+2))-j_best_inlet_y(3:(n_pts-kg_zeros_hor_2+2))-Ny_sub)./perm_mat_buffer));
            
            kg_CL_numerical_hor_2_try =  (kg_CL_numerical_hor_2_md)./k_eff_mD_hor_2;
            
            
            
            
            
            
            

            kw_CL_length_hor_2 = (j_best_outlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2)) - j_best_inlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2))).*ds_y;
            
            kw_CL_numerical_hor_2_buffer_2_frac_top = (well_flux_kw_av_hor_2((kw_zeros_hor_2+1):(n_pts))./(24*60*60)).*mu_w.*kw_CL_length_hor_2;
            
            
            
            
            kw_CL_numerical_hor_2_buffer_2_frac_bottom = ds_x*ds_z*Nx_sub*Nz_sub.*press_drop_av_kw_hor_2(1:(n_pts-kw_zeros_hor_2)).*1000;
            
            kw_CL_numerical_hor_2_buffer_2 = kw_CL_numerical_hor_2_buffer_2_frac_top./kw_CL_numerical_hor_2_buffer_2_frac_bottom;
            
            kw_CL_numerical_hor_2_buffer_md =  (kw_CL_numerical_hor_2_buffer_2*1013250273830886.6);
            
            
            kw_CL_numerical_hor_2_mD = (Ny_sub)./((((j_best_outlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2))-j_best_inlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2))))./kw_CL_numerical_hor_2_buffer_md)-((j_best_outlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2))-j_best_inlet_y((n_pts-kg_zeros_hor_2+3):((n_pts*2)-kg_zeros_hor_2-kw_zeros_hor_2+2))-Ny_sub)./perm_mat_buffer));
            
            
            
            kw_CL_numerical_hor_2_try =  (kw_CL_numerical_hor_2_mD)./k_eff_mD_hor_2;
            
            
            
            kg_CL_numerical_hor_2 = zeros(n_pts, 1);
            kw_CL_numerical_hor_2 = zeros(n_pts, 1);
            
            
            
            
            
            count_zero = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kg_av_hor_2(ii) == 0)
                    count_zero = count_zero + 1;
                    kg_CL_numerical_hor_2(ii,1) = 0;
                    
                end
                
               if (well_flux_kg_av_hor_2(ii) > 0)
                    kg_CL_numerical_hor_2((ii+count_zero),1) = kg_CL_numerical_hor_2_try(ii,1);
                end
                
            end
            
            
           count_zero = 0;
           count_non = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kw_av_hor_2(ii) == 0)
                    
                    kw_CL_numerical_hor_2(ii,1) = 0;
                    
                end
                
               if (well_flux_kw_av_hor_2(ii) > 0)
                   count_non = count_non + 1;
                    kw_CL_numerical_hor_2((ii),1) = kw_CL_numerical_hor_2_try(count_non,1);
                end
                
            end
            
            %kg_CL_numerical_hor =kg_CL_numerical_hor_try(1:end,1);
            
            %kw_CL_numerical_hor =kw_CL_numerical_hor_try(1:end,1);
            
            

            sw_kg_hor_2 = 0;
            kg_cl_select_hor_2 = 0;
            kw_cl_select_hor_2 = 0;
            sw_kw_hor_2 = 0;
            count1 = 0;
            count2 = 0;
            
            %{
            ASK SAM J ABOUT THIS - I DONT UNDERSTAND

            %Find limits of numerical kr values.

            hor_kg_lim1 = sum(~isnan(kg_CL_numerical_hor)) - ceil(sum(~isnan(kg_CL_numerical_hor))/4);
            
            hor_kg_lim2 = sum(~isnan(kg_CL_numerical_hor));
            
            hor_kw_lim1 = sum(isnan(kw_CL_numerical_hor))+1;
            hor_kw_lim2 = ceil((n_pts - sum(isnan(kw_CL_numerical_hor)))./4)+sum(isnan(kw_CL_numerical_hor)) ;

            for i = 1:n_pts
                if (~isnan(kg_CL_numerical_hor(i)) && (kg_CL_numerical_hor(i) > 0) && (isinf(kg_CL_numerical_hor(i)) == 0) && (i >= hor_kg_lim1) && (i <= hor_kg_lim2))
                    count1 = count1+1;
                    sw_kg_hor(count1) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kg_cl_select_hor(count1) = kg_CL_numerical_hor(i);

                end

                if (isnan(kw_CL_numerical_hor(i)) == 0) && (kw_CL_numerical_hor(i) > 0) && (isinf(kw_CL_numerical_hor(i)) == 0) && ((kw_CL_numerical_hor(i)) < 1) &&  (i >= hor_kw_lim1) && (i <= hor_kw_lim2)
                    count2 = count2 + 1;
                    sw_kw_hor(count2) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kw_cl_select_hor(count2) = kw_CL_numerical_hor(i);
                end
               
            end
%}
            
             for i = 1:n_pts
            
                if ((kw_CL_numerical_hor_2(i) < 0))
                    
                    kw_CL_numerical_hor_2(i) = 0;
                end
                
                if ((kg_CL_numerical_hor_2(i) < 0))
                    
                    kg_CL_numerical_hor_2(i) = 0;
                end
                
                
                                
                if ((kw_CL_numerical_hor_2(i) > 1))
                    
                    kw_CL_numerical_hor_2(i) = 1;
                end
                
                if ((kg_CL_numerical_hor_2(i) > 1))
                    
                    kg_CL_numerical_hor_2(i) = 1;
                end
            end
            
            
            
            for i = 1:n_pts
                if ((kg_CL_numerical_hor_2(i) > 0) && (isinf(kg_CL_numerical_hor_2(i)) == 0) && (kg_CL_numerical_hor_2(i) < 1))
                    count1 = count1+1;
                    sw_kg_hor_2(count1) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kg_cl_select_hor_2(count1) = kg_CL_numerical_hor_2(i);

                end

                if ((kw_CL_numerical_hor_2(i) > 0) && (isinf(kw_CL_numerical_hor_2(i)) == 0) && (kw_CL_numerical_hor_2(i) < 1))
                    count2 = count2 + 1;
                    sw_kw_hor_2(count2) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kw_cl_select_hor_2(count2) = kw_CL_numerical_hor_2(i);
                end
                
                
                                

               
               
            end
            
            
            %Now fit a chierici function to the numerical kr values, so it is
            %smooth and monotonic for further simulations.

            sw_kg_hor_2_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kg_CL_numerical_hor_2));
            sw_kw_hor_2_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kw_CL_numerical_hor_2));
            sw_max_kg_hor_2 = max(sw_kg_hor_2_good);
            sw_min_kw_hor_2 = min(sw_kw_hor_2_good);
            
            

            estimates = Chierici_optimiser(sw_kg_hor_2, sw_kw_hor_2, kg_cl_select_hor_2, kw_cl_select_hor_2,kgsgi, kwsirr, swirr,A_water, L_water, B_gas, M_gas);

            A_optim_hor_2 = estimates(1);
            L_optim_hor_2 = estimates(2);
            B_optim_hor_2 = estimates(3);
            M_optim_hor_2 = estimates(4);



            [subvol_struct(iii,jjj,kkk).krg_optim_hor_2, subvol_struct(iii,jjj,kkk).krw_optim_hor_2] = Chierici_rel_perm(subvol_struct(iii,jjj,kkk).sw_upscaled,swirr,kwsirr, kgsgi, A_optim_hor_2, L_optim_hor_2, B_optim_hor_2, M_optim_hor_2);

            subvol_struct(iii,jjj,kkk).krg_optim_hor_2(end) = 0;
            subvol_struct(iii,jjj,kkk).krw_optim_hor_2(1) = 0;

            %Assign upscaled values to the matlab data structures.
            subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2 = kg_CL_numerical_hor_2;
            subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2 = kw_CL_numerical_hor_2;
            subvol_struct(iii,jjj,kkk).chierici_estimates_hor_2 = estimates;
            subvol_struct(iii,jjj,kkk).k_eff_mD_hor_2 = k_eff_mD_hor_2;
            subvol_struct(iii,jjj,kkk).sw_max_kg_hor_2 = sw_max_kg_hor_2;
            subvol_struct(iii,jjj,kkk).sw_min_kw_hor_2 = sw_min_kw_hor_2;

            toc
            
            disp('Finished Horizontal upscaling post-processing')
            
            
            %%
            counttt = 0;
            for z = 1:4
                for x = 1:4
                    for y = 1:4
                        counttt = counttt+1;
                        
                        geo_mean_kr_2 = (subvol_struct(1,1,1).kg_mat(z,x,y,1));
                        
                    end
                end
            end
            
            geo_mean_kr = geomean(geo_mean_kr_2(:));
            
             err_kr2 = geo_mean_kr/geo_mean;
%             
            

            
            
            %}
            
            
            
            
            
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            
            
            
            
            
            
            
            
            %VERTICAL DIRECTION
            
            disp("vertical dir");
            
            %well completed in each gridblock
            
            total_wells_vert = Nx_sub*Ny_sub;
           
            headers = 6;

            kg_zeros_vert = n_pts - sum(subvol_struct(iii,jjj,kkk).kg_phase_connected(:,1));
            kw_zeros_vert = n_pts - sum(subvol_struct(iii,jjj,kkk).kw_phase_connected(:,1));

            ntt_vert = n_pts*2 - kg_zeros_vert - kw_zeros_vert;
            
            T = readtable(well_water_flux_filename_vert);
            
            
            S = vartype('numeric');
            
            A = T{:,S};
            
            
            %A = table2array(T);

            count = 0;
            
            well_flux_kg_vert = zeros(n_pts, total_wells_vert);
            well_flux_kw_vert = zeros(n_pts, total_wells_vert);
            well_flux_ka_vert = 0;
            
            [aa,bb] = size(A);
            
            for i = 1:n_pts+1

                if (i == 1)
                    for j = 1:total_wells_vert
                        well_flux_ka_vert(1,j) = (A(1,j+1));
                    end
                    count = count +1;
                end

                if (i > 1) && (subvol_struct(iii,jjj,kkk).kg_phase_connected(i-1,1) > 0) %this is perm across x plane 
                    count = count+1;
                    for j = 1:total_wells_vert
                        well_flux_kg_vert(i-1,j) = (A(count,j+1));
                    end
                end
            end
            
            for i = 1:(n_pts+1)
                
                if (i > 1) && (subvol_struct(iii,jjj,kkk).kw_phase_connected(i-1,1) > 0) %this is perm across x plane
                    count = count+1;
                    for j = 1:total_wells_vert
                        well_flux_kw_vert(i-1,j) = (A(count,j+1));
                    end
                end
            end

            %we have more than 1 well
            
            
            for i = 1:n_pts
                well_flux_kw_av_vert(i,1) = sum(well_flux_kw_vert(i, 1:total_wells_vert));
                well_flux_kg_av_vert(i,1) = sum(well_flux_kg_vert(i, 1:total_wells_vert));
            end

            well_flux_ka_av_vert = sum(well_flux_ka_vert(:, total_wells_vert));

            

            %Find pressure in the domain

            string = ['findstr /v "''" ', '"IMEX_upscaling_vertical',s_append_base{1},sub_append,'_Grid_block_pressure', '.txt"'    '>', 'dummy03.txt'];
            dos(string)
            pressMat_IMEX_q_1 = dlmread('dummy03.txt');
            
            Nz_sub_buffer = (Nz_sub*100) + Nz_sub;

            pressMat_vert = zeros(Nz_sub_buffer,Nx_sub, Ny_sub,ntt_vert);

            [~,n] = size(pressMat_IMEX_q_1);
            count = 0;

            remd =  n - rem(Nz_sub_buffer*Ny_sub*Nx_sub, n);

            if (remd == n)
                remd =0;
            end

            for t = 1:(ntt_vert+2) %1:ntt_hor
                   
                if (t==1)
                    count = 0;
                else
                    count = count + remd;
                end
                
                
               % count = count + remd;
                
%%%%%%%% NOT SURE IF THIS IS RIGHT??

                for i = 1:Nz_sub_buffer % Not sure if this is right Nz_sub:-1:1
                    for k = 1:Ny_sub %_buffer %1:Ny_sub %Ny_sub_buffer:-1:1
                        for j = 1:Nx_sub
                        
                            
                            count  = count + 1 ;
                            row = ceil(count/n);
                            col = rem(count,n);
                                                        
                            if (col==0)
                                col = n;
                            end

                            pressMat_vert(i,j,k,t) = pressMat_IMEX_q_1(row,col);
                        end
                    end
                end
            end

            %Find pressure drops.

            press_drop_av_vert = zeros(ntt_vert,1);
            

           
            
            %Now we need to find the constant Pressure boundary along the
%             buffer zone along the x axis, can be constant Z, only comparing
%             Y pressures along constant X
%             First for the inlet side
            

            %INLET
            
            countj = 0;
            count2 = 0;
            j_nonzero_z_inlet = [];
            j_nonzero_z_outlet = [];
            
            pressureMat_vert_z_inlet_filtered = zeros(ntt_vert+2, ((Nz_sub*100)/2));
            
            for t = 2:(ntt_vert+2)
                disp("in t loop");
                
                j_nonzero_z_inlet = [];
                
                for j = ((Nz_sub*100)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                    
                    disp("in j loop");
                    
                    count3 = 0;
                    countj = countj +1;
                    
                    for i = 1:Nx_sub
                        
                        for k = 1:Ny_sub
                            
                            count3 = count3+1;
                            
                            pressureMat_vert_z_inlet(count3) = pressMat_vert(j,i,k,t); %check if P is constant in X-Y plane
                            
                            
                        end
                    end
                    
                    
                    pressureMat_vert_z_inlet = pressureMat_vert_z_inlet(:);
                    
                    
                    diff_p = diff(pressureMat_vert_z_inlet(:));
                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant

                       
                        count2 = count2+1;
                       
                        
                        avg_P = mean(pressureMat_vert_z_inlet);
                   

                        pressureMat_vert_z_inlet_filtered(t,j) = avg_P ;
                    end
                    
              
                        
    
                end
                
                count_j = 0;
                
                for j = ((Nz_sub*100)/2):-1:1 %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_vert_z_inlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        
                        j_nonzero_z_inlet(t,count_j) = j;
                    end

                    
                end
                
                j_best_inlet_z(t) = min(j_nonzero_z_inlet(t,:));
                
                pressure_vert_z_mean_final_inlet(t,1) = pressureMat_vert_z_inlet_filtered(t,j_best_inlet_z(t));
                
                
                    
                    
            end
    
            
            disp("done with inlet cal");
            
            
%OUTLET HORZ DIR 1

            %OUTLET
            
            countj = 0;
            count2 = 0;
            
            
            pressureMat_vert_z_outlet_filtered = zeros(ntt_vert+2, ((Nz_sub*100)+Nz_sub));
            
            for t = 2:(ntt_vert+2)
                j_nonzero_z_outlet = [];
                disp("in t loop");
                
                
                for j = (((Nz_sub*100)/2)+Nz_sub+1):((Nz_sub*100)+Nz_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                    
                    disp("in j loop");
                    countj = countj +1;
                    disp(j);
                    count3 = 0;
                    
                     for i = 1:Nx_sub
                        for k = 1:Ny_sub
                            
                            
                            count3 = count3+1;
                            
                            pressureMat_vert_z_outlet(count3) = pressMat_vert(j,i,k,t); %check if P is constant in X-Y plane
                            
                            
                        end
                    end
                                        
                    
                    pressureMat_vert_z_outlet = pressureMat_vert_z_outlet(:);
                    
                    
                    diff_p = diff(pressureMat_vert_z_outlet);

                    
                    size_p = size(diff_p(:));

                    if (all(abs(diff_p(:)) < 0.1)) %then we know the pressures are constant


                        
                        avg_P = mean(pressureMat_vert_z_outlet);


                        pressureMat_vert_z_outlet_filtered(t,j) = avg_P ;
                    end
                    
                   
                    j = j+1;
                        
    
                end
                
                count_j = 0;
                
                
                for j = (((Nz_sub*100)/2)+Nz_sub):((Nz_sub*100)+Nz_sub) %looping through each position along the x axis, before domain is reached, from domain moving outwards
                
                    if (pressureMat_vert_z_outlet_filtered(t,j) > 0)
                        
                        count_j = count_j + 1;
                        
                        j_nonzero_z_outlet(t,count_j) = j;
                    end
                end
                
                j_best_outlet_z(t) = max(j_nonzero_z_outlet(t,:));
                
                pressure_vert_z_mean_final_outlet(t,1) = pressureMat_vert_z_outlet_filtered(t,j_best_outlet_z(t));
                
                
                    
                    
            end
            
            
            j_best_outlet_z = j_best_outlet_z(:);
            
            j_best_inlet_z = j_best_inlet_z(:);


            for k = 2:(ntt_vert+2)
                press_drop_av_vert(k-1,1) = pressure_vert_z_mean_final_inlet(k,1)-pressure_vert_z_mean_final_outlet(k,1);
            end

            press_drop_av_ka_vert = press_drop_av_vert(1); % (mean(data_struct.pressMat(:,1,2))- mean(data_struct.pressMat(:,end,2)));

            press_drop_av_new_vert = press_drop_av_vert(2:end);
            press_drop_av_kg_vert = zeros(n_pts,1);
            press_drop_av_kw_vert = zeros(n_pts,1);

            press_drop_av_kg_vert(1:(n_pts - kg_zeros_vert),1) = press_drop_av_new_vert((1:(n_pts - kg_zeros_vert))); % -press_drop_av_hydro ;
            press_drop_av_kw_vert(1:(n_pts - kw_zeros_vert),1) = press_drop_av_new_vert((n_pts - kg_zeros_vert+1):((2*n_pts) - kw_zeros_vert - kg_zeros_vert)); % - press_drop_av_hydro ;

            %Work out effective k, kr based on pressure drops and fluxes.
            % we are calculating p drop over buffer zone too   
            

            
            k_eff_hor = 0;
            
            well_flux_ka_av_vert = Qw_upscaling_z(1);
            
            press_gravity = (rho_w*g_accel*(j_best_outlet_z(2)-j_best_inlet_z(2))*ds_z)/1000; %have to divide by 1000 to get in kPa
            
            press_eff = press_drop_av_ka_vert - press_gravity;

            k_eff_vert_buffer = ((well_flux_ka_av_vert/(24*60*60))*mu_w*(((j_best_outlet_z(2)-j_best_inlet_z(2))*ds_z))./((ds_x*ds_y*Nx_sub*Ny_sub)*press_eff*1000));
            
           % k_eff_hor = ((well_flux_ka_av_hor/(24*60*60))*mu_w*(Lx_sub)./((ds_y*ds_z*Ny_sub*Nz_sub)*press_drop_av_ka_hor*1000));

            k_eff_mD_vert_buffer = k_eff_vert_buffer*1013250273830886.6;
            
            k_eff_mD_vert = (Nz_sub)/((((j_best_outlet_z(2)-j_best_inlet_z(2)))/k_eff_mD_vert_buffer)-((j_best_outlet_z(2)-j_best_inlet_z(2)-Nz_sub)/perm_mat_buffer));
            

            

            disp("keff md vert")
            disp(k_eff_mD_vert);
            
            disp("keff md vert incl kr");
            
            k_eff_mD_vert_inclkr = k_eff_mD_vert/kw_fine_VL(end);
            disp(k_eff_mD_vert_inclkr);
            
     
            %GAS REL PERM
            
            press_gravity_kg = zeros(n_pts);
            
            press_gravity_kg = (rho_w.*g_accel.*(j_best_outlet_z(3:(n_pts-kg_zeros_vert+2))-j_best_inlet_z(3:(n_pts-kg_zeros_vert+2))).*ds_z)./1000; %have to divide by 1000 to get in kPa
            press_gravity_kg = press_gravity_kg(:);
            
            press_gravity_kg((n_pts - kg_zeros_vert+1):n_pts) = 0;
            
            press_eff_kg = press_drop_av_kg_vert - press_gravity_kg;
            
            
            
             kg_CL_numerical_vert_buffer_2_frac_top = (well_flux_kg_av_vert(1:(n_pts-kg_zeros_vert))./(24*60*60)).*mu_w.*(j_best_outlet_z(3:(n_pts-kg_zeros_vert+2)) - j_best_inlet_z(3:(n_pts-kg_zeros_vert+2))).*ds_z;
             kg_CL_numerical_vert_buffer_2_frac_bottom = ds_y*ds_x*Ny_sub*Nx_sub.*press_eff_kg(1:(n_pts-kg_zeros_vert)).*1000;
             
            kg_CL_numerical_vert_buffer_2 = kg_CL_numerical_vert_buffer_2_frac_top./kg_CL_numerical_vert_buffer_2_frac_bottom;
            
            kg_CL_numerical_vert_buffer_md = kg_CL_numerical_vert_buffer_2*1013250273830886.6;

            kg_CL_numerical_vert_md = (Nz_sub)./((((j_best_outlet_z(3:(n_pts-kg_zeros_vert+2))-j_best_inlet_z(3:(n_pts-kg_zeros_vert+2))))./kg_CL_numerical_vert_buffer_md)-((j_best_outlet_z(3:(n_pts-kg_zeros_vert+2))-j_best_inlet_z(3:(n_pts-kg_zeros_vert+2))-Nz_sub)./perm_mat_buffer));
            
            kg_CL_numerical_vert_try =  (kg_CL_numerical_vert_md)./k_eff_mD_vert;
            
            
            
            
            
            %WATER REL PERM
            
            %(n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2)
            
            press_gravity_kw = (rho_w.*g_accel.*(j_best_outlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))-j_best_inlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))).*ds_z)./1000; %have to divide by 1000 to get in kPa
            
            press_gravity_kw = press_gravity_kw(:);
            
            press_gravity_kw((n_pts - kw_zeros_vert+1):n_pts) = 0;
            
            press_eff_kw = press_drop_av_kw_vert - press_gravity_kw;
            
            
            
            
            kw_CL_length_vert = (j_best_outlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2)) - j_best_inlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))).*ds_z;
            
            kw_CL_length_vert = kw_CL_length_vert(:);
            
            kw_CL_numerical_vert_buffer_2_frac_top = (well_flux_kw_av_vert((kw_zeros_vert+1):(n_pts))./(24*60*60)).*mu_w.*kw_CL_length_vert;
            
            
            
            
            kw_CL_numerical_vert_buffer_2_frac_bottom = ds_y*ds_x*Ny_sub*Nx_sub.*press_eff_kw(1:(n_pts-kw_zeros_vert)).*1000;
            
            kw_CL_numerical_vert_buffer_2 = kw_CL_numerical_vert_buffer_2_frac_top./kw_CL_numerical_vert_buffer_2_frac_bottom;
            
            kw_CL_numerical_vert_buffer_md =  (kw_CL_numerical_vert_buffer_2*1013250273830886.6);
            
            
            kw_CL_numerical_vert_mD = (Nz_sub)./((((j_best_outlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))-j_best_inlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))))./kw_CL_numerical_vert_buffer_md)-((j_best_outlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))-j_best_inlet_z((n_pts-kg_zeros_vert+3):((n_pts*2)-kg_zeros_vert-kw_zeros_vert+2))-Nz_sub)./perm_mat_buffer));
            
            
            
            kw_CL_numerical_vert_try =  (kw_CL_numerical_vert_mD)./k_eff_mD_vert;
            
            
            
            
            
            
            kg_CL_numerical_vert = zeros(n_pts, 1);
            kw_CL_numerical_vert = zeros(n_pts, 1);
            
            
            
            
            
            count_zero = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kg_av_vert(ii) == 0)
                    count_zero = count_zero + 1;
                    kg_CL_numerical_vert(ii,1) = 0;
                    
                end
                
               if (well_flux_kg_av_vert(ii) > 0)
                    kg_CL_numerical_vert((ii+count_zero),1) = kg_CL_numerical_vert_try(ii,1);
                end
                
            end
            
            
           count_zero = 0;
           count_non = 0;
            
            for ii = 1:n_pts
                
                if (well_flux_kw_av_vert(ii) == 0)
                    
                    kw_CL_numerical_vert(ii,1) = 0;
                    
                end
                
               if (well_flux_kw_av_vert(ii) > 0)
                   count_non = count_non + 1;
                    kw_CL_numerical_vert((ii),1) = kw_CL_numerical_vert_try(count_non,1);
                end
                
            end
            
            
            

            sw_kg_vert = 0;
            kg_cl_select_vert = 0;
            kw_cl_select_vert = 0;
            sw_kw_vert = 0;
            count1 = 0;
            count2 = 0;
            
            for i = 1:n_pts
                
                
                if ((kw_CL_numerical_vert(i) < 0))
                    
                    kw_CL_numerical_vert(i) = 0;
                end
                
                if ((kg_CL_numerical_vert(i) < 0))
                    
                    kg_CL_numerical_vert(i) = 0;
                end
                
                
                                
                if ((kw_CL_numerical_vert(i) > 1))
                    
                    kw_CL_numerical_vert(i) = 1;
                end
                
                if ((kg_CL_numerical_vert(i) > 1))
                    
                    kg_CL_numerical_vert(i) = 1;
                end
                
            end
            
            for i = 1:n_pts
                if ((kg_CL_numerical_vert(i) > 0) && (isinf(kg_CL_numerical_vert(i)) == 0) && (kg_CL_numerical_vert(i) < 1))
                    count1 = count1+1;
                    sw_kg_vert(count1) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kg_cl_select_vert(count1) = kg_CL_numerical_vert(i);

                end

                if ((kw_CL_numerical_vert(i) > 0) && (isinf(kw_CL_numerical_vert(i)) == 0) && (kw_CL_numerical_vert(i) < 1))
                    count2 = count2 + 1;
                    sw_kw_vert(count2) = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                    kw_cl_select_vert(count2) = kw_CL_numerical_vert(i);
                end
                
                

               
            end
            
            
            %Now fit a chierici function to the numerical kr values, so it is
            %smooth and monotonic for further simulations.

            sw_kg_vert_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kg_CL_numerical_vert));
            sw_kw_vert_good = subvol_struct(iii,jjj,kkk).sw_upscaled(~isnan(kw_CL_numerical_vert));
            sw_max_kg_vert = max(sw_kg_vert_good);
            sw_min_kw_vert = min(sw_kw_vert_good);
            
            

            estimates = Chierici_optimiser(sw_kg_vert, sw_kw_vert, kg_cl_select_vert, kw_cl_select_vert,kgsgi, kwsirr, swirr,A_water, L_water, B_gas, M_gas);

            A_optim_vert = estimates(1);
            L_optim_vert= estimates(2);
            B_optim_vert= estimates(3);
            M_optim_vert = estimates(4);



            [subvol_struct(iii,jjj,kkk).krg_optim_vert, subvol_struct(iii,jjj,kkk).krw_optim_vert] = Chierici_rel_perm(subvol_struct(iii,jjj,kkk).sw_upscaled,swirr,kwsirr, kgsgi, A_optim_vert, L_optim_vert, B_optim_vert, M_optim_vert);

            subvol_struct(iii,jjj,kkk).krg_optim_vert(end) = 0;
            subvol_struct(iii,jjj,kkk).krw_optim_vert(1) = 0;

            %Assign upscaled values to the matlab data structures.
            subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert = kg_CL_numerical_vert;
            subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert = kw_CL_numerical_vert;
            subvol_struct(iii,jjj,kkk).chierici_estimates_vert = estimates;
            subvol_struct(iii,jjj,kkk).k_eff_mD_vert = k_eff_mD_vert;
            subvol_struct(iii,jjj,kkk).sw_max_kg_vert = sw_max_kg_vert;
            subvol_struct(iii,jjj,kkk).sw_min_kw_vert = sw_min_kw_vert;

            toc
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
           
            
            disp('Finished Vertical upscaling post-processing')
          
           
        
        end
    end
end

disp('Finished postprocessing upscaling results')