%% Generate flow rates and times to use for the flow simulations to work out, upscaled k, kr
clc
clear
load("./Output/post_A3_1")
%need to calculate how big our domain is, and scale rate accordingly
domain_area_z = Nx_sub*Ny_sub*ds_y*ds_x; %area in x-y dimension in meters
domain_area_x = Nz_sub*Ny_sub*ds_y*ds_z; %area in x-y dimension in meters
domain_area_y = Nx_sub*Nz_sub*ds_z*ds_x; %area in x-y dimension in meters

%the thickness/length along which we calculate the perm
domain_length_z = (Nz_sub-1)*ds_z; %ask Nele
domain_length_x = (Nx_sub-1)*ds_x;
domain_length_y = (Ny_sub-1)*ds_y;

%now calculate the minimum Q we need, max Q is 100 times minimum?
Q_upscaling_min_x = domain_area_x/10;
Q_upscaling_min_y = domain_area_y/10;
Q_upscaling_min_z = domain_area_z/100;

Q_upscaling_min_x_final = Q_upscaling_min_x./2;
Q_upscaling_min_y_final = Q_upscaling_min_y./2;
Q_upscaling_min_z_final = Q_upscaling_min_z./2;

Q_upscaling_max_x_final = Q_upscaling_min_x_final*10;
Q_upscaling_max_y_final = Q_upscaling_min_y_final*10;
Q_upscaling_max_z_final = Q_upscaling_min_z_final*20;

Qw_upscaling_x = logspace(log10(Q_upscaling_min_x_final*10),log10(Q_upscaling_min_x_final/10), n_pts+1);
Qw_upscaling_y = logspace(log10(Q_upscaling_min_y_final*10),log10(Q_upscaling_min_y_final/10), n_pts+1);
Qw_upscaling_z = logspace(log10(Q_upscaling_min_z_final*10),log10(Q_upscaling_min_z_final/10), n_pts+1);

%the flow rate (and time for SS) will be different for each direction, because domain isnt a cube 
%this might have to change - how we define the Q we want
pore_vols_upscaling = 1;

t_mult_horiz = Qw_upscaling_x./(pore_volume_sub.*(1-swirr));
t_mult_horiz_2 = Qw_upscaling_y./(pore_volume_sub.*(1-swirr));
t_mult_vert = Qw_upscaling_z./(pore_volume_sub.*(1-swirr));

dt_max_upscaling_horizontal = (ds_x*ds_y*ds_z)./(Qw_upscaling_x(1))*1000;
dt_max_upscaling_horizontal_2 = (ds_x*ds_y*ds_z)./(Qw_upscaling_y(1))*1000;
dt_max_upscaling_vertical = (ds_x*ds_y*ds_z)./(Qw_upscaling_z(1))*1000;

%THIS MIGHT NEED TO CHANGE - WE'VE GOT 3 DIMENSIONS
%Generate times to simulate in the k,kr upscaling simulations 
for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        for kkk = 1:N_hom_subs_y

            subvol_struct(iii,jjj,kkk).time_upscaling_horiz = zeros(n_pts*2+1,1);
            subvol_struct(iii,jjj,kkk).time_upscaling_vert = zeros(n_pts*2+1,1);
            subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2 = zeros(n_pts*2+1,1);
            
            subvol_struct(iii,jjj,kkk).time_upscaling_horiz(1) = pore_vols_upscaling./t_mult_horiz(1);
            subvol_struct(iii,jjj,kkk).time_upscaling_vert(1) = pore_vols_upscaling./t_mult_vert(1);
            subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(1) = pore_vols_upscaling./t_mult_horiz_2(1);
            
            %we first do one direction, then the other
            %first: horizontal #1 direction
            count =  1;
            for kk = 1:n_pts*2 %we've got n_pts*2 because we are doing kg and then kw
                if (kk <= n_pts)
                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(kk,3) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count-1) + pore_vols_upscaling./t_mult_horiz(kk+1);
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(kk - n_pts,3) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count-1) + pore_vols_upscaling./t_mult_horiz(n_pts*2-kk+2);
                    end
                end
            end
            
            %then vertical direction, going in the z direction
            count =  1;
            for kk = 1:n_pts*2
                if (kk <= n_pts)
                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(kk,1) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_vert(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_vert(count-1) + pore_vols_upscaling./t_mult_vert(kk+1);
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(kk - n_pts,1) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_vert(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_vert(count-1) + pore_vols_upscaling./t_mult_vert(n_pts*2-kk+2);
                    end
                end
            end
            
            %now lets do the third dimension, going in the y direction
            count =  1;
            for kk = 1:n_pts*2
                if (kk <= n_pts)
                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(kk,2) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count-1) + pore_vols_upscaling./t_mult_horiz_2(kk+1);
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(kk - n_pts,2) > 0)
                        count = count + 1;
                        subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count,1) = subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count-1) + pore_vols_upscaling./t_mult_horiz_2(n_pts*2-kk+2);
                    end
                end
            end
        end
    end
end
%work out fine scale functions
%[kg_fine_VL, kw_fine_VL] = Chierici_rel_perm(sw_aim, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);
[kg_fine_VL, kw_fine_VL] = LET_function(sw_aim, swirr, kwsirr, kgsgi, L_w, E_w, T_w, L_g, E_g, T_g);

kw_fine_VL(1) = 0;
kg_fine_VL(end) = 0;

pc_fine =  Brooks_corey_Pc(sw_aim, pe, swirr,lambda);

save("./Output/post_A3_2", '-v7.3')

