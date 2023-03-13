%Structures 
clc
clear all
close all
load("./Output/post_A1_1.mat")

%parpool(2, 'IdleTimeout', Inf) % for parallel

%Define base names for various CMG files
s1 = 'mod_pcwmax';
s2 = 'mod_kabs';
s3 = 'mod_por';
s4 = 'sat_initial';
s5 = 'press_initial';
s6 = '.inc';
s7 = 'mod_phase_krg_';
s8 = 'mod_phase_krw_';
s9 = 'mod_phase_krg_por_';
s10 = 'mod_phase_krw_por_';

%% datastrcuture%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create datastrcuture names
%Test_workspace = ['Test_workspace',s_append_base,'.mat'];
Matlab_datastruct = ['Matlab_datastruct',s_append_base,'.mat'];
Matlab_subvol_struct = ['Matlab_subvol_struct',s_append_base,'.mat'];
Matlab_workspace_title = ['Matlab_workspace',s_append_base,'.mat'];

%Create the matlab data structure to store the created permebility,porosity files etc.
data_struct = struct('xMat',[],'yMat',[],'zMat',[],'porMat',[],'peMat',[],'permMat',[],'pressMat',[],'pcMat',[],'satMat',[], 'fluxMat',[]); % Here I create a new structure for including the 3D saturation maps for each fractional flow
data_struct.peMat = zeros(Nz, Nx, Ny);
data_struct.xMat = zeros(Nz, Nx, Ny);
data_struct.yMat = zeros(Nz, Nx, Ny);
data_struct.zMat = zeros(Nz, Nx, Ny);
data_struct.porMat = zeros(Nz, Nx, Ny);
data_struct.permMat = zeros(Nz, Nx, Ny);
data_struct.pressMat = zeros(Nz, Nx,Ny,Nt, N_Qg);
data_struct.satMat = zeros(Nz, Nx,Ny,Nt,N_Qg);
data_struct.peMat = zeros(Nz, Nx,Ny,Nt,N_Qg);

%This is now just the creation of the perm, por, pe and pcmax field variables. These are the same as before.
perm_mat = zeros(Nz, Nx, Ny);
por_mat = zeros(Nz, Nx, Ny);
pc_end_mat = zeros(Nz, Nx, Ny);
perm_mat_corr = zeros(Nz, Nx, Ny);
pc_end_mat_corr = zeros(Nz, Nx, Ny);
perm_vec = zeros(Nz*Nx*Ny,1);
perm_vec_corr = zeros(Nz*Nx*Ny,1);

%Initial pressure & saturation
sat_initial_mat = zeros(Nz,Nx,Ny);
pressure_initial_mat = ones(Nz,Nx,Ny).*bound_press;

%Derive uncorrelated distributions of permeability & porosity
pe_mat = zeros(Nz, Nx,Ny);
pe_mat_corr = zeros(Nz, Nx,Ny);
por_mat_corr = zeros(Nz, Nx,Ny);
pe_vec = zeros(Nz*Nx*Ny,1);
pe_vec_corr = zeros(Nz*Nx*Ny,1);
por_vec= zeros(Nz*Nx*Ny,1);    
por_vec_corr= zeros(Nz*Nx*Ny,1);  

% %This is always true! Old code
% dist_type = 1;
% if (dist_type == 1)
%Generate extreme value porbability dist on base grid.
por_mat = evrnd(por_av_start,por_std,Nz,Nx,Ny); %  lognrnd(por_av_log,por_std_log, Nz, Nx);   %pearsrnd(dist_moments(1),dist_moments(2),dist_moments(3),dist_moments(4), Nz, Nx); %$random(distfunc, Nz, Nx); % por_max - por_mat_trans;

%Create a vector of the grid values
count = 0;
for i = 1:Nz
    for j = 1:Nx
        for k = 1:Ny
            count = count + 1;
            por_vec(count) =  por_mat(i,j,k);
        end
    end
end

%Fit an EV function to the generated field.
pd1 = fitdist(por_vec,'ExtremeValue');
por_mu_base = pd1.mu;
por_s_base = pd1.sigma;

%This is the ratio of mean and std of the por, can be used later to check we recover the same distributions.
eta_por_uncorr = por_s_base/por_mu_base;

count1 = 0;
count2 = 0; 

disp("part 1 is done!");

%Create correlated fields, if we have corr length > 0
if ((corr_lengthx > 0) || (corr_lengthy > 0)|| (corr_lengthz > 0))
    disp("we have correlated field");
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                %Find the limits of the averaging based on the current
                %location and corr length
                minus_arr = (j-corr_lengthx):j;
                min_x = min(minus_arr(minus_arr>0));
                max_arr = j:(j+corr_lengthx);
                max_x = max(max_arr(max_arr<(Nx+1)));
                
                %this is the vertical dimension
                minus_arr = (i-corr_lengthz):i;
                min_z = min(minus_arr(minus_arr>0));
                max_arr = i:(i+corr_lengthz);
                max_z = max(max_arr(max_arr<(Nz+1)));
                
                minus_arr = (k-corr_lengthy):k;
                min_y = min(minus_arr(minus_arr>0));
                max_arr = k:(k+corr_lengthy);
                max_y = max(max_arr(max_arr<(Ny+1)));

                %Calculate mean values of the cells in the averaging zone
                % @@@@ THIS MIGHT HAVE TO CHANGE 
                mean1 = 0;
                count2 = 0;
                count1 = count1 + 1;
                %disp("loop 1 done!");

                for ii = min_z:max_z
                    for jj = min_x:max_x
                        for kk = min_y:max_y
                            r = sqrt((ii - i).^2 + (jj - j).^2+ (kk - k).^2);
                            if ((corr_lengthz > 1) && (corr_lengthx > 1) && (corr_lengthy >1 ))
                                t1 = (jj - j).^2/(corr_lengthx)^2 + (ii - i).^2/(corr_lengthz)^2+ (kk - k).^2/(corr_lengthy)^2;
                            else
                                %lets go check Nz dimension
                                if (corr_lengthz < 1)
                                    if ((corr_lengthy < 1))
                                        t1 = (jj - j).^2/(corr_lengthx)^2 ;
                                    elseif ((corr_lengthx < 1))
                                        t1 = (kk - k).^2/(corr_lengthy)^2 ;
                                    else
                                        t1 = (kk - k).^2/(corr_lengthy)^2 + (jj - j).^2/(corr_lengthx)^2 ;
                                    end
                                end
                                %lets go check Nx dimension
                                if (corr_lengthx < 1)
                                    if ((corr_lengthy < 1))
                                        t1 = (ii - i).^2/(corr_lengthz)^2 ;
                                    elseif ((corr_lengthz < 1))
                                        t1 = (kk - k).^2/(corr_lengthy)^2 ;
                                    else
                                        t1 = (kk - k).^2/(corr_lengthy)^2 + (ii - i).^2/(corr_lengthz)^2;
                                    end
                                end
                                %lets go check Ny dimension
                                if (corr_lengthy < 1)
                                    if ((corr_lengthz < 1))
                                        t1 = (jj - j).^2/(corr_lengthx)^2 ;
                                    elseif ((corr_lengthx < 1))
                                        t1 = (ii - i).^2/(corr_lengthz)^2 ;
                                    else
                                        t1 = (ii - i).^2/(corr_lengthz)^2 + (jj - j).^2/(corr_lengthx)^2 ;
                                    end
                                end
                            end
                            if (t1 <= 1.0001)
                                mean1 = mean1+(por_mat(ii,jj,kk)); %this is assigned to the grid block in question
                                count2 = count2+1;
                            end
                        end
                    end
                end                        
                %Ascribe the mean values to the correlated matrices and vector
                por_vec_corr(count1) = (mean1/count2);
                por_mat_corr(i,j,k) = por_vec_corr(count1) ;
            end
        end
    end

else

    disp("we have uncorrelated field");
    %Else if you have an uncorrelated field, simply generate it normally
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                count1 = count1 + 1;
                por_mat_corr(i,j,k) = por_mat(i,j,k);
                por_vec_corr(count1) = por_vec(count1);
                
                perm_vec_corr(count1) = perm_vec(count1);
                perm_mat_corr(i,j,k) = perm_mat(i,j,k);

                pe_mat_corr(i,j,k) = (jsw1/1000)*sqrt(por_mat(i,j,k)./(perm_mat(i,j,k)*perm_multiplier))*(surface_tension*0.001*cos(angle*pi/180));
                pc_end_mat_corr(i,j,k) = pe_mat_corr(i,j,k)/pe.*pc_end;
                pe_vec_corr(count1) = pe_mat_corr(i,j,k);
            end
        end
    end
end

%disp("onto pd fit");
%Fit a new function to the correlated field
pd1 = fitdist(por_vec_corr,'ExtremeValue');
por_mu_corr = pd1.mu;
por_s_corr = pd1.sigma;
eta_por_corr = por_s_corr/por_mu_corr;
%Find the scaling between the original field and the correlated field
scal = por_s_base/por_s_corr;
%re-scale the correlated field so it has the right mean and std
por_vec_corr = ((por_vec_corr)- por_mu_corr)*scal + por_mu_base;
por_mat_corr = ((por_mat_corr)- por_mu_corr)*scal + por_mu_base;

%Fit a new distribution to it, so we can check the re-normalisation has worked,.
pd1 = fitdist(por_vec_corr,'ExtremeValue');
por_mu_corr_updated = pd1.mu;
por_s_corr_updated = pd1.sigma;
eta_por_corr_updated = por_s_corr_updated/ por_mu_corr_updated;     

%Apply the depth transform to the new data, so it follows the right trend.
por_mat_corr = abs(por_mat_corr);
por_av_top = mean(por_mat_corr(1,:));

%should be same with A_input_report
for i= 1:Nz
    por_i = fporosity(z_vec(i));
    por_mat_corr(i,:) = por_mat_corr(i,:) - (por_av_top-por_i);
end
for i = 1:Nz
    for j = 1:Nx
        for k = 1:Ny
           count1 = count1+1;
           %perm_mat_corr = perm_mat;
           por_vec_corr(count1) = por_mat_corr(i,j,k);
           perm_vec_corr(count1) = fpermeability(por_vec_corr(count1));
           perm_mat_corr(i,j,k) =  perm_vec_corr(count1);
           pe_mat_corr(i,j,k) = (jsw1/1000)*sqrt(por_mat_corr(i,j,k)./(perm_mat_corr(i,j,k)*perm_multiplier))*(surface_tension*0.001*cos(angle*pi/180));
           pc_end_mat_corr(i,j,k) = pe_mat_corr(i,j,k)/pe.*pc_end;
           pe_vec_corr(count1) = pe_mat_corr(i,j,k);
        end
    end
end

% end 
save("./Output/post_A2_1", '-v7.3')
disp('Finished generating the geological field model! Woop!')
  