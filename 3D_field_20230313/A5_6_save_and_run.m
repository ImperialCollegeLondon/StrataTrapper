
Matlab_workspace_title_coarsened = ['Matlab_workspace',s_append_base,'.mat'];
save(Matlab_workspace_title_coarsened, '-v7.3');
save(Matlab_subvol_struct, 'subvol_struct', '-v7.3');
save(Matlab_datastruct, 'data_struct', '-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Starting eclipse simulations!')
%Now run the upscaled simulations!
for qq = 1:N_Qg
    
    filename_CL = ['ECLIPSE_CL_upscaling', s_append_base{qq}, '.data'];
    filename_VL = ['ECLIPSE_VL_upscaling', s_append_base{qq}, '.data'];
    filename_VL_no_PC = ['ECLIPSE_VL_PC0_upscaling', s_append_base{qq}, '.data'];
    
    [status1, cmdout1] = system(['eclrun.exe --queue=high eclipse ', filename_CL, ' &']);
    [status2, cmdout2] = system(['eclrun.exe --queue=high eclipse ', filename_VL,  ' &']);
    [status3, cmdout3] = system(['eclrun.exe --queue=high eclipse ', filename_VL_no_PC, ' &']);
    
    pause(60)
    %Pause between runs so we dont overload the PC!
end
