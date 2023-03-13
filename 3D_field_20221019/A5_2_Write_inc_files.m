for qq = 1:N_Qg
    
    
    
   fid1 = fopen(['por_include_', s_append_base{qq}, '.txt'],'w');
   
   fid2 = fopen(['permx_include_', s_append_base{qq}, '.txt'],'w');
   fid3 = fopen(['permy_include_', s_append_base{qq}, '.txt'],'w');
   fid4 = fopen(['permz_include_', s_append_base{qq}, '.txt'],'w');   
   fid5 = fopen(['time_include_', s_append_base{qq}, '.txt'],'w');

   
   %porosity 
    
     for i = 1:N_coar_subs_z
        for k = 1:N_coar_subs_y
            for j = 1:N_coar_subs_x
                
                i_sub = ceil(i/div_z);
                j_sub = ceil(j/div_x);
                k_sub = ceil(k/div_y);
                fprintf(fid1, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub,k_sub).por_upscaled, '%25.15e'));
            end
        end
    end
    
    fclose(fid1);
    
    %PERM IN X DIRECTION
    
    for i = 1:N_coar_subs_z
        for k = 1:N_coar_subs_y
            for j = 1:N_coar_subs_x
                
                i_sub = ceil(i/div_z);
                j_sub = ceil(j/div_x);
                k_sub = ceil(k/div_y); 
                
                fprintf(fid2, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub, k_sub).k_eff_mD_hor, '%25.15e'));
            end
        end
    end
    fclose(fid2);

    
    %PERM IN Y DIRECTION
    
    
    for i = 1:N_coar_subs_z
        for k = 1:N_coar_subs_y
            for j = 1:N_coar_subs_x
                
                i_sub = ceil(i/div_z);
                j_sub = ceil(j/div_x);
                k_sub = ceil(k/div_y);
                
                fprintf(fid3, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub, k_sub).k_eff_mD_hor_2, '%25.15e'));
            end
        end
    end
    fclose(fid3);
    
    %PERM IN Z DIRECTION
    
    for i = 1:N_coar_subs_z
        for k = 1:N_coar_subs_y
            for j = 1:N_coar_subs_x
                
                i_sub = ceil(i/div_z);
                j_sub = ceil(j/div_x);
                k_sub = ceil(k/div_y);

                fprintf(fid4, '%s\r\n',  num2str(subvol_struct(i_sub,j_sub, k_sub).k_eff_mD_vert, '%25.15e'));
                
            end
        end
    end

    fclose(fid4);

    
        
    for i = 1:Nt
        if (rem(i,skip_nt) == 0)
            
            
            fprintf(fid5, '%s\r\n', num2str(Times(qq,i), '%25.15f'));
        end
    end
    
    
end


