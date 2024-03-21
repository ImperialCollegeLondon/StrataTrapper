function [invaded_mat] =  check_box_connectivity(pc, Pe_mat, Nz, Nx, Ny)

invaded_mat = false(Nz, Nx, Ny);
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

        is_boundary_z = (ii == 1) || (ii == Nz);

        for jj = 1:Nx

            if jj == 1
                near_check_x = 1;
            elseif jj == Nx
                near_check_x = -1;
            else
                near_check_x = [1,-1];
            end

            is_boundary_x = (jj == 1) || (jj == Nx);

            for kk = 1:Ny

                if kk == 1
                    near_check_y = 1;
                elseif kk == Ny
                    near_check_y = -1;
                else
                    near_check_y = [1,-1];
                end

                is_boundary_y = (kk == 1) || (kk == Ny);

                if pc <= Pe_mat(ii,jj,kk)
                    continue;
                end

                if ~invaded_mat(ii,jj,kk) && (is_boundary_z || is_boundary_x || is_boundary_y)
                    invaded_mat(ii,jj,kk) = true;
                    changing = true;
                end

                if invaded_mat(ii,jj,kk)
                    continue;
                end

                for inc_z = near_check_z
                    for inc_x = near_check_x
                        for inc_y = near_check_y
                            if invaded_mat(ii+inc_z, jj+inc_x, kk+inc_y)
                                invaded_mat(ii,jj,kk) = true;
                                changing = true;
                                break;
                            end
                        end
                    end
                end
                
            end
        end
    end

end
