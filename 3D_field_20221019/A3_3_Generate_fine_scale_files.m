%Now we generate and run the fine-scale simulations. This is essentially
%the same as the fine scale code, so will not be commented here. Please
%refer to the other code for specifics.


format long

for qq = 1:N_Qg
    
    fid = fopen(['IMEX_full_hetero_report_gen',s_append_base{qq}, '.rwd'],'w');
    fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_full_hetero',s_append_base{qq}, '.irf''']);
    fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_full_hetero',s_append_base{qq},'_Pressure_sim','.txt''']);
    fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
    fprintf(fid, '%s\r\n', '*SRF-FORMAT');
    fprintf(fid, '%s\r\n', '  ');
    
    fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_full_hetero',s_append_base{qq},'_Oil_Saturation_sim','.txt''']);
    fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''SO''', ' *ALL-TIMES']);
    fprintf(fid, '%s\r\n', '*SRF-FORMAT');
    fprintf(fid, '%s\r\n', '  ');
    fclose(fid);
    
    fid = fopen(['IMEX_full_hom_Pc_report_gen',s_append_base{qq}, '.rwd'],'w');
    fprintf(fid, '%s\r\n', ['*FILE ', '''IMEX_full_hom_Pc',s_append_base{qq}, '.irf''']);
    fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_full_hom_Pc',s_append_base{qq},'_Pressure_sim','.txt''']);
    fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''PRES''', ' *ALL-TIMES']);
    fprintf(fid, '%s\r\n', '*SRF-FORMAT');
    fprintf(fid, '%s\r\n', '  ');
    
    fprintf(fid, '%s\r\n', ['*OUTPUT ', '''IMEX_full_hom_Pc',s_append_base{qq},'_Oil_Saturation_sim','.txt''']);
    fprintf(fid, '%s\r\n', ['*PROPERTY-FOR ', '''SO''', ' *ALL-TIMES']);
    fprintf(fid, '%s\r\n', '*SRF-FORMAT');
    fprintf(fid, '%s\r\n', '  ');
    fclose(fid);
    
    
    fid = fopen(['IMEX_full_hetero',s_append_base{qq}, '.dat'],'w');
    
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
    fprintf(fid, '%s\r\n',  ['*GRID ', '*VARI ', int2str(Nx),' ', int2str(Ny),' ', int2str(Nz)]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n',  ['*DI ', '*CON ', num2str(ds_x, '%50g')]);
    fprintf(fid, '%s\r\n',  ['*DJ ', '*CON ', num2str(ds_y, '%50g')]);
    fprintf(fid, '%s\r\n',  ['*DK ', '*CON ', num2str(ds_z, '%50g')]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DTOP');
    fprintf(fid, '%s\r\n',  [  int2str(Nx*Ny), '*', num2str(Reservior_top, '%50g') ]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*POR *ALL');
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Nz*Ny), '*', '0.2' ]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny

                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', por_mat_corr(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*PERMI *ALL');
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Nz*Ny), '*', '0.2' ]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny

                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', perm_mat_corr(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
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
    fprintf(fid, '%s\r\n',  ['1000.0000000000000000	0.0000000000094000	0.9999950000000000	0.9999995000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['2000.0000000000000000	0.0000000000095000	0.9999960000000000	0.9999996000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['4000.0000000000000000	0.0000000000096000	0.9999970000000000	0.9999997000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['6000.0000000000000000	0.0000000000097000	0.9999980000000000	0.9999998000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['8000.0000000000000000	0.0000000000098000	0.9999990000000000	0.9999999000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['9000.0000000000000000	0.0000000000099000	1.0000000000000000	1.0000000000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['10000.0000000000000000	0.0000000000100000	1.0000001000000000	1.0000001000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['11000.0000000000000000	0.0000000000110000	1.0000002000000000	1.0000002000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['120000.0000000000000000	0.0000000000120000	1.0000003000000000	1.0000003000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['130000.0000000000000000	0.0000000000130000	1.0000004000000000	1.0000004000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
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
    
    for i = 1:n_pts
        fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(pc_fine(i), '%25.15f')]);
    end
    
    fprintf(fid, '%s\r\n', '*RPT 2');
    fprintf(fid, '%s\r\n', 'SWT SWTKRTHR 5e-16');
    
    for i = 1:n_pts
        fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(0.00, '%25.15f')]);
    end
    
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n',  ['*PCWMAX CON ', num2str(pc_fine(1), '%25.15f')]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny

                if (j == 1)
                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', 0.0);
                else
                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', pc_end_mat_corr(i,j,k));
                end
            end
        end
    end
    
    

    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*RTYPE CON 1');
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny
                
                if (j == 1)
                    fprintf(fid,'%u %u %u %1s \r\n',row,col2, col,' = 2 ');
                else
                    fprintf(fid,'%u %u %u %1s \r\n',row,col2, col,' = 1');
                end
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '***************************************************************************');
    fprintf(fid, '%s\r\n', '**');
    fprintf(fid, '%s\r\n', '**              *Initial');
    fprintf(fid, '%s\r\n', '**');
    fprintf(fid, '%s\r\n', '****************************************************************************');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*INITIAL');
    fprintf(fid, '%s\r\n', '*USER_INPUT');
    fprintf(fid, '%s\r\n', ['*PRES *ALL ', int2str(Nx*Nz*Ny),'*29000']);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny

                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', pressure_initial_mat(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', ['*SO *ALL ', int2str(Nx*Nz*Ny),'*0.0']);
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
    fprintf(fid, '%s\r\n', ['DTMAX ' num2str(dt_max(qq), '%25.15f')]);
    fprintf(fid, '%s\r\n', 'NORTH 200');
    fprintf(fid, '%s\r\n', 'ITERMAX 200');
    fprintf(fid, '%s\r\n', 'NCUTS 100');
    fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
    fprintf(fid, '%s\r\n', 'PIVOT ON');
    fprintf(fid, '%s\r\n', 'SORDER RCMRB');
    fprintf(fid, '%s\r\n', 'SDEGREE 2');
    fprintf(fid, '%s\r\n',  ['*PNTHRDS ', num2str(processor_threads, '%50g')]);
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
    fprintf(fid, '%s\r\n', ['DTWELL ' num2str(dt_max(qq)/50, '%25.15f')]);
    fprintf(fid, '%s\r\n', 'GROUP ''IO'' ATTACHTO ''FIELD''');
    fprintf(fid, '%s\r\n', 'GROUP ''P'' ATTACHTO ''FIELD''');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    
    count = 0;
    
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        
        l1 = ['*WELL ''IO', int2str(count),''' *ATTACHTO ''IO'''];
        l2 = ['INJECTOR MOBWEIGHT ''IO', int2str(count),''''];
        l3 = 'INCOMP  OIL';
        l4 = ['OPERATE  MAX  STO   ', num2str(Qg(qq), '%20.12e'), '   CONT REPEAT'];
        l5 = 'OPERATE  MAX  BHP  800000        CONT REPEAT';
        l6 = 'GEOMETRY  K  0.00001  0.367879  1.0   0';
        l7 = ['PERF      GEOA  ''IO', int2str(count),''''];
        
        fprintf(fid, '%s\r\n', l1);
        fprintf(fid, '%s\r\n', l2);
        fprintf(fid, '%s\r\n', l3);
        fprintf(fid, '%s\r\n', l4);
        fprintf(fid, '%s\r\n', l5);
        fprintf(fid, '%s\r\n', l6);
        fprintf(fid, '%s\r\n', l7);
        
        for j = 1:ii
            
            for iii = 1:well_perforations_fine
                
                if (j == ((count-1)*well_perforations_fine + iii))
                    status = 'OPEN';
                    break
                else
                    status = 'CLOSED';
                end
            end
            
            if (j == 1)
                t1 =   ['1','   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
            else
                t1 =   ['1','   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
            end
            
            fprintf(fid, '%s\r\n', t1);
        end
        t1 = '   ';
        fprintf(fid, '%s\r\n', t1);
        
    end
    
    count = 0;
    
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        
        l1 = ['*WELL ''P', int2str(count),''' *ATTACHTO ''P'''];
        l2 = ['PRODUCER ''P', int2str(count),''''];
        l5 = ['OPERATE  MIN  BHP    ',  num2str(mean(bound_press(((count-1)*well_perforations_fine+1):((count-1)*well_perforations_fine+well_perforations_fine))), '%20.12e'),'   CONT REPEAT'];
        l6 = 'GEOMETRY  K  0.00001  0.367879  1.0   0';
        l7 = ['PERF      GEOA  ''P', int2str(count),''''];
        
        fprintf(fid, '%s\r\n', l1);
        fprintf(fid, '%s\r\n', l2);
        fprintf(fid, '%s\r\n', l5);
        fprintf(fid, '%s\r\n', l6);
        fprintf(fid, '%s\r\n', l7);
        for j = 1:ii
            
            
            for iii = 1:well_perforations_fine
                
                if (j == ((count-1)*well_perforations_fine + iii))
                    status = 'OPEN';
                    break
                else
                    status = 'CLOSED';
                end
            end
            
            
            if (j == 1)
                t1 =   [int2str(Nx),'   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
            else
                t1 =   [int2str(Nx),'   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
            end
            
            fprintf(fid, '%s\r\n', t1);
        end
        t1 = '   ';
        fprintf(fid, '%s\r\n', t1);
    end
    
    
    for i = 1:Nt
        if (rem(i,skip_nt) == 0)
            fprintf(fid, '%12s\r\n', ['TIME    ', num2str(Times(qq,i), '%25.15f')]);
        end
    end
    
    
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n','*STOP');
    fclose(fid);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    fid = fopen(['IMEX_full_hom_Pc',s_append_base{qq}, '.dat'],'w');
    
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
    fprintf(fid, '%s\r\n',  ['*GRID ', '*VARI ', int2str(Nx),' ', int2str(Ny),' ', int2str(Nz)]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n',  ['*DI ', '*CON ', num2str(ds_x, '%50g')]);
    fprintf(fid, '%s\r\n',  ['*DJ ', '*CON ', num2str(ds_y, '%50g')]);
    fprintf(fid, '%s\r\n',  ['*DK ', '*CON ', num2str(ds_z, '%50g')]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', 'DTOP');
    fprintf(fid, '%s\r\n',  [  int2str(Nx*Ny), '*', num2str(Reservior_top, '%50g') ]);
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*POR *ALL');
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Nz*Ny), '*', '0.2' ]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny
                
                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', por_mat_corr(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*PERMI *ALL');
    fprintf(fid, '%s\r\n',  [  num2str(Nx*Nz*Ny), '*', '0.2' ]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny
                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', perm_mat_corr(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
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
    fprintf(fid, '%s\r\n',  ['1000.0000000000000000	0.0000000000094000	0.9999950000000000	0.9999995000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['2000.0000000000000000	0.0000000000095000	0.9999960000000000	0.9999996000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['4000.0000000000000000	0.0000000000096000	0.9999970000000000	0.9999997000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['6000.0000000000000000	0.0000000000097000	0.9999980000000000	0.9999998000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['8000.0000000000000000	0.0000000000098000	0.9999990000000000	0.9999999000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['9000.0000000000000000	0.0000000000099000	1.0000000000000000	1.0000000000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['10000.0000000000000000	0.0000000000100000	1.0000001000000000	1.0000001000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['11000.0000000000000000	0.0000000000110000	1.0000002000000000	1.0000002000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['120000.0000000000000000	0.0000000000120000	1.0000003000000000	1.0000003000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
    fprintf(fid, '%s\r\n',  ['130000.0000000000000000	0.0000000000130000	1.0000004000000000	1.0000004000000000 ', num2str(mu_g*1000, '%25.15f'),' ', num2str(mu_g*100, '%50g')]);
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
    
    for i = 1:n_pts
        fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(pc_fine(i), '%25.15f')]);
    end
    
    fprintf(fid, '%s\r\n', '*RPT 2');
    fprintf(fid, '%s\r\n', 'SWT SWTKRTHR 5e-16');
    
    for i = 1:n_pts
        fprintf(fid, '%s\r\n',  [num2str(sw_aim(i), '%25.15f'),'   ',num2str(kw_fine_VL(i), '%25.15f'),'   ',num2str(kg_fine_VL(i), '%25.15f'),'   ',num2str(0.00, '%25.15f')]);
    end
    
    fprintf(fid, '%s\r\n', '');
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n',  ['*PCWMAX CON ', num2str(pc_fine(1), '%25.15f')]);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
            
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny
                
                if (j == 1)
                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', 0.0);
                else
                    fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', pc_fine(1));
                end
            end
        end
    end
    
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '*RTYPE CON 1');
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny
                
                if (j == 1)
                    fprintf(fid,'%u %u %u %1s \r\n',row,col2, col,' = 2 ');
                else
                    fprintf(fid,'%u %u %u %1s \r\n',row,col2, col,' = 1');
                end
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
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
    fprintf(fid, '%s\r\n', '*USER_INPUT');
    fprintf(fid, '%s\r\n', ['*PRES *ALL ', int2str(Nx*Nz*Ny),'*29000']);
    fprintf(fid, '%s\r\n', '*MOD');
    fprintf(fid, '%s\r\n', '');
    for i = 1:Nz
        for j = 1:Nx
            for k = 1:Ny
                
                col = Nz - i+1; %Nz
                row = j; %Nx
                col2 = Ny - k +1; %Ny

                fprintf(fid,'%u %u %u %1s %12.8f\r\n',row,col2, col,'=', pressure_initial_mat(i,j,k));
            end
        end
    end
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', ['*SO *ALL ', int2str(Nx*Nz*Ny),'*0.0']);
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
    fprintf(fid, '%s\r\n', ['DTMAX ' num2str(dt_max(qq), '%25.15f')]);
    fprintf(fid, '%s\r\n', 'NORTH 200');
    fprintf(fid, '%s\r\n', 'ITERMAX 200');
    fprintf(fid, '%s\r\n', 'NCUTS 100');
    fprintf(fid, '%s\r\n', 'MAXSTEPS 500000');
    fprintf(fid, '%s\r\n', 'SOLVER PARASOL');
    fprintf(fid, '%s\r\n', 'PIVOT ON');
    fprintf(fid, '%s\r\n', 'SORDER RCMRB');
    fprintf(fid, '%s\r\n', 'SDEGREE 2');
    fprintf(fid, '%s\r\n',  ['*PNTHRDS ', num2str(processor_threads, '%50g')]);
    
    
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
    fprintf(fid, '%s\r\n', ['DTWELL ' num2str(dt_max(qq)/50, '%25.15f')]);
    fprintf(fid, '%s\r\n', 'GROUP ''IO'' ATTACHTO ''FIELD''');
    fprintf(fid, '%s\r\n', 'GROUP ''P'' ATTACHTO ''FIELD''');
    fprintf(fid, '%s\r\n', '');
    fprintf(fid, '%s\r\n', '');
    
    count = 0;
    
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        
        l1 = ['*WELL ''IO', int2str(count),''' *ATTACHTO ''IO'''];
        l2 = ['INJECTOR MOBWEIGHT ''IO', int2str(count),''''];
        l3 = 'INCOMP  OIL';
        l4 = ['OPERATE  MAX  STO   ', num2str(Qg(qq), '%20.12e'), '   CONT REPEAT'];
        l5 = 'OPERATE  MAX  BHP  800000        CONT REPEAT';
        l6 = 'GEOMETRY  K  0.00001  0.367879  1.0   0';
        l7 = ['PERF      GEOA  ''IO', int2str(count),''''];
        
        fprintf(fid, '%s\r\n', l1);
        fprintf(fid, '%s\r\n', l2);
        fprintf(fid, '%s\r\n', l3);
        fprintf(fid, '%s\r\n', l4);
        fprintf(fid, '%s\r\n', l5);
        fprintf(fid, '%s\r\n', l6);
        fprintf(fid, '%s\r\n', l7);
        
        for j = 1:ii
            
            for iii = 1:well_perforations_fine
                
                if (j == ((count-1)*well_perforations_fine + iii))
                    status = 'OPEN';
                    break
                else
                    status = 'CLOSED';
                end
            end
            
            if (j == 1)
                t1 =   ['1','   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
            else
                t1 =   ['1','   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
            end
            
            fprintf(fid, '%s\r\n', t1);
        end
        t1 = '   ';
        fprintf(fid, '%s\r\n', t1);
        
    end
    
    count = 0;
    
    for ii  = well_perforations_fine:well_perforations_fine:Nz
        count = count + 1;
        
        l1 = ['*WELL ''P', int2str(count),''' *ATTACHTO ''P'''];
        l2 = ['PRODUCER ''P', int2str(count),''''];
        l5 = ['OPERATE  MIN  BHP    ',  num2str(mean(bound_press(((count-1)*well_perforations_fine+1):((count-1)*well_perforations_fine+well_perforations_fine))), '%20.12e'),'   CONT REPEAT'];
        l6 = 'GEOMETRY  K  0.00001  0.367879  1.0   0';
        l7 = ['PERF      GEOA  ''P', int2str(count),''''];
        
        fprintf(fid, '%s\r\n', l1);
        fprintf(fid, '%s\r\n', l2);
        fprintf(fid, '%s\r\n', l5);
        fprintf(fid, '%s\r\n', l6);
        fprintf(fid, '%s\r\n', l7);
        for j = 1:ii
            
            
            for iii = 1:well_perforations_fine
                
                if (j == ((count-1)*well_perforations_fine + iii))
                    status = 'OPEN';
                    break
                else
                    status = 'CLOSED';
                end
            end
            
            
            if (j == 1)
                t1 =   [int2str(Nx),'   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM', ' ''SURFACE'' REFLAYER'];
            else
                t1 =   [int2str(Nx),'   ','1', '   ',int2str(j), '   ','1','   ', status,'   ', 'FLOW-FROM','   ',int2str(j-1)];
            end
            
            fprintf(fid, '%s\r\n', t1);
        end
        t1 = '   ';
        fprintf(fid, '%s\r\n', t1);
    end
    
    
    for i = 1:Nt
        if (rem(i,skip_nt) == 0)
            fprintf(fid, '%12s\r\n', ['TIME    ', num2str(Times(qq,i), '%25.15f')]);
        end
    end
    
    
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n',' ');
    fprintf(fid, '%s\r\n','*STOP');
    fclose(fid);
    
    
    fclose('all');
    
    filename = ['IMEX_full_hetero',s_append_base{qq}];
    system([exe_path_run, ' -f ', filename, '.dat -wait ', ' &']);
    
    filename_hom = ['IMEX_full_hom_Pc',s_append_base{qq}];
    system([exe_path_run, ' -f ', filename_hom, '.dat -wait ', ' &']);
    
end


disp('Running......continue')

disp('   ')
disp('   ')
