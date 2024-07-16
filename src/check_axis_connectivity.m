function [connected] =  check_axis_connectivity(kr_phase_mat,Nx,Ny,Nz,tol)

connected_z = check_axis_connectivity_z(kr_phase_mat,Nx,Ny,Nz,tol);
connected_x = check_axis_connectivity_z(permute(kr_phase_mat,[2,3,1]),Ny,Nz,Nx,tol);
connected_y = check_axis_connectivity_z(permute(kr_phase_mat,[3,1,2]),Nz,Nx,Ny,tol);

connected = [connected_x, connected_y, connected_z];
end

function connected_z = check_axis_connectivity_z(kr_phase_mat,Nx,Ny,Nz,tol)

connected_z = false;

connected_mat = false(Nx, Ny, Nz);
connected_mat(:,:,1) = true;

changing = true;

while (changing)
    changing = false;

    for ii = 1:Nz

        if ii == 1
            near_check_z = 1;
        elseif ii == Nz
            near_check_z = -1;
        else
            near_check_z = [1,-1];
        end

        for jj = 1:Nx

            if jj == 1
                near_check_x = 1;
            elseif jj == Nx
                near_check_x = -1;
            else
                near_check_x = [1,-1];
            end

            for kk = 1:Ny

                if kk == 1
                    near_check_y = 1;
                elseif kk == Ny
                    near_check_y = -1;
                else
                    near_check_y = [1,-1];
                end

                if kr_phase_mat(jj,kk,ii) <= tol
                    continue;
                end

                if connected_mat(jj,kk,ii)
                    continue;
                end

                for inc_z = near_check_z
                    for inc_x = near_check_x
                        for inc_y = near_check_y
                            if connected_mat(jj+inc_x, kk+inc_y, ii+inc_z)
                                connected_mat(jj,kk,ii) = true;
                                changing = true;
                            end
                        end
                    end
                end

                if (ii==Nz) && connected_mat(jj,kk,ii)
                    connected_z = true;
                    return;
                end
            end
        end
    end
end
end
