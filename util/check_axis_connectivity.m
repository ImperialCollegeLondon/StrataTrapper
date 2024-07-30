function [connected] =  check_axis_connectivity(kr_phase_mat,tol)

connected_z = check_axis_connectivity_z(kr_phase_mat,tol);
connected_x = check_axis_connectivity_z(permute(kr_phase_mat,[2,3,1]),tol);
connected_y = check_axis_connectivity_z(permute(kr_phase_mat,[3,1,2]),tol);

connected = [connected_x, connected_y, connected_z];
end

function connected_z = check_axis_connectivity_z(kr_phase_mat,tol)

dims = size(kr_phase_mat);
Nx = dims(1);
Ny = dims(2);
Nz = dims(3);

connected_mat = false(Nx, Ny, Nz);
connected_mat(:,:,1) = true;
connected_z = any(connected_mat(:,:,Nz),"all");

changing = true;

near_check = [-1,1];

while (changing)
    changing = false;

    for ii = 1:Nz
        for jj = 1:Nx
            for kk = 1:Ny
                if kr_phase_mat(jj,kk,ii) <= tol
                    continue;
                end

                if connected_mat(jj,kk,ii)
                    continue;
                end

                for inc_x = near_check
                    j = jj+inc_x;
                    if j < 1 || j > Nx
                        continue;
                    end

                    if connected_mat(j, kk, ii)
                        connected_mat(jj,kk,ii) = true;
                        changing = true;
                    end
                end

                for inc_y = near_check
                    k = kk+inc_y;
                    if k < 1 || k > Ny
                        continue;
                    end

                    if connected_mat(jj, k, ii)
                        connected_mat(jj,kk,ii) = true;
                        changing = true;
                    end
                end

                for inc_z = near_check
                    i = ii+inc_z;
                    if i < 1 || i > Nz
                        continue;
                    end

                    if connected_mat(jj, kk, i)
                        connected_mat(jj,kk,ii) = true;
                        changing = true;
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
