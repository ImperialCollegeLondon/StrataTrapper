% clc
% clear 
% close all 
% addpath('Result')
% addpath('functions')
% load("./Output/post_A4_1")

fid_por = fopen('./Result/por_include.txt','w');
fid_pem1 = fopen('./Result/perm_horz_include.txt','w');
fid_pem2 = fopen('./Result/perm_horz_2_include.txt','w');
fid_pem3 = fopen('./Result/perm_vert_include.txt','w');
fprintf(fid_por, '%s\r\n', 'PORO');
fprintf(fid_pem1, '%s\r\n', 'PERMX');
fprintf(fid_pem2, '%s\r\n', 'PERMY');
fprintf(fid_pem3, '%s\r\n', 'PERMZ');
fid_kr1 = fopen('./Result/kr_all_include.txt','w');
fid_krnum1 = fopen('./Result/krnum_x_include.txt','w');
fid_krnum2 = fopen('./Result/krnum_y_include.txt','w');
fid_krnum3 = fopen('./Result/krnum_z_include.txt','w');
fprintf(fid_krnum1, '%s\r\n', 'KRNUMX');
fprintf(fid_krnum2, '%s\r\n', 'KRNUMY');
fprintf(fid_krnum3, '%s\r\n', 'KRNUMZ');
fid_bpr = fopen('./Result/bpr_all_include.txt','w');

count_check = 0;
table_number = 1;
fprintf(fid_kr1, '%s\r\n', 'SWOF');
fprintf(fid_kr1, '%s\r\n', ' ');
fprintf(fid_kr1, '%s\r\n', '-- HORIZONTAL DIRECTION 1');
for i = 1:N_coar_subs_z
   for k = 1:N_coar_subs_y
       for j = 1:N_coar_subs_x
            fprintf(fid_krnum1, '%s\r\n',  int2str(table_number));
            fprintf(fid_krnum2, '%s\r\n',  int2str(table_number+N_coar_subs_z*N_coar_subs_y*N_coar_subs_x));
            fprintf(fid_krnum3, '%s\r\n',  int2str(table_number+2*N_coar_subs_z*N_coar_subs_y*N_coar_subs_x));
            fprintf(fid_kr1, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
            table_number = table_number + 1;

            if (subvol_struct(i,j,k).in_domain(1) == 1) % if this file exists, then we have upscaled this grid block, load struture
                count_check = count_check+1;
                fprintf(fid_por, '%s\r\n',  num2str(subvol_struct(i,j,k).por_upscaled, '%25.15e'));
                fprintf(fid_pem1, '%s\r\n',  num2str(subvol_struct(i,j,k).k_eff_mD_hor, '%25.15e'));
                fprintf(fid_pem2, '%s\r\n',  num2str(subvol_struct(i,j,k).k_eff_mD_hor_2, '%25.15e'));
                fprintf(fid_pem3, '%s\r\n',  num2str(subvol_struct(i,j,k).k_eff_mD_vert, '%25.15e'));
                subvol_struct(i,j,k).krw_optim_hor(1) = 0;
                subvol_struct(i,j,k).krw_optim_hor_2(1) = 0;
                subvol_struct(i,j,k).krw_optim_vert(1) = 0;
                subvol_struct(i,j,k).krg_optim_hor(end) = 0;
                subvol_struct(i,j,k).krg_optim_hor_2(end) = 0;
                subvol_struct(i,j,k).krg_optim_vert(end) = 0;
                for m = 1:size(num2str(subvol_struct(i,j,k).sw_upscaled),1)
                    if m == 1 || (subvol_struct(i,j,k).sw_upscaled(m) > subvol_struct(i,j,k).sw_upscaled(m-1) &&  ...
                        subvol_struct(i,j,k).pc_upscaled(m) > 0 && subvol_struct(i,j,k).pc_upscaled(m) < subvol_struct(i,j,k).pc_upscaled(m-1))
                    fprintf(fid_kr1, '%s\r\n',  [num2str(subvol_struct(i,j,k).sw_upscaled(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krw_optim_hor(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krg_optim_hor(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).pc_upscaled(m)/100, '%25.5e')]);
                    end
                end
                if (subvol_struct(i,j,k).sw_upscaled(m) < 1.0)
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1.0, '%25.5e'),'   ', ...
                                num2str(1.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e')]);               
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            else % if not, then we know block is not in domain, set por to zero 
                fprintf(fid_por, '%s\r\n',  num2str(0, '%25.15e'));
                fprintf(fid_pem1, '%s\r\n',  num2str(0, '%25.15e'));
                fprintf(fid_pem2, '%s\r\n',  num2str(0, '%25.15e'));
                fprintf(fid_pem3, '%s\r\n',  num2str(0, '%25.15e'));
                for m = 1:10
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1/10*m, '%25.5e'),'   ', ...
                            num2str(1/9*(m-1), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e')]);                   
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            end
        end
    end
end

table_number = 1;
fprintf(fid_kr1, '%s\r\n', ' ');
fprintf(fid_kr1, '%s\r\n', '-- HORIZONTAL DIRECTION 2');
for i = 1:N_coar_subs_z
   for k = 1:N_coar_subs_y
       for j = 1:N_coar_subs_x
            fprintf(fid_kr1, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
            table_number = table_number + 1;
            if (subvol_struct(i,j,k).in_domain(1) == 1) % if this file exists, then we have upscaled this grid block, load struture
                for m = 1:size(num2str(subvol_struct(i,j,k).sw_upscaled),1)
                    if m == 1 || (subvol_struct(i,j,k).sw_upscaled(m) > subvol_struct(i,j,k).sw_upscaled(m-1) &&  ...
                        subvol_struct(i,j,k).pc_upscaled(m) > 0 && subvol_struct(i,j,k).pc_upscaled(m) < subvol_struct(i,j,k).pc_upscaled(m-1))
                    fprintf(fid_kr1, '%s\r\n',  [num2str(subvol_struct(i,j,k).sw_upscaled(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krw_optim_hor_2(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krg_optim_hor_2(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).pc_upscaled(m)/100, '%25.5e')]);
                    end
                end
                if (subvol_struct(i,j,k).sw_upscaled(m) < 1.0)
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1.0, '%25.5e'),'   ', ...
                                num2str(1.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e')]);                    
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            else % if not, then we know block is not in domain, set por to zero 
                for m = 1:10
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1/10*m, '%25.5e'),'   ', ...
                            num2str(1/9*(m-1), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e')]); 
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            end
        end
    end
end

table_number = 1;
fprintf(fid_kr1, '%s\r\n', ' ');
fprintf(fid_kr1, '%s\r\n', '-- VERTICAL DIRECTION');
for i = 1:N_coar_subs_z
   for k = 1:N_coar_subs_y
       for j = 1:N_coar_subs_x
            fprintf(fid_kr1, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
            table_number = table_number + 1;
            if (subvol_struct(i,j,k).in_domain(1) == 1) % if this file exists, then we have upscaled this grid block, load struture
                for m = 1:size(num2str(subvol_struct(i,j,k).sw_upscaled),1)
                    if m == 1 || (subvol_struct(i,j,k).sw_upscaled(m) > subvol_struct(i,j,k).sw_upscaled(m-1) &&  ...
                        subvol_struct(i,j,k).pc_upscaled(m) > 0 && subvol_struct(i,j,k).pc_upscaled(m) < subvol_struct(i,j,k).pc_upscaled(m-1))
                    fprintf(fid_kr1, '%s\r\n',  [num2str(subvol_struct(i,j,k).sw_upscaled(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krw_optim_vert(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).krg_optim_vert(m), '%25.5e'),'   ', ...
                            num2str(subvol_struct(i,j,k).pc_upscaled(m)/100, '%25.5e')]);
                    end
                end
                if (subvol_struct(i,j,k).sw_upscaled(m) < 1.0)
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1.0, '%25.5e'),'   ', ...
                                num2str(1.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e'),'   ', ...
                                num2str(0.0, '%25.5e')]);                    
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            else % if not, then we know block is not in domain, set por to zero 
                for m = 1:10
                    fprintf(fid_kr1, '%s\r\n',  [num2str(1/10*m, '%25.5e'),'   ', ...
                            num2str(1/9*(m-1), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e'),'   ', num2str(1/9*(10-m), '%25.5e')]); 
                end
                fprintf(fid_kr1, '%s\r\n', '/'); fprintf(fid_kr1, '%s\r\n', '');
            end
        end
    end
end

fprintf(fid_bpr, '%s\r\n', 'BPR');
for i = 1:N_coar_subs_x
    for j = 1:N_coar_subs_y
        for k = 1:N_coar_subs_z            
            fprintf(fid_bpr, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), '/']);
        end
    end
end
fprintf(fid_bpr, '%s\r\n',  '/');
fprintf(fid_bpr, '%s\r\n', 'BSWAT');
for i = 1:N_coar_subs_x
    for j = 1:N_coar_subs_y
        for k = 1:N_coar_subs_z            
            fprintf(fid_bpr, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), '/']);
        end
    end
end
fprintf(fid_bpr, '%s\r\n',  '/');
fprintf(fid_bpr, '%s\r\n', 'BWPC');
for i = 1:N_coar_subs_x
    for j = 1:N_coar_subs_y
        for k = 1:N_coar_subs_z            
            fprintf(fid_bpr, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), '/']);
        end
    end
end
fprintf(fid_bpr, '%s\r\n',  '/');
fprintf(fid_bpr, '%s\r\n', 'BWPR');
for i = 1:N_coar_subs_x
    for j = 1:N_coar_subs_y
        for k = 1:N_coar_subs_z            
            fprintf(fid_bpr, '%s\r\n',  [ int2str(i),' ', int2str(j),' ', int2str(k), '/']);
        end
    end
end
fprintf(fid_bpr, '%s\r\n',  '/');


fprintf(fid_por, '%s\r\n',  '/');
fprintf(fid_pem1, '%s\r\n',  '/');
fprintf(fid_pem2, '%s\r\n',  '/');
fprintf(fid_pem3, '%s\r\n',  '/');
fprintf(fid_krnum1, '%s\r\n',  '/');
fprintf(fid_krnum2, '%s\r\n',  '/');
fprintf(fid_krnum3, '%s\r\n',  '/');

fclose("all");
disp(count_check)
