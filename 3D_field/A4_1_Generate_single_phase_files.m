disp('   ')
%Now we generate the single phase flow simulation files, to calculate k, kr
%for the upscaled grid blocks. This follows a similar approach to the
%fine-scale multiphase flow simulations before, but is single phase.

%Loop through all subvolumes to generate upscaled simulation files.
for iii = 1:N_hom_subs_z
    for jjj = 1:N_hom_subs_x
        for kkk = 1:N_hom_subs_y
        
            sub_append = ['_subvol_',int2str(iii),'_', int2str(jjj),'_', int2str(kkk)];

            %Generate report files, for horiztonal and vertical upscaled k,kr.
            disp(['IMEX_upscaling_report_gen_horizontal',s_append_base{1},sub_append '.rwd']);
            fid = fopen(['IMEX_upscaling_report_gen_horizontal',s_append_base{1},sub_append '.rwd'],'w');
            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_horizontal',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_horizontal',s_append_base{1},sub_append,'_Well_water_rates','.txt''']);
            fprintf(fid, '%s\r\n', '*SPREADSHEET');
            fprintf(fid, '%s\r\n', '*TIME ON ');
            fprintf(fid, '%s\r\n', '*PRECISION 10');
            fprintf(fid, '%s\r\n', '*WIDTH 23');
            fprintf(fid, '%s\r\n', ['*TABLE-FOR  *PARAMETER ', '''Water Rate SC''']);
            fprintf(fid, '%s\r\n', '*COLUMN-FOR *WELLS *ALL *PRECISION 10');
            fprintf(fid, '%s\r\n', '*TABLE-END');
            fprintf(fid, '%s\r\n', '  ');

            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_horizontal',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_horizontal',s_append_base{1},sub_append,'_Grid_block_pressure','.txt''']);
            fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
            fprintf(fid, '%s\r\n', '*SRF-FORMAT');
            fprintf(fid, '%s\r\n', '  ');
            fclose(fid);
            fclose('all');

            fid = fopen(['IMEX_upscaling_report_gen_vertical',s_append_base{1},sub_append, '.rwd'],'w');
            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_vertical',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_vertical',s_append_base{1},sub_append,'_Well_water_rates','.txt''']);
            fprintf(fid, '%s\r\n', '*SPREADSHEET');
            fprintf(fid, '%s\r\n', '*TIME ON ');
            fprintf(fid, '%s\r\n', '*PRECISION 10');
            fprintf(fid, '%s\r\n', '*WIDTH 23');
            fprintf(fid, '%s\r\n', ['*TABLE-FOR  *PARAMETER ', '''Water Rate SC''']);
            fprintf(fid, '%s\r\n', '*COLUMN-FOR *WELLS *ALL *PRECISION 10');
            fprintf(fid, '%s\r\n', '*TABLE-END');
            fprintf(fid, '%s\r\n', '  ');

            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_vertical',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_vertical',s_append_base{1},sub_append,'_Grid_block_pressure','.txt''']);
            fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
            fprintf(fid, '%s\r\n', '*SRF-FORMAT');
            fprintf(fid, '%s\r\n', '  ');
            fclose(fid);
            fclose('all');
            
            %files for the third dimension
            
            fid = fopen(['IMEX_upscaling_report_gen_horizontal_2',s_append_base{1},sub_append '.rwd'],'w');
            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_horizontal_2',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_horizontal_2',s_append_base{1},sub_append,'_Well_water_rates','.txt''']);
            fprintf(fid, '%s\r\n', '*SPREADSHEET');
            fprintf(fid, '%s\r\n', '*TIME ON ');
            fprintf(fid, '%s\r\n', '*PRECISION 10');
            fprintf(fid, '%s\r\n', '*WIDTH 23');
            fprintf(fid, '%s\r\n', ['*TABLE-FOR  *PARAMETER ', '''Water Rate SC''']);
            fprintf(fid, '%s\r\n', '*COLUMN-FOR *WELLS *ALL *PRECISION 10');
            fprintf(fid, '%s\r\n', '*TABLE-END');
            fprintf(fid, '%s\r\n', '  ');

            fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_upscaling_horizontal_2',s_append_base{1},sub_append, '.irf''']);
            fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_upscaling_horizontal_2',s_append_base{1},sub_append,'_Grid_block_pressure','.txt''']);
            fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
            fprintf(fid, '%s\r\n', '*SRF-FORMAT');
            fprintf(fid, '%s\r\n', '  ');
            fclose(fid);
            fclose('all');
            
            perm_mat_max = max(subvol_struct(iii,jjj,kkk).permMat(:));
            perm_mat_buffer = perm_mat_max*100;
            
            
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

%Generate horizontal upscaled file.
            fid = fopen(['IMEX_upscaling_horizontal',s_append_base{1},sub_append, '.dat'],'w');

            fprintf(fid, '%s\r\n', '*INUNIT *SI');
            fprintf(fid, '%s\r\n', 'WSRF GRID TIME');
            fprintf(fid, '%s\r\n', 'WSRF WELL TIME');
            fprintf(fid, '%s\r\n', '**OUTSRF GRID PRES SG SW PCOW PCWSCL');
            fprintf(fid, '%s\r\n', '*OUTSRF *GRID *ALL');
            fprintf(fid, '%s\r\n', '**DIM SOLVER_DIMENSIONING ''ON''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *GRID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*GRID ', '*VARI ', int2str((Nx_sub+(Nx_sub*10))),' ', int2str(Ny_sub),' ', int2str(Nz_sub)]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DI ', '*CON ', num2str(ds_x, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DJ ', '*CON ', num2str(ds_y, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DK ', '*CON ', num2str(ds_z, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'DTOP');
            fprintf(fid, '%s\r\n',  [  int2str((Nx_sub+(Nx_sub*10))*Ny_sub), '*', num2str(nanmin(nanmin(nanmin(subvol_struct(iii,jjj,kkk).zMat(:,:)))), '%50g') ]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*POR *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', '0.2']);
            fprintf(fid, '%s\r\n', [int2str(((Nx_sub*10)/2) + Nx_sub), ':', int2str((Nx_sub*10)+Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',('0.2')]);

            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Nx_sub*10)/2;
                        
                        col = Nz_sub - i+1; %Nz
                        row = j+buffer_added; %Nx
                        col2 = Ny_sub - k +1; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).porMat(i,j,k));
                    end
                end
            end            

            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*PERMI *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);
            
            fprintf(fid, '%s\r\n', '*MOD');
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
            fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Nx_sub*10)/2;
                        
                        col = Nz_sub - i+1; %Nz
                        row = j+buffer_added; %Nx
                        col2 = Ny_sub - k +1; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).permMat(i,j,k));
                    end
                end
            end            


            fprintf(fid, '%s\r\n', '*PERMJ *EQUALSI');
            fprintf(fid, '%s\r\n', '*PERMK *EQUALSI');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PRPOR ', num2str(press_av*100, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *MODEL');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'MODEL *OILWATER');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*TRES ', num2str(temp_av, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DENSITY GAS ', num2str(rho_g/100, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY OIL ', num2str(rho_g, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY WATER ', num2str(rho_w, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'PVT');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['10.0000000000000000	0.0000000000093000	0.9999940000000000	0.9999994000000000 ', num2str(mu_g*1000,'%25.15f'),' ', num2str(mu_g*100,'%25.15f')]);
            fprintf(fid, '%s\r\n',  ['1000.0000000000000000	0.0000000000094000	0.9999950000000000	0.9999995000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['2000.0000000000000000	0.0000000000095000	0.9999960000000000	0.9999996000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['4000.0000000000000000	0.0000000000096000	0.9999970000000000	0.9999997000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['6000.0000000000000000	0.0000000000097000	0.9999980000000000	0.9999998000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['8000.0000000000000000	0.0000000000098000	0.9999990000000000	0.9999999000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['9000.0000000000000000	0.0000000000099000	1.0000000000000000	1.0000000000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['10000.0000000000000000	0.0000000000100000	1.0000001000000000	1.0000001000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['11000.0000000000000000	0.0000000000110000	1.0000002000000000	1.0000002000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['120000.0000000000000000	0.0000000000120000	1.0000003000000000	1.0000003000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['130000.0000000000000000	0.0000000000130000	1.0000004000000000	1.0000004000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*BWI   1.00');
            fprintf(fid, '%s\r\n', '*CW    0.00');
            fprintf(fid, '%s\r\n', '*CO    0.00');
            fprintf(fid, '%s\r\n', '*REFPW 100.0');
            fprintf(fid, '%s\r\n',  ['*VWI ', num2str(mu_w*1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', '*CVW   0.0');
            fprintf(fid, '%s\r\n', '*CVO   0.0');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *ROCKFLUID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*ROCKFLUID');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RPT 1');
            fprintf(fid, '%s\r\n', 'SWT SWTKRTHR 5e-16');
            %{
            fprintf(fid, '%s\r\n', '0	0	1	50');
            fprintf(fid,'%s\r\n', ' 0.1	0.1	0.9	45');
            fprintf(fid,'%s\r\n', '0.2	0.2	0.8	40 ');
            fprintf(fid,'%s\r\n', ' 0.3	0.3	0.7	35');
            fprintf(fid,'%s\r\n', '0.4	0.4	0.6	30 ');
            fprintf(fid,'%s\r\n', '0.5	0.5	0.5	25 ');
            fprintf(fid,'%s\r\n', '0.6	0.6	0.4	20 ');
            fprintf(fid,'%s\r\n', '0.7	0.7	0.3	15 ');
            fprintf(fid,'%s\r\n', '0.8	0.8	0.2	10 ');
            fprintf(fid,'%s\r\n', '0.9	0.9	0.1	5 ');
            fprintf(fid,'%s\r\n', '1	1	0	0 ');
%}
           for i = 1:n_pts
                fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(pc_fine(i), '%25.15f')]);
            end
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PCWMAX CON ', num2str(pc_fine(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '*RTYPE CON 1');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Initial');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*VERTICAL');
            fprintf(fid, '%s\r\n', '*REFDEPTH 5');
            fprintf(fid, '%s\r\n', '*REFPRES 5000');
            fprintf(fid, '%s\r\n', '*DWOC 0');
            fprintf(fid, '%s\r\n', '');

            %{
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*USER_INPUT');
            fprintf(fid, '%s\r\n', ['*PRES *ALL ', int2str(Nx_sub*Nz_sub*Ny_sub),'*29000']);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny

                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).press_initial_mat(i,j,k));
                
                    end
                end
            end
            %}
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*SO *ALL ',  num2str((Nx_sub+(Nx_sub*100))*Nz_sub*Ny_sub), '*', '0.0' ]);
            fprintf(fid, '%s\r\n', '*PB *CON 0.0');
            
            
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Numerical');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            
             fprintf(fid, '%s\r\n', 'NUMERICAL');
            fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
            fprintf(fid, '%s\r\n', ['DTMAX 0.1']);
            fprintf(fid, '%s\r\n', 'NORTH 80');
            fprintf(fid, '%s\r\n', 'ITERMAX 400');
            fprintf(fid, '%s\r\n', 'NCUTS 200');
            fprintf(fid, '%s\r\n', '*PRECC 1.00E-6');
            
%             fprintf(fid, '%s\r\n', 'NUMERICAL');
%             fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
%             fprintf(fid, '%s\r\n', ['DTMAX ', num2str(dt_max_upscaling_horizontal, '%25.15f')]);
%             fprintf(fid, '%s\r\n', 'NORTH 200');
%             fprintf(fid, '%s\r\n', 'ITERMAX 200');
%             fprintf(fid, '%s\r\n', 'NCUTS 100');
%             fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *RUN');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RUN');
            fprintf(fid, '%s\r\n', '*DATE 2018 01 01');
          %  fprintf(fid, '%s\r\n', ['DTWELL ' num2str(dt_max_upscaling_horizontal/1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', 'GROUP ''IW'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', 'GROUP ''P'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
           
            count = 0;
             % aaa = 0;
             %if we have a buffer zone, we only need 1 well
          for aaa = ((Ny_sub/2):(Ny_sub/2)) %1:1%Ny
              count = count + 1;

            for ii  = well_perforations:well_perforations:Nz_sub
                

                l1 = ['*WELL ''IW', int2str(count),''' *ATTACHTO ''IW'''];
                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                l3 = 'INCOMP  WATER';        
                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(1), '%12.8f'), '   CONT REPEAT'];
                l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                l7 = ['PERF      WI  ''IW', int2str(count),''''];

                fprintf(fid, '%s\r\n', l1);
                fprintf(fid, '%s\r\n', l2);
                fprintf(fid, '%s\r\n', l3);
                fprintf(fid, '%s\r\n', l4);
               % fprintf(fid, '%s\r\n', l5);
                fprintf(fid, '%s\r\n', l6);
                fprintf(fid, '%s\r\n', l7);

                for j = 1:ii

                    status  = 'OPEN';

                    if (j == 1)
                        t1 =   ['1','   ',int2str(aaa), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
                    else
                        t1 =   ['1','   ',int2str(aaa), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
                    end

                    fprintf(fid, '%s\r\n', t1);
                end
                t1 = '   ';
                fprintf(fid, '%s\r\n', t1);

            end
            aaa = aaa + 1;
          end

            count = 0;
         %   aaa = 0;
            for aaa = ((Ny_sub/2):(Ny_sub/2))
                count = count + 1;

            for ii  = well_perforations:well_perforations:Nz_sub

                l1 = ['*WELL ''P', int2str(count),''' *ATTACHTO ''P'''];
                l2 = ['PRODUCER ''P', int2str(count),''''];
                l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(1), '%12.8f'), '   CONT REPEAT'];
               l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                l7 = ['PERF      WI  ''P', int2str(count),''''];

                fprintf(fid, '%s\r\n', l1);
                fprintf(fid, '%s\r\n', l2);
                fprintf(fid, '%s\r\n', l5);
                fprintf(fid, '%s\r\n', l6);
                fprintf(fid, '%s\r\n', l7);
                
                for j = 1:ii

                    
                    status = 'OPEN';

                    if (j == 1)
                        t1 =   [int2str((Nx_sub*10)+Nx_sub),'   ',int2str(aaa), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
                    else
                        t1 =   [int2str((Nx_sub*10)+Nx_sub),'   ',int2str(aaa), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
                    end

                    fprintf(fid, '%s\r\n', t1);
                end
                t1 = '   ';
                fprintf(fid, '%s\r\n', t1);
            end
            aaa = aaa + 1;
            end

            fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '    ');
                  
          
            count2 = 0;
            for j = 2:(n_pts*2+1)

                if (j <= n_pts+1)

                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(j-1,3) > 0)
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end
                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end
                        
                        fprintf(fid, '%s\r\n', ''); 

                        fprintf(fid, '%s\r\n', ''); 
                            

                        fprintf(fid, '%s\r\n', ' ');


                        count2 = count2+1;
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub

                                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                                l3 = 'INCOMP  WATER';
                                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(j), '%12.8f'), '   CONT REPEAT'];
                                t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l3);
                                fprintf(fid, '%s\r\n', l4);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end
                        
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub
                                
                               l2 = ['PRODUCER ''P', int2str(count),''''];
                               l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(j), '%12.8f'), '   CONT REPEAT'];
                               t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l5);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end
                        
                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(j-1- n_pts,3) > 0)

                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nx_sub+(Nx_sub*10))*Nz_sub*Ny_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str((Nx_sub*10)/2), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str((((Nx_sub*10)/2)) + Nx_sub), ':', int2str(Nx_sub+(Nx_sub*10)), ' ', int2str(1), ':', int2str(Ny), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        
                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    
                                    buffer_added = (Nx_sub*10)/2;
                                    
                                    col = Nz_sub - il+1;
                                    row = jl + buffer_added;
                                    col2 = Ny_sub - kl+1;
                                    
                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end
                        
                        
                        fprintf(fid, '%s\r\n', ' ');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', ' ');
                        %
                        count2 = count2+1;
                        count = 0;
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub

                                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                                l3 = 'INCOMP  WATER';
                                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(n_pts*2-j+2), '%12.8f'), '   CONT REPEAT'];
                                t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l3);
                                fprintf(fid, '%s\r\n', l4);
                                fprintf(fid, '%s\r\n', t1);
                            end
                           % aaa = aaa + 1;
                        end
                        
                        
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub
                                
                               l2 = ['PRODUCER ''P', int2str(count),''''];
                               l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_x(n_pts*2-j+2), '%12.8f'), '   CONT REPEAT'];
                               t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l5);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');

                    end
                end


            end

            t1 = '  ';
            fprintf(fid, '%s\r\n', t1);
            t1 = '*STOP';
            fprintf(fid, '%s\r\n', t1);
            fclose(fid);
            fclose('all');
            
            

      
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            



            %Generate horizontal upscaled file. Dimension 2
            
            fid = fopen(['IMEX_upscaling_horizontal_2',s_append_base{1},sub_append, '.dat'],'w');  
            fprintf(fid, '%s\r\n', '*INUNIT *SI');
            fprintf(fid, '%s\r\n', 'WSRF GRID TIME');
            fprintf(fid, '%s\r\n', 'WSRF WELL TIME');
            fprintf(fid, '%s\r\n', '**OUTSRF GRID PRES SG SW PCOW PCWSCL');
            fprintf(fid, '%s\r\n', '*OUTSRF *GRID *ALL');
            fprintf(fid, '%s\r\n', '**DIM SOLVER_DIMENSIONING ''ON''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *GRID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*GRID ', '*VARI ', int2str((Nx_sub)),' ', int2str(Ny_sub+(Ny_sub*10)),' ', int2str(Nz_sub)]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DI ', '*CON ', num2str(ds_x, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DJ ', '*CON ', num2str(ds_y, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DK ', '*CON ', num2str(ds_z, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'DTOP');
            fprintf(fid, '%s\r\n',  [  int2str((Ny_sub+(Ny_sub*10))*Nx_sub), '*', num2str(nanmin(nanmin(nanmin(subvol_struct(iii,jjj,kkk).zMat(:,:)))), '%50g') ]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*POR *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str((Ny_sub*10)/2), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', '0.2']);
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2) + Ny_sub), ':', int2str(((Ny_sub*10)) + Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',('0.2')]);

            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Ny_sub*10)/2;
                        
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1+buffer_added; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).porMat(i,j,k));
                    end
                end
            end            
            %{
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');

            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).porMat(i,j,k));
                    end
                end
            end
%}
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*PERMI *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);
            
            fprintf(fid, '%s\r\n', '*MOD');
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Ny_sub*10)/2;
                        
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1 + buffer_added; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).permMat(i,j,k));
                    end
                end
            end            
%{
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).permMat(i,j,k));
                    end
                end
            end
            %}

            fprintf(fid, '%s\r\n', '*PERMJ *EQUALSI');
            fprintf(fid, '%s\r\n', '*PERMK *EQUALSI');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PRPOR ', num2str(press_av*100, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *MODEL');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'MODEL *OILWATER');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*TRES ', num2str(temp_av, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DENSITY GAS ', num2str(rho_g/100, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY OIL ', num2str(rho_g, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY WATER ', num2str(rho_w, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'PVT');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['10.0000000000000000	0.0000000000093000	0.9999940000000000	0.9999994000000000 ', num2str(mu_g*1000,'%25.15f'),' ', num2str(mu_g*100,'%25.15f')]);
            fprintf(fid, '%s\r\n',  ['1000.0000000000000000	0.0000000000094000	0.9999950000000000	0.9999995000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['2000.0000000000000000	0.0000000000095000	0.9999960000000000	0.9999996000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['4000.0000000000000000	0.0000000000096000	0.9999970000000000	0.9999997000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['6000.0000000000000000	0.0000000000097000	0.9999980000000000	0.9999998000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['8000.0000000000000000	0.0000000000098000	0.9999990000000000	0.9999999000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['9000.0000000000000000	0.0000000000099000	1.0000000000000000	1.0000000000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['10000.0000000000000000	0.0000000000100000	1.0000001000000000	1.0000001000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['11000.0000000000000000	0.0000000000110000	1.0000002000000000	1.0000002000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['120000.0000000000000000	0.0000000000120000	1.0000003000000000	1.0000003000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['130000.0000000000000000	0.0000000000130000	1.0000004000000000	1.0000004000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*BWI   1.00');
            fprintf(fid, '%s\r\n', '*CW    0.00');
            fprintf(fid, '%s\r\n', '*CO    0.00');
            fprintf(fid, '%s\r\n', '*REFPW 100.0');
            fprintf(fid, '%s\r\n',  ['*VWI ', num2str(mu_w*1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', '*CVW   0.0');
            fprintf(fid, '%s\r\n', '*CVO   0.0');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *ROCKFLUID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*ROCKFLUID');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RPT 1');
            fprintf(fid, '%s\r\n', 'SWT SWTKRTHR 5e-16');
%             
%             fprintf(fid, '%s\r\n', '0	0	1	50');
%             fprintf(fid,'%s\r\n', ' 0.1	0.1	0.9	45');
%             fprintf(fid,'%s\r\n', '0.2	0.2	0.8	40 ');
%             fprintf(fid,'%s\r\n', ' 0.3	0.3	0.7	35');
%             fprintf(fid,'%s\r\n', '0.4	0.4	0.6	30 ');
%             fprintf(fid,'%s\r\n', '0.5	0.5	0.5	25 ');
%             fprintf(fid,'%s\r\n', '0.6	0.6	0.4	20 ');
%             fprintf(fid,'%s\r\n', '0.7	0.7	0.3	15 ');
%             fprintf(fid,'%s\r\n', '0.8	0.8	0.2	10 ');
%             fprintf(fid,'%s\r\n', '0.9	0.9	0.1	5 ');
%             fprintf(fid,'%s\r\n', '1	1	0	0 ');

           for i = 1:n_pts
               fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(pc_fine(i), '%25.15f')]);
           end
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PCWMAX CON ', num2str(pc_fine(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '*RTYPE CON 1');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Initial');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*VERTICAL');
            fprintf(fid, '%s\r\n', '*REFDEPTH 5');
            fprintf(fid, '%s\r\n', '*REFPRES 5000');
            fprintf(fid, '%s\r\n', '*DWOC 0');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', ['*SO *ALL ', int2str(Nx_sub*Nz_sub*Ny_sub*(Ny_sub*10)),'*0.0']);
            fprintf(fid, '%s\r\n', '*PB *CON 0.0');
            
            %{
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*USER_INPUT');
            fprintf(fid, '%s\r\n', ['*PRES *ALL ', int2str(Nx_sub*Nz_sub*Ny_sub),'*29000']);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny

                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).press_initial_mat(i,j,k));
                
                    end
                end
            end
            %}
            fprintf(fid, '%s\r\n', '');
            
            
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Numerical');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            
             fprintf(fid, '%s\r\n', 'NUMERICAL');
            fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
            fprintf(fid, '%s\r\n', ['DTMAX 0.1']);
            fprintf(fid, '%s\r\n', 'NORTH 80');
            fprintf(fid, '%s\r\n', 'ITERMAX 400');
            fprintf(fid, '%s\r\n', 'NCUTS 200');
            fprintf(fid, '%s\r\n', '*PRECC 1.00E-6');
            
%             fprintf(fid, '%s\r\n', 'NUMERICAL');
%             fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
%             fprintf(fid, '%s\r\n', ['DTMAX ', num2str(dt_max_upscaling_horizontal_2, '%25.15f')]);
%             fprintf(fid, '%s\r\n', 'NORTH 200');
%             fprintf(fid, '%s\r\n', 'ITERMAX 200');
%             fprintf(fid, '%s\r\n', 'NCUTS 100');
%             fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *RUN');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RUN');
            fprintf(fid, '%s\r\n', '*DATE 2018 01 01');
          %  fprintf(fid, '%s\r\n', ['DTWELL ' num2str(dt_max_upscaling_horizontal_2/1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', 'GROUP ''IW'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', 'GROUP ''P'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
           
            count = 0;
             % aaa = 0;
             %if we have a buffer zone, we only need 1 well
          for aaa = ((Ny_sub/2):(Ny_sub/2)) %1:1%Ny
              count = count + 1;

            for ii  = well_perforations:well_perforations:Nz_sub
                

                l1 = ['*WELL ''IW', int2str(count),''' *ATTACHTO ''IW'''];
                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                l3 = 'INCOMP  WATER';                
                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(1), '%12.8f'), '   CONT REPEAT'];
                l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                l7 = ['PERF      WI  ''IW', int2str(count),''''];

                fprintf(fid, '%s\r\n', l1);
                fprintf(fid, '%s\r\n', l2);
                fprintf(fid, '%s\r\n', l3);
                fprintf(fid, '%s\r\n', l4);
               % fprintf(fid, '%s\r\n', l5);
                fprintf(fid, '%s\r\n', l6);
                fprintf(fid, '%s\r\n', l7);

                for j = 1:ii
%{
                    for iiii = 1:well_perforations

                        if (j == ((count-1)*well_perforations + iiii))
                            status = 'OPEN';
                            break
                        else
                            status = 'CLOSED';
                        end
                    end
                    %}
                    
                    status  = 'OPEN';

                    if (j == 1)
                        t1 =   [int2str(aaa), ' ', '1', '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
                    else
                        t1 =   [int2str(aaa), ' ', '1', '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
                    end

                    fprintf(fid, '%s\r\n', t1);
                end
                t1 = '   ';
                fprintf(fid, '%s\r\n', t1);

            end
            aaa = aaa + 1;
          end

            count = 0;
         %   aaa = 0;
            for aaa = ((Ny_sub/2):(Ny_sub/2))
                count = count + 1;

            for ii  = well_perforations:well_perforations:Nz_sub

                l1 = ['*WELL ''P', int2str(count),''' *ATTACHTO ''P'''];
                l2 = ['PRODUCER ''P', int2str(count),''''];
                l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(1), '%12.8f'), '   CONT REPEAT'];
                l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                l7 = ['PERF      WI  ''P', int2str(count),''''];

                fprintf(fid, '%s\r\n', l1);
                fprintf(fid, '%s\r\n', l2);
                fprintf(fid, '%s\r\n', l5);
                fprintf(fid, '%s\r\n', l6);
                fprintf(fid, '%s\r\n', l7);
                
                for j = 1:ii
                    
                    status = 'OPEN';

                    if (j == 1)
                        t1 =   [int2str(aaa), ' ', int2str((Ny_sub*10)+Ny_sub), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
                    else
                        t1 =   [int2str(aaa), ' ', int2str((Ny_sub*10)+Ny_sub), '   ',int2str(j), '   ','10000000','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
                    end

                    fprintf(fid, '%s\r\n', t1);
                end
                t1 = '   ';
                fprintf(fid, '%s\r\n', t1);
            end
            aaa = aaa + 1;
            end

            fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '    ');
            
            
            
            count2 = 0;
            for j = 2:(n_pts*2+1)

                if (j <= n_pts+1)

                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(j-1,2) > 0)
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub
                                    

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end        
                        
                        
                        
                        

                        fprintf(fid, '%s\r\n', '');
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end        
                        

                        fprintf(fid, '%s\r\n', ''); 
                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end        
                        
                            

                        fprintf(fid, '%s\r\n', ' ');


                        count2 = count2+1;
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub

                                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                                l3 = 'INCOMP  WATER';
                                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(j), '%12.8f'), '   CONT REPEAT'];
                                t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l3);
                                fprintf(fid, '%s\r\n', l4);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end
                        
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub
                                
                               l2 = ['PRODUCER ''P', int2str(count),''''];
                               l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(j), '%12.8f'), '   CONT REPEAT'];
                               t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l5);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end
                        
                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(j-1- n_pts,2) > 0)
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end        
                        
                        

                        
                        
                        fprintf(fid, '%s\r\n', ' ');
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end        

                        fprintf(fid, '%s\r\n', '');
                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Ny_sub+(Ny_sub*10))*Nz_sub*Nx_sub), '*', '0.2' ]);

                        fprintf(fid, '%s\r\n', '*MOD');

                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(((Ny_sub*10)/2)), ' ',int2str(1), ':', int2str(Nz_sub), ' = ', num2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(((Ny_sub*10)/2)+Ny_sub), ':', int2str((Ny_sub*10)+Ny_sub), ' ',int2str(1), ':', int2str(Nz_sub), ' = ',num2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Ny_sub*10)/2;

                                    col = Nz_sub - il+1; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 + buffer_added; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end        
                        fprintf(fid, '%s\r\n', ' ');
                        %
                        count2 = count2+1;
                        count = 0;
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub

                                l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count),''''];
                                l3 = 'INCOMP  WATER';
                                l4 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(n_pts*2-j+2), '%12.8f'), '   CONT REPEAT'];
                                t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l3);
                                fprintf(fid, '%s\r\n', l4);
                                fprintf(fid, '%s\r\n', t1);
                            end
                           % aaa = aaa + 1;
                        end
                        
                        
                        count = 0;
                        
                        for aaa = 1:1%Ny
                            count = count + 1;
                            for ii  = well_perforations:well_perforations:Nz_sub
                                
                               l2 = ['PRODUCER ''P', int2str(count),''''];
                               l5 = ['OPERATE  MAX  BHW   ', num2str(Qw_upscaling_y(n_pts*2-j+2), '%12.8f'), '   CONT REPEAT'];
                               t1 = '   ';

                                fprintf(fid, '%s\r\n', l2);
                                fprintf(fid, '%s\r\n', l5);
                                fprintf(fid, '%s\r\n', t1);
                            end
                            aaa = aaa + 1;
                        end                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_horiz_2(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');

                    end
                end


            end

            t1 = '  ';
            fprintf(fid, '%s\r\n', t1);
            t1 = '*STOP';
            fprintf(fid, '%s\r\n', t1);
            fclose(fid);
            fclose('all');
            
            
  
           
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            %Generate vertical upscaled file. Dimension 2
            
            fid = fopen(['IMEX_upscaling_vertical',s_append_base{1},sub_append, '.dat'],'w');  
            fprintf(fid, '%s\r\n', '*INUNIT *SI');
            fprintf(fid, '%s\r\n', 'WSRF GRID TIME');
            fprintf(fid, '%s\r\n', 'WSRF WELL TIME');
            fprintf(fid, '%s\r\n', '**OUTSRF GRID PRES SG SW PCOW PCWSCL');
            fprintf(fid, '%s\r\n', '*OUTSRF *GRID *ALL');
            fprintf(fid, '%s\r\n', '**DIM SOLVER_DIMENSIONING ''ON''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *GRID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*GRID ', '*VARI ', int2str((Nx_sub)),' ', int2str(Ny_sub),' ', int2str(Nz_sub+(Nz_sub*100))]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DI ', '*CON ', num2str(ds_x, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DJ ', '*CON ', num2str(ds_y, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DK ', '*CON ', num2str(ds_z, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'DTOP');
            fprintf(fid, '%s\r\n',  [  int2str(Ny_sub*Nx_sub), '*', num2str(nanmin(nanmin(nanmin(subvol_struct(iii,jjj,kkk).zMat(:,:)))), '%50g') ]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*POR *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', '0.2']);
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',('0.2')]);

            
          
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Nz_sub*100)/2;
                        
                        col = Nz_sub - i+1 + buffer_added; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).porMat(i,j,k));
                    end
                end
            end            
           

            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*PERMI *ALL');
            fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
            fprintf(fid, '%s\r\n', '*MOD');
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
            fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

            
           
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        
                        buffer_added = (Nz_sub*100)/2;
                        
                        col = Nz_sub - i+1+buffer_added; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1 ; %Ny
                        
                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).permMat(i,j,k));
                    end
                end
            end            



            fprintf(fid, '%s\r\n', '*PERMJ *EQUALSI');
            fprintf(fid, '%s\r\n', '*PERMK *EQUALSI');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PRPOR ', num2str(press_av*100, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *MODEL');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'MODEL *OILWATER');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*TRES ', num2str(temp_av, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*DENSITY GAS ', num2str(rho_g/100, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY OIL ', num2str(rho_g, '%50g')]);
            fprintf(fid, '%s\r\n',  ['*DENSITY WATER ', num2str(rho_w, '%50g')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', 'PVT');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['10.0000000000000000	0.0000000000093000	0.9999940000000000	0.9999994000000000 ', num2str(mu_g*1000,'%25.15f'),' ', num2str(mu_g*100,'%25.15f')]);
            fprintf(fid, '%s\r\n',  ['1000.0000000000000000	0.0000000000094000	0.9999950000000000	0.9999995000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['2000.0000000000000000	0.0000000000095000	0.9999960000000000	0.9999996000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['4000.0000000000000000	0.0000000000096000	0.9999970000000000	0.9999997000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['6000.0000000000000000	0.0000000000097000	0.9999980000000000	0.9999998000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['8000.0000000000000000	0.0000000000098000	0.9999990000000000	0.9999999000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['9000.0000000000000000	0.0000000000099000	1.0000000000000000	1.0000000000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['10000.0000000000000000	0.0000000000100000	1.0000001000000000	1.0000001000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['11000.0000000000000000	0.0000000000110000	1.0000002000000000	1.0000002000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['120000.0000000000000000	0.0000000000120000	1.0000003000000000	1.0000003000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n',  ['130000.0000000000000000	0.0000000000130000	1.0000004000000000	1.0000004000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%25.15f')]);
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*BWI   1.00');
            fprintf(fid, '%s\r\n', '*CW    0.00');
            fprintf(fid, '%s\r\n', '*CO    0.00');
            fprintf(fid, '%s\r\n', '*REFPW 5000.0');
            fprintf(fid, '%s\r\n',  ['*VWI ', num2str(mu_w*1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', '*CVW   0.0');
            fprintf(fid, '%s\r\n', '*CVO   0.0');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *ROCKFLUID');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*ROCKFLUID');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RPT 1');
            fprintf(fid, '%s\r\n', 'SWT SWTKRTHR 5e-16');


            for i = 1:n_pts
                fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(pc_fine(i), '%25.15f')]);
            end
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n',  ['*PCWMAX CON ', num2str(pc_fine(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '*RTYPE CON 1');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Initial');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*VERTICAL');
            fprintf(fid, '%s\r\n', '*REFDEPTH 5');
            fprintf(fid, '%s\r\n', '*REFPRES 5000');
            fprintf(fid, '%s\r\n', '*DWOC 0');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', ['*SO *ALL ', int2str(Nx_sub*Nz_sub*Ny_sub*(Nz_sub*100)),'*0.0']);
            fprintf(fid, '%s\r\n', '*PB *CON 0.0');
            
            %{
            
            fprintf(fid, '%s\r\n', '*INITIAL');
            fprintf(fid, '%s\r\n', '*USER_INPUT');
            fprintf(fid, '%s\r\n', ['*PRES *ALL ', int2str(Nx_sub*Nz_sub*Ny_sub),'*29000']);
            fprintf(fid, '%s\r\n', '*MOD');
            fprintf(fid, '%s\r\n', '');
            for i = 1:Nz_sub
                for j = 1:Nx_sub
                    for k = 1:Ny_sub
                        col = Nz_sub - i+1; %Nz
                        row = j; %Nx
                        col2 = Ny_sub - k +1; %Ny

                        fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).press_initial_mat(i,j,k));
                
                    end
                end
            end
            %}
            fprintf(fid, '%s\r\n', '');
            
            
            
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *Numerical');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            
            
            %{
            DTMIN 1e-10
            DTMAX 0.1
            ITERMAX 400
            NCUTS 200
            NORTH 80
            *PRECC 1.00E-6
            
            %}
            
            fprintf(fid, '%s\r\n', 'NUMERICAL');
            fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
            fprintf(fid, '%s\r\n', ['DTMAX 0.1']);
            fprintf(fid, '%s\r\n', 'NORTH 80');
            fprintf(fid, '%s\r\n', 'ITERMAX 400');
            fprintf(fid, '%s\r\n', 'NCUTS 200');
            fprintf(fid, '%s\r\n', '*PRECC 1.00E-6');
            %fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
 
%             fprintf(fid, '%s\r\n', 'NUMERICAL');
%             fprintf(fid, '%s\r\n', 'DTMIN 1e-10');
%             fprintf(fid, '%s\r\n', ['DTMAX ', num2str((dt_max_upscaling_vertical/100), '%25.15f')]);
%             fprintf(fid, '%s\r\n', 'NORTH 200');
%             fprintf(fid, '%s\r\n', 'ITERMAX 200');
%             fprintf(fid, '%s\r\n', 'NCUTS 100');
%             fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '***************************************************************************');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '**              *RUN');
            fprintf(fid, '%s\r\n', '**');
            fprintf(fid, '%s\r\n', '****************************************************************************');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '*RUN');
            fprintf(fid, '%s\r\n', '*DATE 2018 01 01');
            %fprintf(fid, '%s\r\n', ['DTWELL ' num2str(dt_max_upscaling_vertical/1000, '%25.15f')]);
            fprintf(fid, '%s\r\n', 'GROUP ''IW'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', 'GROUP ''P'' ATTACHTO ''FIELD''');
            fprintf(fid, '%s\r\n', '');
            fprintf(fid, '%s\r\n', '');
           
            count_inj = 0;
             
             %found that for vertical case, we need to complete wells in
             %each grid block to have constant pressure BC
             
             for bb = 1:Nx_sub
                 for aa = 1:Ny_sub
                     count_inj = count_inj+1;

                    l1 = ['*WELL ''IW', int2str(count_inj),''' *ATTACHTO ''IW'''];
                    l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count_inj),''''];
                    l3 = ['INCOMP  WATER'];
                    l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(1)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];
                    l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                    l7 = ['PERF      WI  ''IW', int2str(count_inj),''''];

                    fprintf(fid, '%s\r\n', l1);
                    fprintf(fid, '%s\r\n', l2);
                    fprintf(fid, '%s\r\n', l3);
                    fprintf(fid, '%s\r\n', l4);
                    fprintf(fid, '%s\r\n', l6);
                    fprintf(fid, '%s\r\n', l7);
                    
                    

                    for j = 1:1 % we have 1 perforation per well, will always be open


                        status  = 'OPEN';
                        status2 = 'CLOSED';

                        if (j == 1)
                            t1 =   [int2str(bb), ' ',int2str(aa), ' ', '1', '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];

                        end

                        fprintf(fid, '%s\r\n', t1);
                    end
                    t1 = '   ';
                    fprintf(fid, '%s\r\n', t1);

                 end
             end
             
             
            count_prod = 0;
             
             %found that for vertical case, we need to complete wells in
             %each grid block to have constant pressure BC
             
             for bb = 1:Nx_sub
                 for aa = 1:Ny_sub
                     count_prod = count_prod+1;

                    l1 = ['*WELL ''P', int2str(count_prod),''' *ATTACHTO ''P'''];
                    l2 = ['PRODUCER ''P', int2str(count_prod),''''];
                    l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(1)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];
                    l6 = 'GEOMETRY  K  0.15  0.367879  1.0   0';
                    l7 = ['PERF      WI  ''P', int2str(count_prod),''''];

                    fprintf(fid, '%s\r\n', l1);
                    fprintf(fid, '%s\r\n', l2);
                    fprintf(fid, '%s\r\n', l4);
                    fprintf(fid, '%s\r\n', l6);
                    fprintf(fid, '%s\r\n', l7);
                    
                    

                    for j = 1:1 % we have 1 perforation per well, will always be open


                        status  = 'OPEN';
                        status2 = 'CLOSED';

                        if (j == 1)
                            t1 =   [int2str(bb), ' ',int2str(aa), ' ', int2str((Nz_sub*100)+Nz_sub), '   ','10000000','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];

                        end

                        fprintf(fid, '%s\r\n', t1);
                    end
                    t1 = '   ';
                    fprintf(fid, '%s\r\n', t1);

                 end
             end             
             
             
             
             

            fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_vert(1), '%25.15f')]);
            fprintf(fid, '%s\r\n', '    ');
            
            
            %THIS NEEDS TO CHANGE


            count2 = 0;
            for j = 2:(n_pts*2+1)

                if (j <= n_pts+1)

                    if (subvol_struct(iii,jjj,kkk).kg_phase_connected(j-1,1) > 0)
                        
                        count2 = count2+1;
                        count = 0;
                        
                        
                        
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');

                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kg_mat(il,jl,kl,(j-1)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');
                        
                        
                    count_inj = 0;

                     %found that for vertical case, we need to complete wells in
                     %each grid block to have constant pressure BC

                     for bb = 1:Nx_sub
                         for aa = 1:Ny_sub
                             count_inj = count_inj+1;

                            l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count_inj),''''];
                            l3 = ['INCOMP  WATER'];
                            l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(j)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];

                            fprintf(fid, '%s\r\n', l2);
                            fprintf(fid, '%s\r\n', l3);
                            fprintf(fid, '%s\r\n', l4);

                         end
                     end
                     
                     
                     
                      count_prod = 0;
             
                     %found that for vertical case, we need to complete wells in
                     %each grid block to have constant pressure BC

                     for bb = 1:Nx_sub
                         for aa = 1:Ny_sub
                             count_prod = count_prod+1;

                            l2 = ['PRODUCER ''P', int2str(count_prod),''''];
                            l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(j)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];

                            fprintf(fid, '%s\r\n', l2);
                            fprintf(fid, '%s\r\n', l4);


                         end
                     end             
             
                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_vert(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');
                    end
                else
                    if (subvol_struct(iii,jjj,kkk).kw_phase_connected(j-1- n_pts,1) > 0)
                        
                        count2 = count2+1;

                        
                        
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', '*PERMI *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');
                        
                        
                        fprintf(fid, '%s\r\n', '*PERMJ *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');

                        
                        fprintf(fid, '%s\r\n', '*PERMK *ALL');
                        fprintf(fid, '%s\r\n',  [  num2str((Nz_sub+(Nz_sub*100))*Ny_sub*Nx_sub), '*', '0.2' ]);
                        fprintf(fid, '%s\r\n', '*MOD');
                        fprintf(fid, '%s\r\n', '');
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(1), ':', int2str((Nz_sub*100)/2), ' = ', int2str(perm_mat_buffer)]);
                        fprintf(fid, '%s\r\n', [int2str(1), ':', int2str(Nx_sub), ' ', int2str(1), ':', int2str(Ny_sub), ' ',int2str(((Nz_sub*100)/2) + Nz_sub), ':', int2str(((Nz_sub*100)) + Nz_sub), ' = ',int2str(perm_mat_buffer)]);

                        for il = 1:Nz_sub
                            for jl = 1:Nx_sub
                                for kl = 1:Ny_sub

                                    buffer_added = (Nz_sub*100)/2;

                                    col = Nz_sub - il+1+buffer_added; %Nz
                                    row = jl; %Nx
                                    col2 = Ny_sub - kl +1 ; %Ny

                                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', subvol_struct(iii,jjj,kkk).kw_mat(il,jl, kl, (j-1- n_pts)));
                                end
                            end
                        end            

                        fprintf(fid, '%s\r\n', ' ');
                        
                        
                       count_inj = 0;

                     %found that for vertical case, we need to complete wells in
                     %each grid block to have constant pressure BC

                     for bb = 1:Nx_sub
                         for aa = 1:Ny_sub
                             count_inj = count_inj+1;

                            l2 = ['INJECTOR MOBWEIGHT ''IW', int2str(count_inj),''''];
                            l3 = ['INCOMP  WATER'];
                            l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(n_pts*2-j+2)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];

                            fprintf(fid, '%s\r\n', l2);
                            fprintf(fid, '%s\r\n', l3);
                            fprintf(fid, '%s\r\n', l4);

                         end
                     end
                     
                     
                     
                      count_prod = 0;
             
                     %found that for vertical case, we need to complete wells in
                     %each grid block to have constant pressure BC

                     for bb = 1:Nx_sub
                         for aa = 1:Ny_sub
                             count_prod = count_prod+1;

                            l2 = ['PRODUCER ''P', int2str(count_prod),''''];
                            l4 = ['OPERATE  MAX  BHW   ', num2str((Qw_upscaling_z(n_pts*2-j+2)/(Nx_sub*Ny_sub)), '%12.8f'), '   CONT REPEAT'];

                            fprintf(fid, '%s\r\n', l2);
                            fprintf(fid, '%s\r\n', l4);


                         end
                     end             
              
                        
                        

                        fprintf(fid, '%12s\r\n', ['TIME    ', num2str(subvol_struct(iii,jjj,kkk).time_upscaling_vert(count2+1), '%25.15f')]);
                        fprintf(fid, '%s\r\n', '    ');

                    end
                end


            end

            
            
            
            t1 = '  ';
            fprintf(fid, '%s\r\n', t1);
            t1 = '*STOP';
            fprintf(fid, '%s\r\n', t1);
            fclose(fid);
            fclose('all');            
            
            
  
            
            
            
            
            
            
            
        end
    end
end


disp('Fininished generating upscaling files')
disp(' ')
disp(' ')

