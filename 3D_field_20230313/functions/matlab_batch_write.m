clear all
close all
clc

parpool(32, 'IdleTimeout', Inf)


%{

load '2_post_fine.mat'
iii=1;
jjj=1;
kkk=2;
m_count=2;

tic

sub_append = ['_subvol_',int2str(iii),'_', int2str(jjj),'_', int2str(kkk)];


%}
disp("starting loading ")

load("post_A3_1_2D_modified.mat")
disp("finish loading ")

%%
%  count = 0;
% 
% 
% for i = 1:N_hom_subs_z
%     for j = 1:N_hom_subs_x
%         for k = 1:N_hom_subs_y
% 
%             if (subvol_struct(i,j,k).in_domain(1) == 1)
%                 count = count + 1;
% 
%                 list_plot(count,1) = (j*200); %x axis
%                 list_plot(count,2) = (i*3); %y axis
%     
%                
%             end
% 
%         end
%     end
% end
% 
% 
% scatter(list_plot(:,1), list_plot(:,2))
% set(gca, 'YDir','reverse')
% 
% figure
%%

% count = 1
% filename_vertical = strcat("cmg_run_vertical_block_", num2str(count), '.pbs')
% 
% filename_vertical_short = filename_vertical(1:end-4)        
% 
%  ['#PBS -N ', filename_vertical_short]

% 
count = 0;
for i = 1:N_hom_subs_z
    for j = 1:N_hom_subs_x
        for k = 1:N_hom_subs_y

            if (subvol_struct(i,j,k).in_domain(1) == 1)
                count = count + 1;
    
                list_coord(count,1) = i;
                list_coord(count,2) = j;
                list_coord(count,3) = k;
            end
            


        end
    end
end

%%
for i=1:count

jobname{i}= ['A4_1_Generate_single_phase_files', num2str(i),'.m'];
copyfile('A4_1_Generate_single_phase_files.m',jobname{i});

end



for i=1:count

jobname{i}= ['A4_2_Run_single_phase_files_test', num2str(i),'.m'];
copyfile('A4_2_Run_single_phase_files_test.m',jobname{i});

end






% create matlab running files for each grid block - these will set iii jjj
% kkk to be constant depending on grid block, and will call specific A4_2
% code



count = 0;

for m_iii = 1:N_hom_subs_z
    for m_jjj = 1:N_hom_subs_x
        for m_kkk= 1:N_hom_subs_y

            if (subvol_struct(m_iii, m_jjj, m_kkk).in_domain(1) == 1)

                count = count +1;
                
                filename = append("matlab_run_block_", num2str(count), ".m");
            
                fid = fopen(filename, 'w');
                
                fprintf(fid, '%s\r\n', ['load ', '''post_A3_1_2D_modified.mat''']);
            
                
                fprintf(fid, '%s\r\n', ['iii=', num2str(m_iii), ';']);
                fprintf(fid, '%s\r\n', ['jjj=', num2str(m_jjj), ';']);
               fprintf(fid, '%s\r\n', ['kkk=',num2str(m_kkk), ';' ]);
                fprintf(fid, '%s\r\n', ['m_count=',num2str(count), ';' ]);
    
               A4_1_filename = append("A4_1_Generate_single_phase_files", num2str(count));
    
               A4_2_filename = append("A4_2_Run_single_phase_files_test", num2str(count));
    
               fprintf(fid, '%s\r\n', A4_1_filename);
    
               fprintf(fid, '%s\r\n', A4_2_filename);
            
            
               fclose(fid);
            
            end

        end
    end
end

%Generate the CMG Run files, for all 3 dimensions 


count = 0;

for m_iii = 1:N_hom_subs_z
    for m_jjj = 1:N_hom_subs_x
        for m_kkk= 1:N_hom_subs_y

             if (subvol_struct(m_iii, m_jjj, m_kkk).in_domain(1) == 1)

                count = count +1;
%     
%                 sub_append = ['_subvol_',int2str(m_iii),'_', int2str(m_jjj),'_', int2str(m_kkk)];
%     
%                 filename_horizontal_short = strcat("cmg_run_horizontal_block_", num2str(count));
%                 
%                 filename_horizontal = strcat(filename_horizontal_short, '.pbs')
%     
%                 disp(filename_horizontal)
%     
%                 fid = fopen(filename_horizontal,'w')
%     
%                 fprintf(fid, '%s\n', '#!/bin/bash');
%                 fprintf(fid, '%s\n', '#PBS -l select=1:ncpus=4:mem=16gb:ompthreads=4');
%                 fprintf(fid, '%s\n', '#PBS -l walltime=04:00:00');
%     
%                 fprintf(fid, '%s\n', append('#PBS -N ', filename_horizontal_short));
%                 
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'module load cmg/2019.10');
%                 fprintf(fid, '%s\n', 'export CMG_LIC_HOST=cmg.cc.ic.ac.uk');
%                 fprintf(fid, '%s\n', 'export CMG_HOME=/apps/cmg/2019.101');
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'cd $HOME/2D_UPSCALING_FINAL');
% 
%                 fprintf(fid, '%s\n', 'mkdir /dev/shm/${PBS_JOBID}/');
%                 fprintf(fid, '%s\n', 'export TMPDIR=/dev/shm/${PBS_JOBID}/');
% 
%                 fprintf(fid, '%s\n', '# Runsim.sh imex [version] [input_file]');
%                 fprintf(fid, '%s\n', 'date');
%                 fprintf(fid, '%s\n', ['RunSim.sh imex 2019.10 ./', 'IMEX_upscaling_horizontal',s_append_base{1},sub_append, '.dat']);
% 
%                 fprintf(fid, '%s\n', 'rm -fr  /dev/shm/${PBS_JOBID}/');
% 
%                 fprintf(fid, '%s\n', 'date');
%     
%                 fclose(fid);
%                 fclose('all');
%     
%                 filename_horizontal_2_short = strcat("cmg_run_horizontal_2_block_", num2str(count));
%                 filename_horizontal_2 = strcat(filename_horizontal_2_short, '.pbs')
%     
%                 fid = fopen(filename_horizontal_2,'w');
%     
%                 fprintf(fid, '%s\n', '#!/bin/bash');
%                 fprintf(fid, '%s\n', '#PBS -l select=1:ncpus=4:mem=16gb:ompthreads=4');
%                 fprintf(fid, '%s\n', '#PBS -l walltime=04:00:00');
%     
%                 fprintf(fid, '%s\n', append('#PBS -N ', filename_horizontal_2_short));
%                 
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'module load cmg/2019.10');
%                 fprintf(fid, '%s\n', 'export CMG_LIC_HOST=cmg.cc.ic.ac.uk');
%                 fprintf(fid, '%s\n', 'export CMG_HOME=/apps/cmg/2019.101');
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'cd $HOME/2D_UPSCALING_FINAL');
% 
%                 fprintf(fid, '%s\n', 'mkdir /dev/shm/${PBS_JOBID}/');
%                 fprintf(fid, '%s\n', 'export TMPDIR=/dev/shm/${PBS_JOBID}/');
% 
%                 fprintf(fid, '%s\n', '# Runsim.sh imex [version] [input_file]');
%                 fprintf(fid, '%s\n', 'date');
%                 fprintf(fid, '%s\n', ['RunSim.sh imex 2019.10 ./', 'IMEX_upscaling_horizontal_2',s_append_base{1},sub_append, '.dat']);
% 
%                 fprintf(fid, '%s\n', 'rm -fr  /dev/shm/${PBS_JOBID}/');
% 
% 
%                 fprintf(fid, '%s\n', 'date');
%     
%                 fclose(fid);
%                 fclose('all');
%     
%                 filename_vertical_short = strcat("cmg_run_vertical_block_", num2str(count));
%     
%                 filename_vertical = strcat(filename_vertical_short, '.pbs');
%     
%                 fid = fopen(filename_vertical,'w');
%     
%                 fprintf(fid, '%s\n', '#!/bin/bash');
%                 fprintf(fid, '%s\n', '#PBS -l select=1:ncpus=4:mem=16gb:ompthreads=4');
%                 fprintf(fid, '%s\n', '#PBS -l walltime=04:00:00');
%     
%                 fprintf(fid, '%s\n', append('#PBS -N ', filename_vertical_short));
%                 
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'module load cmg/2019.10');
%                 fprintf(fid, '%s\n', 'export CMG_LIC_HOST=cmg.cc.ic.ac.uk');
%                 fprintf(fid, '%s\n', 'export CMG_HOME=/apps/cmg/2019.101');
%                 fprintf(fid, '\n');
%                 fprintf(fid, '%s\n', 'cd $HOME/2D_UPSCALING_FINAL');
% 
%                 fprintf(fid, '%s\n', 'mkdir /dev/shm/${PBS_JOBID}/');
%                 fprintf(fid, '%s\n', 'export TMPDIR=/dev/shm/${PBS_JOBID}/');
% 
% 
%                 fprintf(fid, '%s\n', '# Runsim.sh imex [version] [input_file]');
%                 fprintf(fid, '%s\n', 'date');
%                 fprintf(fid, '%s\n', ['RunSim.sh imex 2019.10 ./', 'IMEX_upscaling_vertical',s_append_base{1},sub_append, '.dat']);
% 
%                 fprintf(fid, '%s\n', 'rm -fr  /dev/shm/${PBS_JOBID}/');
% 
%                 fprintf(fid, '%s\n', 'date');
%     
%                 fclose(fid);
%                 fclose('all');
%     
% %                 system(sprintf(strcat('dos2unix ', filename_horizontal)))
% %                 system(sprintf(strcat('dos2unix ', filename_horizontal_2)))
% %                 system(sprintf(strcat('dos2unix ', filename_vertical)))

             end




        end
    end
end


%%
% 
grid_block_no = count;
run_no = 2490;

array_no = ceil(grid_block_no/run_no);

%create a .txt file to store the filenames for when we write our array pbs file 
countm = 0;
for i = 1:array_no

    if (i == array_no)
        i_final = grid_block_no - ((array_no -1 )*run_no);
    else
        i_final = run_no;
    end

    filename = strcat('filename_', num2str(i), '.txt');
    fid = fopen(filename, 'w');

    for ii = 1:i_final
        countm = countm +1;
        fprintf(fid, '%s\n', ['matlab_run_block_', num2str(countm)]);

        
    end

    fclose(fid);
end



for i = 1:array_no

%     if (i == 1)
%         i_start = i;
%     else
%         i_start = (i*run_no)+1;
%     end

    if (i == array_no)
        i_final = grid_block_no - ((array_no -1 )*run_no);
    else
        i_final = run_no;
    end

        input_file_list = strcat('filename_', num2str(i), '.txt');

        filename_short = strcat("block_batch_", num2str(i));

        filename = strcat("block_batch_", num2str(i), '.pbs');

        fid = fopen(filename,'w');

        fprintf(fid, '%s\n', '#!/bin/bash');
        fprintf(fid, '%s\n', '#PBS -l select=1:ncpus=1:mem=32gb:ompthreads=1');
        fprintf(fid, '%s\n', '#PBS -l walltime=12:00:00');


        fprintf(fid, '%s\n', append('#PBS -N ', filename_short));
        fprintf(fid, '%s\n', ['#PBS -J 1-',num2str(i_final)]);

     %   my_program $(sed -n "${PBS_ARRAY_INDEX}p" input_file_list)


        fprintf(fid, '\n');
        fprintf(fid, '\n');
        fprintf(fid, '%s\n', 'module load matlab/R2020a');
        fprintf(fid, '\n');
        fprintf(fid, '\n');
        fprintf(fid, '%s\n', 'cd $HOME/2D_UPSCALING_FINAL');

        fprintf(fid, '%s\n', 'date');

        fprintf(fid, '%s\n', 'mkdir /dev/shm/${PBS_JOBID}/');
        fprintf(fid, '%s\n', 'export TMPDIR=/dev/shm/${PBS_JOBID}/');

        
        fprintf(fid, '%s\n', ['matlab -batch $(sed -n "${PBS_ARRAY_INDEX}p" ',input_file_list,')']);

        %fprintf(fid, '%s\n', ['matlab -batch ', "matlab_run_block_",'${PBS_ARRAY_INDEX}']);
        fprintf(fid, '\n');
        
        fprintf(fid, '%s\n', 'rm -fr  /dev/shm/${PBS_JOBID}/');

        fprintf(fid, '%s\n', 'date');


        fclose(fid);
        fclose('all');

        
       % system(sprintf(strcat('dos2unix ', filename)))
    
    
    
end







