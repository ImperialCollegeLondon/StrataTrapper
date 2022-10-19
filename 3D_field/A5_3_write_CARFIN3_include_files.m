for qq = 1:N_Qg

    
   fid1 = fopen(['por_carfin3_include_', s_append_base{qq}, '.txt'],'w');
   
   fid2 = fopen(['permx_carfin3_include_', s_append_base{qq}, '.txt'],'w');
   fid3 = fopen(['permy_carfin3_include_', s_append_base{qq}, '.txt'],'w');
   fid4 = fopen(['permz_carfin3_include_', s_append_base{qq}, '.txt'],'w');
   
    
    %for this, we want to use the fine-scale, por/pc/kr curves! (this is
    %for the stuff on the boundaries)
    
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for jjj = N_hom_subs_x:N_hom_subs_x %this is at boundary, so x = 1
            for kkk = 1:N_hom_subs_y
                for i = 1:Nz_sub
                    for j= 1:Nx_sub
                        for k = 1:Ny_sub
                            
                            fprintf(fid1, '%s\r\n',  num2str(subvol_struct(iii,jjj,kkk).porMat(i,j,k), '%25.15e'));
                            
                        end
                    end
                end
            end
        end
    end

    
    fclose(fid1);
    
    %PERM X
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for jjj = N_hom_subs_x:N_hom_subs_x%this is at boundary, so x = 1
            for kkk = 1:N_hom_subs_y
                for i = 1:Nz_sub
                    for j= 1:Nx_sub
                        for k = 1:Ny_sub
                            
                            fprintf(fid2, '%s\r\n',  num2str(subvol_struct(iii,jjj,kkk).permMat(i,j,k), '%25.15e'));
                            
                        end
                    end
                end
            end
        end
    end

    
    fclose(fid2);
    
    %PERM Y 
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for jjj = N_hom_subs_x:N_hom_subs_x%this is at boundary, so x = 1
            for kkk = 1:N_hom_subs_y
                for i = 1:Nz_sub
                    for j= 1:Nx_sub
                        for k = 1:Ny_sub
                            
                            fprintf(fid3, '%s\r\n',  num2str(subvol_struct(iii,jjj,kkk).permMat(i,j,k), '%25.15e'));
                            
                        end
                    end
                end
            end
        end
    end

    
    fclose(fid3);
    
    %PERM Z
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for jjj = N_hom_subs_x:N_hom_subs_x%this is at boundary, so x = 1
            for kkk = 1:N_hom_subs_y
                for i = 1:Nz_sub
                    for j= 1:Nx_sub
                        for k = 1:Ny_sub
                            
                            fprintf(fid4, '%s\r\n',  num2str(subvol_struct(iii,jjj,kkk).permMat(i,j,k), '%25.15e'));
                            
                        end
                    end
                end
            end
        end
    end

    
    fclose(fid4);

        
    
    
    
    
    
    
end