%Generate flow rates and times to use for the flow simulations to work out
%upscaled k, kr
%6th Jan 2022: Upscaling/perm calculations did not work for vertical - flow rate was too
%small compared to A and L. Sam J fixed it, and used a ratio of rate:A that
%is 1:1. For rate:length, it was 1000:1
%for horizontal flow, the rates above are too high - simulations wont run.
%Here, a rate:A ratio of 1:10, and a rate:L ratio of 10:1 works. 

%need to calculate how big our domain is, and scale rate accordingly

domain_area_z = Nx_sub*Ny_sub*ds_y*ds_x; %area in x-y dimension in meters
domain_area_x = Nz_sub*Ny_sub*ds_y*ds_z; %area in x-y dimension in meters
domain_area_y = Nx_sub*Nz_sub*ds_z*ds_x; %area in x-y dimension in meters

%the thickness/length along which we calculate the perm

domain_length_z = (Nz_sub-1)*ds_z;
domain_length_x = (Nx_sub-1)*ds_x;
domain_length_y = (Ny_sub-1)*ds_y;

%now calculate the minimum Q we need, max Q is 100 times minimum?

Q_upscaling_min_x = domain_area_x/1000;
Q_upscaling_min_y = domain_area_y/1000;
Q_upscaling_min_z = domain_area_z/100;

Q_upscaling_min_x_2 = 1*domain_length_x; %10
Q_upscaling_min_y_2 = 1*domain_length_y; %3.3
Q_upscaling_min_z_2 = 100*domain_length_z;

%once calculated what the minimum rate can be, compare the two. Whichever
%is the highest, will be used as the final minimum rate. 
%the maximum rate will be 100 times that 

for i = 1:1
    
    if (Q_upscaling_min_x_2 < Q_upscaling_min_x)
        
        Q_upscaling_min_x_final = Q_upscaling_min_x;
    end
    
    if (Q_upscaling_min_x_2 > Q_upscaling_min_x)
        
        Q_upscaling_min_x_final = Q_upscaling_min_x_2;
    end
    
end


for i = 1:1
    
    if (Q_upscaling_min_y_2 < Q_upscaling_min_y)
        
        Q_upscaling_min_y_final = Q_upscaling_min_y;
    end
    
    if (Q_upscaling_min_y_2 > Q_upscaling_min_y)
        
        Q_upscaling_min_y_final = Q_upscaling_min_y_2;
    end
    
 end
% 
 for i = 1:1
    
    if (Q_upscaling_min_z_2 < Q_upscaling_min_z)
        
        Q_upscaling_min_z_final = Q_upscaling_min_z;
    end
    
    if (Q_upscaling_min_z_2 > Q_upscaling_min_z)
        
        Q_upscaling_min_z_final = Q_upscaling_min_z_2;
    end
    
 end



Q_upscaling_max_x_final = Q_upscaling_min_x_final*10;
Q_upscaling_max_y_final = Q_upscaling_min_y_final*10;
Q_upscaling_max_z_final = Q_upscaling_min_z_final*10;


Q_upscaling_min_z_final = Q_upscaling_min_z_final/10;

Q_upscaling_max_z_final = Q_upscaling_min_z_final/10;



Qw_upscaling_x = logspace(log10(Q_upscaling_max_x_final),log10(Q_upscaling_min_x_final), n_pts+1);
Qw_upscaling_y = logspace(log10(Q_upscaling_max_y_final),log10(Q_upscaling_min_y_final), n_pts+1);
Qw_upscaling_z = logspace(log10(Q_upscaling_max_z_final),log10(Q_upscaling_min_z_final), n_pts+1);

%Qw_upscaling_x(1,1) = rate_z(rrr);
%Qw_upscaling_y(1,1) = rate_z(rrr);
%Qw_upscaling_z(1,1) = rate_zz(rrr);

%

% I want at least 10 pore volumes to flow through rock - ensure SS has been
% reached

pore_vols_upscaling = 10;


%the flow rate (and time for SS) will be different for each direction, because domain isnt a cube 

%this might have to change - how we define the Q we want

%Qw_indiv = Qw_upscaling;
%Qw_indiv_x = 5*Qw_indiv.*Nx_sub./Nz_sub;
%Qw_indiv_y = 5*Qw_indiv.*Ny_sub./Nz_sub;
%Qw_indiv_x = Qw_indiv;
%Qw_indiv_y = Qw_indiv;

%%%%%%%

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
            
            % we first do one direction, then the other
            
            %first: horizontal #1 direction
            
            count =  1;
            for kk = 1:n_pts*2 %weve got n_pts*2 because we are doing kg and then kw
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
[kg_fine_VL, kw_fine_VL] = Chierici_rel_perm(sw_aim, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);

kw_fine_VL(1) = 0;
kg_fine_VL(end) = 0;

pc_fine =  Brooks_corey_Pc(sw_aim, pe, swirr,lambda);

%PLot upscaled functions

%{
figure
hold on
for i = 1:1:N_hom_subs_z
    for j  = 1:1:N_hom_subs_x
        for k = 1:1:N_hom_subs_y
        
            for iii = 1:Nz_sub
                for jjj = 1:Nx_sub
                    for kkk = 1:Ny_sub
                        pc_new = Brooks_corey_Pc(subvol_struct(i,j,k).sw_upscaled, subvol_struct(i,j,k).peMat(iii,jjj,kkk), swirr,lambda);
                
                    end
                end
            end

            plot(subvol_struct(i,j,k).sw_upscaled, subvol_struct(i,j,k).pc_upscaled, 'b-', 'linewidth', 2)
        end
    end
end

axis([0 1 0 10])
legend( 'Fine scale curves', 'Upscaled curve');
xlabel('Water Saturation, \it S_w \rm [-]')
ylabel('Capillary pressure, \it P_c \rm [kPa]')

disp("time upscaling horiz");
disp(subvol_struct(1,1,1).time_upscaling_horiz_2(:))

disp("time upscaling horiz");
disp(subvol_struct(1,1,1).time_upscaling_horiz(:))

%}

