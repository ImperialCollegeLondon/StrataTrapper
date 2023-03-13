%Finished generating simulation files.
%Now plot some of the upscaled functions.


alpha = 0.5;

figure
hold on
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kg_VL_numerical, 'color',[0,0,0], 'linewidth', 2)
for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        plot(subvol_struct(iii,jjj).sw_upscaled_vert_fin, subvol_struct(iii,jjj).kw_upscaled_vert_fin, 'color',[0,0,0]+alpha)
        plot(subvol_struct(iii,jjj).sw_upscaled_vert_fin, subvol_struct(iii,jjj).kg_upscaled_vert_fin, 'color',[0,0,0]+alpha)
        
    end
end
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kg_VL_numerical, 'color',[0,0,0], 'linewidth', 2)
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kw_VL_numerical, 'color',[0,0,0], 'linewidth', 2)

set(gcf,'color','w');
L = legend('Fine scale VL curves', 'Upscaled CL curves', 'location', 'best');
xlabel('Water saturation, S_w [-]')
ylabel('Relative permeability, k_r [-]')
axis([0 1 1e-5 1])
set(gca, 'YScale', 'log')
title('kr Vertical Upscaling')
export_fig kr_vertical_upscaling.png

figure
hold on
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kg_VL_numerical, 'color',[0,0,0], 'linewidth', 2)
for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        plot(subvol_struct(iii,jjj).sw_upscaled_hor_fin, subvol_struct(iii,jjj).kw_upscaled_hor_fin, 'color',[0,0,0]+alpha)
        plot(subvol_struct(iii,jjj).sw_upscaled_hor_fin, subvol_struct(iii,jjj).kg_upscaled_hor_fin, 'color',[0,0,0]+alpha)
        
    end
end
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kg_VL_numerical, 'color',[0,0,0], 'linewidth', 2)
plot(subvol_struct(1,1).sw_upscaled, subvol_struct(1,1).kw_VL_numerical, 'color',[0,0,0], 'linewidth', 2)
set(gcf,'color','w');
L = legend('Fine scale VL curves', 'Upscaled CL curves', 'location', 'best');
xlabel('Water saturation, S_w [-]')
ylabel('Relative permeability, k_r [-]')
title('kr Horizontal Upscaling')
axis([0 1 1e-5 1])
set(gca, 'YScale', 'log')
export_fig kr_horizontal_upscaling.png

figure
hold on

for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        plot(subvol_struct(iii,jjj).sw_upscaled, subvol_struct(iii,jjj).pc_upscaled, 'color',[0,0,0]+alpha)
    end
end

set(gcf,'color','w');
L = legend('Upscaled CL curves', 'location', 'best');
xlabel('Water saturation, S_w [-]')
ylabel('Capillary pressure, P_c [kPa]')
title('Pc Upscaling')
axis([0 1 0 20])
export_fig pc_upscaling.png

perm_coarse_vert = zeros(N_hom_subs_z, N_hom_subs_x);
perm_coarse_hor = zeros(N_hom_subs_z, N_hom_subs_x);
por_coarse = zeros(N_hom_subs_z, N_hom_subs_x);

for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        perm_coarse_vert(iii,jjj) = subvol_struct(iii,jjj).k_eff_mD_vert;
        perm_coarse_hor(iii,jjj) = subvol_struct(iii,jjj).k_eff_mD_hor;
        por_coarse(iii,jjj) = subvol_struct(iii,jjj).por_upscaled;
    end
end

coarse_grid_x = linspace(0, Lx, N_hom_subs_x);
coarse_grid_z = linspace(0, Lz, N_hom_subs_z)';

figure
image([0+(Lx/N_hom_subs_x)/2, Lx-(Lx/N_hom_subs_x)/2], [0+(Lz/N_hom_subs_z)/2, Lz-(Lz/N_hom_subs_z)/2],log(perm_coarse_vert),'CDataMapping','scaled' );
colorbar
xlabel('x [m]')
ylabel('z-Depth [m]')
set(gcf,'color','w');
set(gca,'Ydir','reverse')
axis equal
title('Upscaled Vertical permeability Log[mD]')
export_fig upscaled_vertical_permeability.png

figure
image([0+(Lx/N_hom_subs_x)/2, Lx-(Lx/N_hom_subs_x)/2], [0+(Lz/N_hom_subs_z)/2, Lz-(Lz/N_hom_subs_z)/2],log(perm_coarse_hor),'CDataMapping','scaled' );
colorbar
xlabel('x [m]')
ylabel('z-Depth [m]')
set(gcf,'color','w');
set(gca,'Ydir','reverse')
axis equal
title('Upscaled Horizontal permeability Log[mD]')
export_fig upscaled_horizontal_permeability.png

figure
image([0+(Lx/Nx)/2, Lx-(Lx/Nx)/2], [0+(Lz/Nz)/2, Lz-(Lz/Nz)/2],log(perm_mat_corr),'CDataMapping','scaled' );
colorbar
xlabel('x [m]')
ylabel('z-Depth [m]')
set(gcf,'color','w');
set(gca,'Ydir','reverse')
axis equal
title('Fine scale permeability Log[mD]')
export_fig fine_scale_permeability.png

figure
image([0+(Lx/Nx)/2, Lx-(Lx/Nx)/2], [0+(Lz/Nz)/2, Lz-(Lz/Nz)/2],(por_mat_corr),'CDataMapping','scaled' );
colorbar
xlabel('x [m]')
ylabel('z-Depth [m]')
set(gcf,'color','w');
set(gca,'Ydir','reverse')
axis equal
title('Fine scale porosity[-]')
export_fig fine_scale_porosity.png

figure
image([0+(Lx/N_hom_subs_x)/2, Lx-(Lx/N_hom_subs_x)/2], [0+(Lz/N_hom_subs_z)/2, Lz-(Lz/N_hom_subs_z)/2],(por_coarse),'CDataMapping','scaled' );
colorbar
xlabel('x [m]')
ylabel('z-Depth [m]')
set(gcf,'color','w');
set(gca,'Ydir','reverse')
axis equal
title('Upscaled porosity [-]')
export_fig upscaled_porosity.png