clear all
close all
clc


load("post_A3_1_2D_modified.mat")



count = 0;

for m_iii = 1:13%N_hom_subs_z
    disp(m_iii)
    for m_jjj = 1:18%N_hom_subs_x
        for m_kkk= 1:N_hom_subs_y

             if (subvol_struct(m_iii, m_jjj, m_kkk).in_domain(1) == 1)

                count = count +1;

                list(count,1) = m_iii;
                 list(count,2) = m_jjj;
                list(count,3) = m_kkk;
             end
        end
    end
end
               