for qq = 1:N_Qg
    
    
    %this needs to change
    
   fid1 = fopen(['por_carfin2_include_', s_append_base{qq}, '.txt'],'w');
   
   fid2 = fopen(['permx_carfin2_include_', s_append_base{qq}, '.txt'],'w');
   fid3 = fopen(['permy_carfin2_include_', s_append_base{qq}, '.txt'],'w');
   fid4 = fopen(['permz_carfin2_include_', s_append_base{qq}, '.txt'],'w');
    
    
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid1, '%s\r\n',  num2str(subvol_struct(iii,jjj).porMat(i,j), '%25.15e'));
                end
            end
        end
    end
    
    fclose(fid1);

    
 %PERMEA X
 
    for iii = 1:N_hom_subs_z
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid2, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    
    
    fclose(fid2);

    %PERM Y
    
    
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                for j = 1:Nx_up
                    fprintf(fid3, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    fclose(fid3);

    
    %PERM Z
    
    for iii = 1:N_hom_subs_z
        
        for i = 1:Nz_up
            for jjj = N_hom_subs_x:N_hom_subs_x
                
                for j = 1:Nx_up
                    fprintf(fid4, '%s\r\n',  num2str(subvol_struct(iii,jjj).permMat(i,j), '%25.15e'));
                end
            end
        end
    end
    
    
    fclose(fid4);

    

    
end