%Now create the datastructures needed for the upscaled simulation files.

data_struct.permMat = perm_mat_corr;
data_struct.porMat = por_mat_corr;
data_struct.peMat = pe_mat_corr;

filename1 = 'Porosity.vtk';
A = por_mat_corr;
[X,Y,Z] = meshgrid(1:size(A,1),1:size(A,2),1:size(A,3));
vtkwrite(filename1,'structured_grid',X,Y,Z,'scalars','Por',A)

filename1 = 'Pe.vtk';
A = pe_mat_corr;
[X,Y,Z] = meshgrid(1:size(A,1),1:size(A,2),1:size(A,3));
vtkwrite(filename1,'structured_grid',X,Y,Z,'scalars','Pe',A)

filename1 = 'Permeability.vtk';
A = perm_mat_corr;
[X,Y,Z] = meshgrid(1:size(A,1),1:size(A,2),1:size(A,3));
vtkwrite(filename1,'structured_grid',X,Y,Z,'scalars','Perm',A)


for i = Nz:-1:1
    for j = 1:Nx
        for k = 1:Ny
            data_struct.xMat(i,j,k) = x_vec(j);
            data_struct.zMat(i,j,k) = z_vec(i);
            data_struct.yMat(i,j,k) = y_vec(k);
        end 
    end
end


subvol_struct = struct('xMat',[],'zMat',[],'yMat', [],'porMat',[],'permMat',[],'peMat',[],'bound_press',[],'press_initial_mat',[], 'sat_initial_mat', [], 'kg_mat',[], 'kw_mat',[],'kg_phase_connected', [], 'kw_phase_connected', [],...
    'invaded_mat_minus', [], 'invaded_mat_mid', [], 'invaded_mat_plus', [],'sw_upscaled', [], 'pb_boundary', [], 'pc_upscaled', [],  'por_upscaled', [],...
    'time_upscaling_horiz', [], 'time_upscaling_vert', []);

subvol_struct(N_hom_subs_z, N_hom_subs_x , N_hom_subs_y ).xMat = zeros(Nx_sub, Nz_sub, Ny_sub);

for i = 1:N_hom_subs_z
    for j = 1:N_hom_subs_x
        for k = 1:N_hom_subs_y

            subvol_struct(i,j,k).xMat = data_struct.xMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));
            subvol_struct(i,j,k).zMat = data_struct.zMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));
            subvol_struct(i,j,k).yMat = data_struct.yMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));

            subvol_struct(i,j,k).porMat = data_struct.porMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));
            subvol_struct(i,j,k).permMat = data_struct.permMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));
            subvol_struct(i,j,k).peMat = data_struct.peMat(((i-1)*Nz_sub+1):(i*Nz_sub), ((j-1)*Nx_sub+1):(j*Nx_sub),((k-1)*Ny_sub+1):(k*Ny_sub));
            
            subvol_struct(i,j,k).kg_mat = zeros(Nz_sub, Nx_sub,Ny_sub, n_pts);
            subvol_struct(i,j,k).kw_mat = zeros(Nz_sub, Nx_sub,Ny_sub, n_pts);
            
            subvol_struct(i,j,k).kg_phase_connected = zeros(n_pts,2);
            subvol_struct(i,j,k).kw_phase_connected = zeros(n_pts,2);
            
            subvol_struct(i,j,k).invaded_mat_minus = zeros(Nz_sub, Nx_sub,Ny_sub, n_pts);
            subvol_struct(i,j,k).invaded_mat_mid = zeros(Nz_sub, Nx_sub,Ny_sub, n_pts);
            subvol_struct(i,j,k).invaded_mat_plus = zeros(Nz_sub, Nx_sub,Ny_sub, n_pts);

            subvol_struct(i,j,k).sw_upscaled = zeros(n_pts, 1);
            subvol_struct(i,j,k).pc_upscaled = zeros(n_pts, 1);
            subvol_struct(i,j,k).por_upscaled = 0;
            subvol_struct(i,j,k).bound_press = (g_accel/1000).*rho_w.*subvol_struct(i,j,k).zMat(:,1);
            subvol_struct(i,j,k).sat_initial_mat = zeros(Nz_sub, Nx_sub,Ny_sub);
            subvol_struct(i,j,k).press_initial_mat = ones(Nz_sub, Nx_sub,Ny_sub).*(g_accel/1000).*rho_w.*subvol_struct(i,j,k).zMat;
        end
    end
end

