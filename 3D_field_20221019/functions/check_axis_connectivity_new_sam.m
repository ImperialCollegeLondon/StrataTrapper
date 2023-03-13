function [connected, connected_mat] =  check_axis_connectivity_new(kr_phase_mat, Nx, Nz,Ny,tol, direction, end_val)


connected_mat = zeros(Nz, Nx);

if (direction == 1)
    
    changing = 1;
    connected = 0;
    connected_mat(:,1) = 1;
    
    while (changing == 1)
        n_changed = 0;
        for ii = 1:Nz
            if (connected == 0)
                for jj = 1:Nx
                    
                    if (ii == 1) && (jj == 1)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii+1;
                        
                        check_pos(1,2) = jj+1;
                        check_pos(2,2) = jj;
                        
                    elseif (ii > 1) && (ii < Nz) && (jj == 1)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj+1;
                        check_pos(3,2) = jj;
                        
                        
                        
                    elseif (ii == Nz) && (jj == 1)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj+1;
                        
                    elseif (ii == Nz) && (jj > 1) && (jj < Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii-1;
                        
                        check_pos(1,2) = jj-1;
                        check_pos(2,2) = jj+1;
                        check_pos(3,2) = jj;
                        
                        
                    elseif (ii == Nz) && (jj == Nx)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii-1;
                        
                        check_pos(1,2) = jj-1;
                        check_pos(2,2) = jj;
                        
                        
                        
                        
                    elseif (ii > 1) && (ii < Nz) && (jj == Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj;
                        
                        
                        
                        
                    elseif (ii == 1) && (jj == Nx)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii+1;
                        check_pos(2,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        
                        
                    elseif (ii == 1) && (jj > 1) && (jj < Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii+1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj+1;
                        
                        
                        
                    else
                        
                        
                        n_check = 4;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        check_pos(4,1) = ii-1;
                        
                        check_pos(1,2) = jj+1;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj;
                        check_pos(4,2) = jj;
                        
                        
                    end
                    
                    
                    
                    for i = 1:n_check
                        if (check_pos(i,2) > Nx)
                            pause
                        end
                        
                        if (check_pos(i,1) > Nz)
                            pause
                        end
                    end
                    
                    
                    for i = 1:n_check
                        
                        if (connected_mat(check_pos(i,1), check_pos(i,2)) > 0) && (kr_phase_mat(ii,jj) > tol) && (connected_mat(ii,jj) == 0)
                            
                            connected_mat(ii,jj) = 1;
                            n_changed = n_changed + 1;
                        end
                        
                    end
                    
                    
                    if (connected_mat(ii,jj) == 1) && (jj == end_val)
                        connected = 1;
                        changing = 0;
                        break
                    else
                        connected = 0;
                    end
                end
                
            end
        end
        
        if (n_changed == 0)
            changing = 0;
        end
        
    end
    
    
    
elseif (direction == 2)
    
    changing = 1;

    connected = 0;
    connected_mat(Nz,:) = 1;
    
    while (changing == 1)
        n_changed = 0;
        for jj = 1:Nx
            if (connected == 0)
                for ii = Nz:-1:1
                    
                    if (ii == 1) && (jj == 1)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii+1;
                        
                        check_pos(1,2) = jj+1;
                        check_pos(2,2) = jj;
                        
                    elseif (ii > 1) && (ii < Nz) && (jj == 1)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj+1;
                        check_pos(3,2) = jj;
                        
                        
                        
                    elseif (ii == Nz) && (jj == 1)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj+1;
                        
                    elseif (ii == Nz) && (jj > 1) && (jj < Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii-1;
                        
                        check_pos(1,2) = jj-1;
                        check_pos(2,2) = jj+1;
                        check_pos(3,2) = jj;
                        
                        
                    elseif (ii == Nz) && (jj == Nx)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii-1;
                        
                        check_pos(1,2) = jj-1;
                        check_pos(2,2) = jj;
                        
                        
                        
                        
                    elseif (ii > 1) && (ii < Nz) && (jj == Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii-1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj;
                        
                        
                        
                        
                    elseif (ii == 1) && (jj == Nx)
                        
                        n_check = 2;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii+1;
                        check_pos(2,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        
                        
                    elseif (ii == 1) && (jj > 1) && (jj < Nx)
                        
                        n_check = 3;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii+1;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii;
                        
                        check_pos(1,2) = jj;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj+1;
                        
                        
                        
                    else
                        
                        
                        n_check = 4;
                        check_pos = zeros(n_check, 2);
                        
                        check_pos(1,1) = ii;
                        check_pos(2,1) = ii;
                        check_pos(3,1) = ii+1;
                        check_pos(4,1) = ii-1;
                        
                        check_pos(1,2) = jj+1;
                        check_pos(2,2) = jj-1;
                        check_pos(3,2) = jj;
                        check_pos(4,2) = jj;
                        
                        
                    end
                    
                    
                    
                    for i = 1:n_check
                        if (check_pos(i,2) > Nx)
                            pause
                        end
                        
                        if (check_pos(i,1) > Nz)
                            pause
                        end
                    end
                    
                    
                    for i = 1:n_check
                        
                        if (connected_mat(check_pos(i,1), check_pos(i,2)) > 0) && (kr_phase_mat(ii,jj) > tol) && (connected_mat(ii,jj) == 0)
                            
                            connected_mat(ii,jj) = 1;
                            n_changed = n_changed + 1;
                        end
                        
                    end
                    
                    
                    
                    
                    if (connected_mat(ii,jj) == 1) && (ii == end_val)
                        connected = 1;
                        changing = 0;
                        break
                    else
                        connected = 0;
                    end
                end
                
            end
        end
        
        if (n_changed == 0)
            changing = 0;
        end
        
    end
    
    
    
end





