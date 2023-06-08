function [invaded_mat] =  check_box_connectivity(pc, Pe_mat, Nx, Nz, Ny)

invaded_mat = zeros(Nz, Nx, Ny);
changing = 1;

while (changing == 1)
    n_changed = 0;
   % disp("Starting from very top!")
    for ii = 1:Nz
        for jj = 1:Nx
            for kk = 1:Ny
               % disp("new loop")
                %disp([ii, jj, kk])
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %Scenarios where 3 faces are blocked (8 cases when this can
                %happen) 
            
                if (ii == 1) && (jj == 1) && (kk == 1) %starting cube, 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    
                elseif (ii == Nz) && (jj == Nx) && (kk == Ny) %end cube, 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk-1;   
                    
                elseif (ii == Nz) && (jj == 1) && (kk == 1) % (N, 1, 1), 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;  
                    
                elseif (ii == 1) && (jj == 1) && (kk == Ny) %(1,1,N) , 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk-1;
                    
                elseif (ii == 1) && (jj == Nx) && (kk == 1) %(1,N,1) , 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    
                    
                elseif (ii == Nz) && (jj == Nx) && (kk == 1) %(N,N,1) , 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    
                elseif (ii == 1) && (jj == Nx) && (kk == Ny) %(1,N,N), 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk-1;
                    
                elseif (ii == Nz) && (jj == 1) && (kk == Ny) %(N,1,N), 3 faces blocked

                    n_check = 3;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk-1;
                    
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %Scenario when 1 side is blocked (moving along 1 face, in the middle/centre box, no edges), 6 cases

                elseif (ii > 1) && (ii < Nz) && (kk >1) && (kk < Ny) && (jj == 1) %if on jj boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);
                    
                    %jj boundary

                    check_pos(1,1) = ii + 1;
                    check_pos(2,1) = ii - 1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;
                    check_pos(5,1) = ii;
                    
                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj+1; %only option for jj to increase is to go up

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    check_pos(5,3) = kk;                  
                    
                elseif (jj > 1) && (jj < Nx) && (kk > 1) && (kk < Ny) && (ii == 1) %if on ii boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);
                    
                    %ii boundary

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;
                    check_pos(5,1) = ii+1;  %only option for ii to increase is to go up
                    
                    check_pos(1,2) = jj+1;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    check_pos(5,3) = kk;
                    
                elseif (jj > 1) && (jj < Nx) && (ii > 1) && (ii < Nz) && (kk == 1) %if on ii boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);

                    %kk boundary

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;
                    check_pos(5,1) = ii;  %only option for ii to increase is to go up

                    check_pos(1,2) = jj+1;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                    check_pos(5,3) = kk+1; %only way is for kk to increase
                    
               elseif (ii > 1) && (ii < Nz) && (kk >1) && (kk < Ny) && (jj == Nx) %if on jj boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);
                    
                    %jj boundary

                    check_pos(1,1) = ii + 1;
                    check_pos(2,1) = ii - 1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;
                    check_pos(5,1) = ii;
                    
                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj-1; %only option for jj to decrease is to go up

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    check_pos(5,3) = kk;
                    
                    
                elseif (jj > 1) && (jj < Nx) && (kk > 1) && (kk < Ny) && (ii == Nz) %if on ii boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);
                    
                    %ii boundary

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;
                    check_pos(5,1) = ii-1;  %only option for ii to decrease is to go up
                    
                    check_pos(1,2) = jj+1;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    check_pos(5,3) = kk;
                    
                elseif (jj > 1) && (jj < Nx) && (ii > 1) && (ii < Nz) && (kk == Ny) %if on ii boundary, one face blocked off

                    n_check = 5;
                    check_pos = zeros(n_check, 5);

                    %kk boundary

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;
                    check_pos(5,1) = ii;  %only option for ii to increase is to go up

                    check_pos(1,2) = jj+1;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                    check_pos(5,3) = kk-1; %only way is for kk to increase     
                    
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %Now: 2 sides blocked (edges of the faces), 12 cases
               
               %first 4: k is in middle
               elseif (ii ==  1) && (jj == 1) && (kk > 1) && (kk < Ny) %if on ii boundary, one face blocked off

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    %kk boundary

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    
               elseif (ii ==  Nz) && (jj == Nx) && (kk > 1) && (kk < Ny) %if on ii boundary, one face blocked off

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    %kk boundary

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    
                elseif (ii ==  Nz) && (jj == 1) && (kk > 1) && (kk < Ny) %if on ii boundary, one face blocked off

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    %kk boundary

                    check_pos(1,1) = ii-1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;                 
                    
               elseif (ii ==  1) && (jj == Nx) && (kk > 1) && (kk < Ny) %if on ii boundary, one face blocked off

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    %kk boundary

                    check_pos(1,1) = ii+1;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk+1;
                    check_pos(4,3) = kk-1;
                    
                   %next 4: i is in middle
                   
                elseif (kk ==  1) && (jj == 1) && (ii > 1) && (ii < Nz)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk+1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                        
                elseif (kk ==  Ny) && (jj == Nx) && (ii > 1) && (ii < Nz)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk-1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                    
                  elseif (kk ==  Ny) && (jj == 1) && (ii > 1) && (ii < Nz)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj+1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk-1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                    
                  elseif (kk ==  1) && (jj == Nx) && (ii > 1) && (ii < Nz)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;

                    check_pos(1,3) = kk+1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;   
                
                %next 4 cases: j is in middle
                
                elseif (kk ==  1) && (ii == 1) && (jj > 1) && (jj < Nx)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii+1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj+1;
                    check_pos(4,2) = jj-1;

                    check_pos(1,3) = kk+1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;   
                    
                elseif (kk ==  Ny) && (ii == Nz) && (jj > 1) && (jj < Nx)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii-1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj+1;
                    check_pos(4,2) = jj-1;

                    check_pos(1,3) = kk-1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;   
                    
                elseif (kk ==  Ny) && (ii == 1) && (jj > 1) && (jj < Nx)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii+1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj+1;
                    check_pos(4,2) = jj-1;

                    check_pos(1,3) = kk-1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;   
                    
               elseif (kk ==  1) && (ii == Nz) && (jj > 1) && (jj < Nx)

                    n_check = 4;
                    check_pos = zeros(n_check, 4);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii-1;
                    check_pos(3,1) = ii;
                    check_pos(4,1) = ii;

                    check_pos(1,2) = jj;
                    check_pos(2,2) = jj;
                    check_pos(3,2) = jj+1;
                    check_pos(4,2) = jj-1;

                    check_pos(1,3) = kk+1;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;        
                
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %centre cubes - no sides are blocked, only need 1 case 
                
                elseif ((ii > 1) && (ii < Nz) && (jj >1) && (jj < Nx) && (kk > 1) && (kk < Ny))

                    n_check = 6;
                    check_pos = zeros(n_check, 3);

                    check_pos(1,1) = ii;
                    check_pos(2,1) = ii;
                    check_pos(3,1) = ii+1;
                    check_pos(4,1) = ii-1;
                    check_pos(5,1) = ii;
                    check_pos(6,1) = ii;
                    
                    check_pos(1,2) = jj+1;
                    check_pos(2,2) = jj-1;
                    check_pos(3,2) = jj;
                    check_pos(4,2) = jj;
                    check_pos(5,2) = jj;
                    check_pos(6,2) = jj;
                    
                    check_pos(1,3) = kk;
                    check_pos(2,3) = kk;
                    check_pos(3,3) = kk;
                    check_pos(4,3) = kk;
                    check_pos(5,3) = kk+1;
                    check_pos(6,3) = kk-1;
                       
                else
                    
                    disp("Error- cant find a situation")
                    
                    disp(ii)
                    disp(jj)
                    disp(kk)
                    
                    disp(Nz)
                    disp(Nx)
                    disp(Ny)

                end

                %check if values are outside of our domain
                %disp("Checking for errors")

                for i = 1:n_check
                    if (check_pos(i,2) > Nx)
                        disp("error in box - i dir")
                        break
                        %pause
                    end

                    if (check_pos(i,1) > Nz)
                        disp("error in box - j dir ")
                        break

                        %pause
                    end
                             
                    if (check_pos(i,3) > Ny)
                        
                       disp("error in box - k dir")
                        break
                       % pause
                    end
                end

                for i = 1:n_check
                    
                    %|| this means 'or'
                    % we are checking if we are at a boundary

                    if ((ii == 1) || (jj == 1) || (kk==1) ||(ii == Nz) || (jj == Nx) || (kk == Ny)) &&  ( pc > Pe_mat(ii,jj,kk)) && (invaded_mat(ii,jj,kk) == 0)
                        invaded_mat(ii,jj,kk) = 1;
                        n_changed = n_changed + 1;
                    end

                    if (invaded_mat(check_pos(i,1), check_pos(i,2), check_pos(i,3)) > 0) && ( pc > Pe_mat(ii,jj,kk)) && (invaded_mat(ii,jj,kk) == 0)
                        invaded_mat(ii,jj,kk) = 1;
                        n_changed = n_changed + 1;
                    end
                end
            end
        end
    end
    
    if (n_changed == 0)
        changing = 0;
    end

end








