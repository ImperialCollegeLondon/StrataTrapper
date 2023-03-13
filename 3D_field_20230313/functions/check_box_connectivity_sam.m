function [invaded_mat] =  check_box_connectivity(pc, Pe_mat, Nx, Nz, Ny)

invaded_mat = zeros(Nz, Nx);
changing = 1;

while (changing == 1)
    n_changed = 0;
    for ii = 1:Nz
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
                
                if ((ii == 1) || (jj == 1) || (ii == Nz) || (jj == Nx)) &&  ( pc > Pe_mat(ii,jj)) && (invaded_mat(ii,jj) == 0)
                    invaded_mat(ii,jj) = 1;
                    n_changed = n_changed + 1;
                end
                
                
                if (invaded_mat(check_pos(i,1), check_pos(i,2)) > 0) && ( pc > Pe_mat(ii,jj)) && (invaded_mat(ii,jj) == 0)
                    invaded_mat(ii,jj) = 1;
                    n_changed = n_changed + 1;
                end
                
            end
            
        end
        
    end
    
    if (n_changed == 0)
        changing = 0;
    end
    
end








