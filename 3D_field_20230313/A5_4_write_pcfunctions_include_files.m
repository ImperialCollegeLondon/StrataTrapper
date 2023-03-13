for qq = 1:N_Qg

    table_number = 1;
    %THIS IS THE HORIZONTAL REL PERM
   fprintf(fid, '%s\r\n', '-- HORIZONTAL DIRECTION 1');
COUNT_ZEROS = 0
    for iii = 1:N_hom_subs_z
        for kkk = 1:N_hom_subs_y
            for jjj = 1:N_hom_subs_x
                
                COUNT_ZEROS = COUNT_ZEROS +1;
                
                %MANUALLY SET KR TO ZERO
                
                subvol_struct(iii,jjj,kkk).krw_optim_hor(1) = 0;
                 subvol_struct(iii,jjj,kkk).krw_optim_hor_2(1) = 0;
                subvol_struct(iii,jjj,kkk).krw_optim_vert(1) = 0;

                subvol_struct(iii,jjj,kkk).krg_optim_hor(n_pts) = 0;
                 subvol_struct(iii,jjj,kkk).krg_optim_hor_2(n_pts) = 0;
                subvol_struct(iii,jjj,kkk).krg_optim_vert(n_pts) = 0;
               
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);

            
                kw_last = 0;
                kg_last = 1;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                sw_last = swirr*0.9;
                count = 0;
                sw_last = 1;

                for i = 1:n_pts

                    if (i > 1) && (i < n_pts)
                    
                        if (subvol_struct(iii,jjj,kkk).sw_upscaled(i) == sw_last) %we know we have reached sw=1 early 
                            subvol_struct(iii,jjj,kkk).sw_upscaled(i) = sw_last-((n_pts-i)*0.0001);

                            for ij = (i+1):n_pts %need to adapt all points until n_pts = 42

                                subvol_struct(iii,jjj,kkk).sw_upscaled(ij) = sw_last-((n_pts-ij)*0.0001);
                                subvol_struct(iii,jjj,kkk).pc_upscaled(ij) = 0;

                            end

                        end

%                         if (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_upscaled(i-1))
%                             subvol_struct(iii,jjj,kkk).sw_upscaled(i) =  subvol_struct(iii,jjj,kkk).sw_upscaled(i-1)*0.0001;
%                         end



                    end

                    if (i == 1)
                        subvol_struct(iii,jjj,kkk).krw_optim_hor(i)
                    end

                    if (i == n_pts)
                        subvol_struct(iii,jjj,kkk).krg_optim_hor(i)
                    end

                     fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.5e')]);

                end
                fprintf(fid, '%s\r\n', '/');
                fprintf(fid, '%s\r\n', '');
               table_number = table_number + 1;

            end
        end
    end
    
    %THIS IS HORIZONTAL DIRECTIOn 2 
    
    fprintf(fid, '%s\r\n', '-- HORIZONTAL DIRECTION 2');
    
    for iii = 1:N_hom_subs_z
        for kkk = 1:N_hom_subs_y
            for jjj = 1:N_hom_subs_x

                 subvol_struct(iii,jjj,kkk).krw_optim_hor(1) = 0;
                 subvol_struct(iii,jjj,kkk).krw_optim_hor_2(1) = 0;
                subvol_struct(iii,jjj,kkk).krw_optim_vert(1) = 0;

                subvol_struct(iii,jjj,kkk).krg_optim_hor(n_pts) = 0;
                 subvol_struct(iii,jjj,kkk).krg_optim_hor_2(n_pts) = 0;
                subvol_struct(iii,jjj,kkk).krg_optim_vert(n_pts) = 0;
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);


            
                kw_last = 0;
                kg_last = 1;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                sw_last = swirr*0.9;
                count = 0;
                sw_last = 1;

               for i = 1:n_pts


                   if (i > 1) && (i < n_pts)
                        
                            if (subvol_struct(iii,jjj,kkk).sw_upscaled(i) == sw_last) %we know we have reached sw=1 early 
                                subvol_struct(iii,jjj,kkk).sw_upscaled(i) = sw_last-((n_pts-i)*0.0001);
    
                                for ij = (i+1):n_pts %need to adapt all points until n_pts = 42
    
                                    subvol_struct(iii,jjj,kkk).sw_upscaled(ij) = sw_last-((n_pts-ij)*0.0001);
                                    subvol_struct(iii,jjj,kkk).pc_upscaled(ij) = 0;
    
                                end
    
                            end
    
    
                   end

                    if (i == 1)
                        subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i)
                    end

                    if (i == n_pts)
                        subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i)
                    end


    
                    fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.5e')]);
               end

                fprintf(fid, '%s\r\n', '/');
                fprintf(fid, '%s\r\n', '');
                table_number = table_number + 1;
            end
        end
    end
    
    
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
 
   fprintf(fid, '%s\r\n', '-- VERTICAL DIRECTION ');

    
    %THIS IS THE VERTICAL PERM
    
    for iii = 1:N_hom_subs_z
        for kkk = 1:N_hom_subs_y
            for jjj = 1:N_hom_subs_x


                subvol_struct(iii,jjj,kkk).krw_optim_hor(1) = 0;
                 subvol_struct(iii,jjj,kkk).krw_optim_hor_2(1) = 0;
                subvol_struct(iii,jjj,kkk).krw_optim_vert(1) = 0;

                subvol_struct(iii,jjj,kkk).krg_optim_hor(n_pts) = 0;
                 subvol_struct(iii,jjj,kkk).krg_optim_hor_2(n_pts) = 0;
                subvol_struct(iii,jjj,kkk).krg_optim_vert(n_pts) = 0;

                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);


                
                kw_last = 0;
                kg_last = 1;
                sw_last = swirr*0.9;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                count = 0;
                sw_last = 1;

                for i = 1:n_pts


                    if (i > 1) && (i < n_pts)
                        
                            if (subvol_struct(iii,jjj,kkk).sw_upscaled(i) == sw_last) %we know we have reached sw=1 early 
                                subvol_struct(iii,jjj,kkk).sw_upscaled(i) = sw_last-((n_pts-i)*0.0001);
    
                                for ij = (i+1):n_pts %need to adapt all points until n_pts = 42
    
                                    subvol_struct(iii,jjj,kkk).sw_upscaled(ij) = sw_last-((n_pts-ij)*0.0001);
                                    subvol_struct(iii,jjj,kkk).pc_upscaled(ij) = 0;
    
                                end
    
                            end
    
                    end

                      if (i == 1)
                        subvol_struct(iii,jjj,kkk).krw_optim_vert(i)
                    end

                    if (i == n_pts)
                        subvol_struct(iii,jjj,kkk).krg_optim_vert(i)
                    end


                        fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_vert(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_vert(i), '%25.5e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.5e')]);


                end
                   
                fprintf(fid, '%s\r\n', '/');
                fprintf(fid, '%s\r\n', '');
                table_number = table_number + 1;

            end
        end
    end
    
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
 
  fprintf(fid, '%s\r\n', '-- AT INLET  ');
    
    %this is at the start - inlet, when x = 1

    
    for ii = 1:Nz
        for kk = 1:Ny
            for jj = 1:Nx_sub
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
                          
               for i = 1:n_pts

                   if (jj == 1)
                       pc_block = 0;

                   else
                       pc_block = pc_fine(i)*(pe_mat_corr(ii,jj,kk)/pe);

                   end
                   
%                    if (i == 1)
%                         fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15e'),'   ',num2str(kw_fine_VL(ii) , '%25.15e'),'   ',num2str((0), '%25.15e'),'   ',num2str(pc_block/100, '%25.15e')]);
%                    else

                    fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.5e'),'   ',num2str(kw_fine_VL(i) , '%25.5e'),'   ',num2str(kg_fine_VL(i), '%25.5e'),'   ',num2str(pc_block/100, '%25.5e')]);
                   
%                    end
               end
               
               fprintf(fid, '%s\r\n', '/');
                fprintf(fid, '%s\r\n', '');
                            
               table_number = table_number + 1;
                
                
            end
        end
    end
    
    
    fprintf(fid, '%s\r\n', '-- AT OUTLET  ');
    
    %this is at the start - inlet, when x = 1

    
    for ii = 1:Nz
        for kk = 1:Ny
            for jj = 1:Nx_sub
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
                          
               for i = 1:n_pts


                   pc_block = pc_fine(i)*(pe_mat_corr(ii,jj,kk)/pe);

                   
%                     if (i == n_pts)
%                         fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15e'),'   ',num2str(kw_fine_VL(i) , '%25.15e'),'   ',num2str((0), '%25.15e'),'   ',num2str(pc_block/100, '%25.15e')]);
%                    else

                    fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.5e'),'   ',num2str(kw_fine_VL(i) , '%25.5e'),'   ',num2str(kg_fine_VL(i), '%25.5e'),'   ',num2str(pc_block/100, '%25.5e')]);
                   
            %       end


               end
               
               fprintf(fid, '%s\r\n', '/');
                fprintf(fid, '%s\r\n', '');
                            
               table_number = table_number + 1;
                
                
            end
        end
    end
    
    
    %{
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for ii = 1:Nz_sub
            real_i = real_i + 1;
            
            for kkk = 1:N_hom_subs_y
                for kk = 1:Ny_sub
                    
                    real_k = real_k + 1;
                    
                    for jjj = 1:1 %this is at boundary, so x = 1
                        for jj= 1:Nx_sub
                            real_j = real_j + 1;
                            
                          fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
                          
                           for i = 1:n_pts
                               
                               if (jj == 1) & (jjj==1)
                                   pc_block = 0;
                                   
                               else
                                   pc_block = pc_fine(i)*(pe_mat(real_i,real_j,real_k)/pe);
                                   
                               end


                     
                                fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15e'),'   ',num2str(kw_fine_VL(ii) , '%25.15e'),'   ',num2str(kg_fine_VL(ii), '%25.15e'),'   ',num2str(pc_block/100, '%25.15e')]);
                            end

%{

                            kw_last = 0;
                            kg_last = 1;

                            sw_last = swirr;

                            [subvol_struct(iii,jjj,kkk).kg_VL_numerical, subvol_struct(iii,jjj,kkk).kw_VL_numerical] = LET_function(subvol_struct(iii,jjj,kkk).sw_upscaled, swirr,kwsirr, kgsgi,L_w, E_w, T_w, L_g, E_g, T_g);

                            for i = 1:n_pts

                                    sw_loop = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                                    kw_loop  = subvol_struct(iii,jjj,kkk).kw_VL_numerical(i);
                                    ko_loop  = subvol_struct(iii,jjj,kkk).kg_VL_numerical(i);

                                    if (jj == 1) && (jjj == 1)
                                        pc_loop = 0;
                                    else
                                        pc_loop  = Brooks_corey_Pc( sw_loop , subvol_struct(iii,jjj,kkk).peMat(ii,jj,kk), swirr,lambda);
                                    end

                                    fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'),'   ',num2str(pc_loop/100, '%25.15e')]);
                                    sw_last = sw_loop;

                                
                            end
                          
                          
                          %}
                            fprintf(fid, '%s\r\n', '/');
                            fprintf(fid, '%s\r\n', '');
                            
                            table_number = table_number + 1;
                            
                        end
                    end
                end
            end
        end
    end
    
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
  fprintf(fid, '%s\r\n', '');
 
   fprintf(fid, '%s\r\n', '-- AT OUTLET  ');    
    %this is at the end - at outlet, when x = max
    real_i = 0;
    real_j = 0;
    real_k = 0;
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for ii = 1:Nz_sub
            real_i = real_i + 1;
            
            for kkk = 1:N_hom_subs_y
                for kk = 1:Ny_sub
                    
                    real_k = real_k + 1;
                    
                    for jjj = N_hom_subs_x:N_hom_subs_x %this is at boundary, so x = 1
                        for jj = 1:Nx_sub
                            
                            real_j = real_j + 1;
                            
                          fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);

                            for i = 1:n_pts


                                pc_block = pc_fine(i)*(pe_mat(real_i,real_j,real_k)/pe);
                     
                                fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15e'),'   ',num2str(kw_fine_VL(ii) , '%25.15e'),'   ',num2str(kg_fine_VL(ii), '%25.15e'),'   ',num2str(pc_block/100, '%25.15e')]);
                            end
                    
                            %{
                            kw_last = 0;
                            kg_last = 1;

                            sw_last = swirr;

                            [subvol_struct(iii,jjj,kkk).kg_VL_numerical, subvol_struct(iii,jjj,kkk).kw_VL_numerical] = LET_function(subvol_struct(iii,jjj,kkk).sw_upscaled, swirr,kwsirr, kgsgi,L_w, E_w, T_w, L_g, E_g, T_g);


                            for i = 1:n_pts

                                    sw_loop = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                                    kw_loop  = subvol_struct(iii,jjj,kkk).kw_VL_numerical(i);
                                    ko_loop  = subvol_struct(iii,jjj,kkk).kg_VL_numerical(i);

                                    pc_loop  = Brooks_corey_Pc( sw_loop , subvol_struct(iii,jjj,kkk).peMat(ii,jj,kk), swirr,lambda);

                                    fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'),'   ',num2str(pc_loop/100, '%25.15e')]);
                                    sw_last = sw_loop;

                                
                            end
                            %}
                            fprintf(fid, '%s\r\n', '/');
                            fprintf(fid, '%s\r\n', '');
                            
                            table_number = table_number +1;
                            
                        end
                    end
                end
            end
        end
    end
    
   
%}
    
    
end