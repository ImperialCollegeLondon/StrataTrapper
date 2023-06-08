%% POLYGON TRANSECT FITTING%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here we import the cross sections, manually generated from Endurance 
if Step_save
    load ("./Output/post_A2_1")
end

xz_import = textread('transect_x_z_lim_3.txt');
yz_import = textread('transect_y_z_lim_2.txt');

xx_min = min(yz_import(:,2));
shift_min = xx_min-xz_import(1,2);
min_depth_total = min(xz_import(:,2)) + shift_min;

%loop through all distances along y
%X and Y coord decide the ultimate depth of a grid block 

for i = 1:N_hom_subs_y %upscled grid block
    y_coord = i*dy_up; %find where the upscaled block sits along Y 
    %find what the depth is at our y coord point
    [minValue,closestIndex] = min(abs(y_coord - yz_import(:,1)));
    y_depth = yz_import(closestIndex,2);
    shift = y_depth - xz_import(1,2); %calc diff between actual depth and our x sec

    xx = xz_import(:,1);
    yy = xz_import(:,2) + shift;  
    xz_import_final(:,1) = xx;
    xz_import_final(:,2) = yy;   

    for j = 1:N_hom_subs_x %loop through all points along X axis for this Y coordinate
        x_coord = j*dx_up; %find where the upscaled block sits along Y axis
        %find what the depth is at our y coord point
        [minValue,closestIndex] = min(abs(x_coord - xz_import_final(:,1)));
        diff_x = xz_import_final(closestIndex,2) - min_depth_total; %how much do we need to shift the grid blocks down in meters
        diff_x_block = ceil(diff_x/dz_up);
        diff_x_test(j,1) = diff_x;
        diff_x_test(j,2) = diff_x_block;
        diff_x_test(j,3) = xz_import_final(closestIndex,2) ;
        diff_x_test(j,4) = min_depth_total;
        if (diff_x_block < 0)
            diff_x_block = 0;
        end

        for jj = 1:N_hom_subs_z
            j_fine_start = 1;
            for iii = 1:Nx_sub
                i_fine_start = 1;
                for jjj = 1:Ny_sub
                    jj_fine_start = 1;
                    for kkk = 1:Nz_sub
                        if (jj > 1)
                            kkk_f = kkk + (Nz_sub*(jj-1));
                        else
                            kkk_f = kkk;
                        end
                        if (i> 1)
                            jjj_f = jjj+(Ny_sub*(i-1));
                        else
                            jjj_f = jjj;
                        end
                        if (j > 1)
                            iii_f = iii + (Nx_sub*(j-1));
                        else
                            iii_f = iii;
                        end
                       por_mat_corr_new_fine(kkk_f+(Nz_sub*diff_x_block),iii_f, jjj_f) = por_mat_corr(kkk_f, iii_f, jjj_f);
                       %pressure_initial_mat2(kkk_f+(Nz_sub*diff_x_block),iii_f, jjj_f) = pressure_initial_mat(kkk_f, iii_f, jjj_f);
                    end
                end
            end
        end    
    end
end
%pressure_initial_mat = pressure_initial_mat2;
%Now set Nz to the updated Nz (because we need to include grid blocks that are
%outside the structure)

[Nz, Nx, Ny] = size(por_mat_corr_new_fine);
upscaling_aspect_ratio = Nx_sub/Nz_sub;
Nsub_tot = Nx_sub.*Ny_sub.*Nz_sub;

%Number of homogenised volumes
N_hom_subs_x = Nx/Nx_sub; %Nx = number of fine scale grid blocks, Nx_sub = size of upscaled
N_hom_subs_y = Ny/Ny_sub;
N_hom_subs_z = Nz/Nz_sub;

Nx_up = Nx_sub;
Ny_up = Ny_sub;
Nz_up = Nz_sub;

N_coar_subs_x = Nx/Nx_up;
N_coar_subs_y = Ny/Ny_up;
N_coar_subs_z = Nz/Nz_up;

Lz = round(Nz*ds_z);
Reservior_bottom = Lz + Reservior_top; 

dx_up = Lx/N_coar_subs_x;
dy_up = Ly/N_coar_subs_y;
dz_up = Lz/N_coar_subs_z;

z_vec = ((Reservior_top + ds_z/2):ds_z:(Reservior_bottom-ds_z/2))'; %vetical direction
x_vec = (ds_x/2:ds_x:(Lx-ds_x/2));
y_vec = (ds_y/2:ds_y:(Ly-ds_y/2));

z_vec_up = ceil(((Reservior_top + dz_up/2):dz_up:(Reservior_bottom-dz_up/2)))';
x_vec_up = (dx_up/2:dx_up:(Lx-dx_up/2));
y_vec_up = (dy_up/2:dy_up:(Ly-dy_up/2));

%Now set the shifted por_mat equal to the old one (just because later codes
%use por_mat_corr) 
%The grid blocks that are outside of the structure, will atuomatically have
%porosity = 0 because we did not assign anything to those indices
por_mat_corr = por_mat_corr_new_fine;

%calculate the perm and pc field, based on the shifted porosity 
count1 = 0;
count_pc_large = 0;

for i = 1:Nz
    for j = 1:Nx
        for k = 1:Ny            
            count1 = count1+1;
            por_vec_corr(count1,1) = por_mat_corr(i,j,k);
            perm_vec_corr(count1,1) = fpermeability(por_vec_corr(count1,1));                                
            perm_mat_corr(i,j,k) =  perm_vec_corr(count1,1);            
            pe_mat_corr(i,j,k) = (jsw1/1000)*sqrt(por_mat_corr(i,j,k)./(perm_mat_corr(i,j,k)*perm_multiplier))*(surface_tension*0.001*cos(angle*pi/180));            
            if (pe_mat_corr(i,j,k) > 2000) %changed from 500 to 1000
                 pe_mat_corr(i,j,k) = 2000;                
                 count_pc_large = count_pc_large+1;                 
            end
            pe_vec_corr(count1) = pe_mat_corr(i,j,k);                       
            pc_end_mat_corr(i,j,k) = pe_mat_corr(i,j,k)/pe.*pc_end;                                  
        end        
    end
end

por_vec_corr(isnan(por_vec_corr)) = 0;
perm_vec_corr(isnan(perm_vec_corr)) = 0;
perm_mat_corr(isnan(perm_mat_corr)) = 0;
pe_vec_corr(isnan(pe_vec_corr)) = 0;
pc_end_mat_corr(isnan(pc_end_mat_corr)) = 0;

% Update other relative parameters
bound_press = (g_accel./1000).*rho_w.*z_vec;        %RHS boundary pressure (kPa)
bound_press_up = (g_accel./1000).*rho_w.*z_vec_up;  %RHS boundary pressure (kPa)
pressure_initial_mat = ones(Nz,Nx,Ny).*bound_press;

if Step_save
    save("./Output/post_A2_2", '-v7.3')
end
