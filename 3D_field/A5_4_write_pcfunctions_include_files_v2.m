for qq = 1:N_Qg

    table_number = 1;
    %THIS IS THE HORIZONTAL REL PERM
    fprintf(fid, '%s\r\n', '-- HORIZONTAL DIRECTION 1');

    for iii = 1:N_hom_subs_z
        for kkk = 1:N_hom_subs_y
            for jjj = 1:N_hom_subs_x
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);
               %fprintf(fid, '%s', num2str(table_number));

            
                kw_last = 0;
                kg_last = 1;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                sw_last = swirr*0.9;
                count = 0;

                for i = 1:n_pts

                    if (i == 1) || (((subvol_struct(iii,jjj,kkk).sw_upscaled(i) > sw_last)) && (subvol_struct(iii,jjj,kkk).pc_upscaled(i) < pc_last))


                        if (subvol_struct(iii,jjj).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_hor) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_hor)  && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i) < kg_last)

                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_hor) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_hor) && (subvol_struct(iii,jjj,kkk).krw_optim_hor(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_hor(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_hor) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_hor) && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_hor(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_hor(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin(count)  = pc_last;

                        elseif (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_hor) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_hor) && (subvol_struct(iii,jjj,kkk).krw_optim_hor(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_hor(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_hor(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_hor(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin(count)  = pc_last;

                        end
                    end

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
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);


            
                kw_last = 0;
                kg_last = 1;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                sw_last = swirr*0.9;
                count = 0;

                for i = 1:n_pts

                    if (i == 1) || (((subvol_struct(iii,jjj,kkk).sw_upscaled(i) > sw_last)) && (subvol_struct(iii,jjj,kkk).pc_upscaled(i) < pc_last))


                        if (subvol_struct(iii,jjj).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_hor_2) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_hor_2)  && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i) < kg_last)

                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin_2(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin_2(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin_2(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin_2(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_hor_2) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_hor_2) && (subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_hor_2(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin_2(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin_2(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin_2(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin_2(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_hor_2) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_hor_2) && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_hor_2(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin_2(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin_2(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin_2(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin_2(count)  = pc_last;

                        elseif (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_hor_2) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_hor_2) && (subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_hor_2(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_hor_2(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_hor_fin_2(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_hor_fin_2(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_hor_fin_2(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_hor_fin_2(count)  = pc_last;

                        end
                    end

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
                
               fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);


                
                kw_last = 0;
                kg_last = 1;
                sw_last = swirr*0.9;
                pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(1)*1.1;
                count = 0;

                for i = 1:n_pts

                    if (i == 1) || (((subvol_struct(iii,jjj,kkk).sw_upscaled(i) > sw_last)) && (subvol_struct(iii,jjj,kkk).pc_upscaled(i) < pc_last))

                        if (subvol_struct(iii,jjj,kkk).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_vert) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_vert)  && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i) < kg_last)

                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_vert_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_vert_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_vert_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_vert_fin(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) <= subvol_struct(iii,jjj,kkk).sw_max_kg_vert) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_vert) && (subvol_struct(iii,jjj,kkk).krw_optim_vert(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_vert(i);
                            kg_last = subvol_struct(iii,jjj,kkk).kg_CL_numerical_vert(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_vert_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_vert_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_vert_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_vert_fin(count)  = pc_last;

                        elseif   (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_vert) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) >= subvol_struct(iii,jjj,kkk).sw_min_kw_vert) && (subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_vert(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).kw_CL_numerical_vert(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_vert(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_vert_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_vert_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_vert_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_vert_fin(count)  = pc_last;

                        elseif (subvol_struct(iii,jjj,kkk).sw_upscaled(i) > subvol_struct(iii,jjj,kkk).sw_max_kg_vert) && (subvol_struct(iii,jjj,kkk).sw_upscaled(i) < subvol_struct(iii,jjj,kkk).sw_min_kw_vert) && (subvol_struct(iii,jjj,kkk).krw_optim_vert(i) > kw_last)  && (subvol_struct(iii,jjj,kkk).krg_optim_vert(i) < kg_last)
                            fprintf(fid, '%s\r\n',  [num2str(subvol_struct(iii,jjj,kkk).sw_upscaled(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krw_optim_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).krg_optim_vert(i), '%25.15e'),'   ',num2str(subvol_struct(iii,jjj,kkk).pc_upscaled(i)/100, '%25.15e')]);

                            count = count + 1;

                            kw_last = subvol_struct(iii,jjj,kkk).krw_optim_vert(i);
                            kg_last = subvol_struct(iii,jjj,kkk).krg_optim_vert(i);
                            sw_last = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                            pc_last = subvol_struct(iii,jjj,kkk).pc_upscaled(i);

                            subvol_struct(iii,jjj,kkk).sw_upscaled_vert_fin(count) = sw_last;
                            subvol_struct(iii,jjj,kkk).kg_upscaled_vert_fin(count)  = kg_last;
                            subvol_struct(iii,jjj,kkk).kw_upscaled_vert_fin(count)  = kw_last;
                            subvol_struct(iii,jjj,kkk).pc_upscaled_vert_fin(count)  = pc_last;

                        end
                    end

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
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for ii = 1:Nz_sub
            for kkk = 1:N_hom_subs_y
                for kk = 1:Ny_sub
                    for jjj = 1:1 %this is at boundary, so x = 1
                        for jj= 1:Nx_sub
                            
                            
                          fprintf(fid, '%s\r\n', ['// SWOF table number : ', num2str(table_number)]);



                            kw_last = 0;
                            kg_last = 1;

                            sw_last = swirr;

                            [subvol_struct(iii,jjj,kkk).kg_VL_numerical, subvol_struct(iii,jjj,kkk).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj,kkk).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);

                            for i = 1:n_pts
                                if (i == 1) || (((subvol_struct(iii,jjj,kkk).sw_upscaled(i) > sw_last)))

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
                            end
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
    
    for iii = 1:N_hom_subs_z %loop through each coarse grid cell
        for ii = 1:Nz_sub
            for kkk = 1:N_hom_subs_y
                for kk = 1:Ny_sub
                    for jjj = N_hom_subs_x:N_hom_subs_x %this is at boundary, so x = 1
                        for jj = 1:Nx_sub
                            
                          fprintf(fid, '%s\r\n', ['-- SWOF table number : ', num2str(table_number)]);




                    
                            kw_last = 0;
                            kg_last = 1;

                            sw_last = swirr;

                            [subvol_struct(iii,jjj,kkk).kg_VL_numerical, subvol_struct(iii,jjj,kkk).kw_VL_numerical] = Chierici_rel_perm(subvol_struct(iii,jjj,kkk).sw_upscaled, swirr,kwsirr, kgsgi, A_water, L_water, B_gas, M_gas);

                            for i = 1:n_pts
                                if (i == 1) || (((subvol_struct(iii,jjj,kkk).sw_upscaled(i) > sw_last)))

                                    sw_loop = subvol_struct(iii,jjj,kkk).sw_upscaled(i);
                                    kw_loop  = subvol_struct(iii,jjj,kkk).kw_VL_numerical(i);
                                    ko_loop  = subvol_struct(iii,jjj,kkk).kg_VL_numerical(i);

                                    pc_loop  = Brooks_corey_Pc( sw_loop , subvol_struct(iii,jjj,kkk).peMat(ii,jj,kk), swirr,lambda);

                                    fprintf(fid, '%s\r\n',  [num2str(sw_loop , '%25.15e'),'   ',num2str(kw_loop , '%25.15e'),'   ',num2str(ko_loop, '%25.15e'),'   ',num2str(pc_loop/100, '%25.15e')]);
                                    sw_last = sw_loop;

                                end
                            end
                            fprintf(fid, '%s\r\n', '/');
                            fprintf(fid, '%s\r\n', '');
                            
                            table_number = table_number +1;
                            
                        end
                    end
                end
            end
        end
    end
    
    

    
    
end