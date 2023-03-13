
function [final_result_horz,final_result_horz_2,final_result_vertical] = A0_Main_code_upscaling(corr_lengthx,corr_lengthy,corr_lengthz,realization, IT)    %, N_Qg, Qg_tot, Reservior_bottom, Reservior_top, Lx, Ly, por_std, pore_vol_injected, dt_nd)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%add all the paths needed to run simulations and load files

addpath('./functions')
addpath('./try1')

load('Fluid_transport_properties.mat');

fid = fopen('A_input.txt','r');
eformat = '[+-]?\d+\.?\d*([eE][+-]?\d+)?';
vformat = '\d+\.?\d*';
tline=0;
while tline~=-1
    tline = fgetl(fid); 
    while isempty(tline); tline = fgetl(fid); end
    if tline==-1; break; end
    if tline(1:7)=="*Qg_tot"
        B = regexp(tline,vformat,'match');
        Qg_tot = cellfun(@str2num,B);
        N_Qg = length(Qg_tot); %Number of flow rates
    end
end
fclose(fid);
fclose('all');

for qq = 1 : N_Qg  %looping through all the flow rates
    %Generate the global fine-scale input parameters e.g. kr, fluid properties, injection rates
    disp("A1_1")
    A1_1_Generate_global_parameters       %Create the data structures
    disp("A2_1")
    A2_1_Generate_data_structure_fine     %fine scale
    disp("A2_2")
    A2_2_Generate_data_structure_upscaled %upscaled
    %Perform the MIP upscaling on the indivudual sub volumes & find parameter to use for flow simulations
    disp("A3_1")
    A3_1_Perform_MIP_upscaling
    disp("Finished MIP Upscaling!")
    %Generate flow rates and times to use for the flow simulations to work out upscaled k, kr
    A3_2_Generate_parameters
    disp('A3_2 Finished generating the geological field model! Woop!')
end
    
%end
disp('....')
disp('Finished, well done little computer!!!!')
disp('.')
disp('..')
toc

end



    %Generate fine_scale files
    %disp('A3_3 Generate fine-scale files')
    %A3_3_Generate_fine_scale_files

%     disp('A4_1 Now generate the single phase upscaling simulation files')
%     A4_1_Generate_single_phase_files
%     %Run single-phase upscaled simulations
%     disp('A4_2 run single phase upscaled simulations ')
%     A4_2_Run_single_phase_files
%     %Post-process single-phase upscaled simulations
%     disp('A4_3 post-process single phase upscaled simulations')
%     A4_3_Post_process_single_phase_files
   
    % Generate upscaled multiphase flow simulation run files
    %disp('   ')
    %disp('A5_1 Now to generate upscaled multiphase simulation run files')
    %A5_1_Generate_upscaled_files_merged
    %filename = ['Full_upscaling_workspace_pre_run.mat'];
    %save(filename)
    %A5_5_plot_upscaled_functions
    %A5_6_save_and_run
   
    %Save the upscaling workspace pre-analysis of the upscaled multiphase
    %flow runs.
    %filename = ['Full_upscaling_workspace_pre_run',s_append_base, '.mat'];
    %save(filename)

% final_result_horz(IT)= k_eff_mD_hor;
% final_result_horz_2(IT)= k_eff_mD_hor_2;
% final_result_vertical(IT) = k_eff_mD_vert;
%     
% 
% if (IT == 1)
%     fid4 = fopen('Backup_Errors.txt','w');
%     fprintf(fid4, '%.4f %.4f %.4f %.4f \r\n',[ (IT),k_eff_mD_hor, k_eff_mD_hor_2, k_eff_mD_vert]);
% else
%     fid4 = fopen('Backup_Errors.txt','a');
%     fprintf(fid4, '%.4f %.4f %.4f %.4f \r\n',[ (IT),k_eff_mD_hor, k_eff_mD_hor_2, k_eff_mD_vert]);
% end
%fclose(fid4);