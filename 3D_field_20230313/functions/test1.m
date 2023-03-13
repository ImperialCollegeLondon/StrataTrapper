clear all
close all
clc

% exe_path_run = '"C:\Program Files (x86)\CMG\IMEX\2019.10\Win_x64\EXE\mx201910.exe"'
% 
% exe_path_run = mx201910.exe
% [status, cmdout] = system([exe_path_run, ' -f IMEX_upscaling_horizontal_2Qg_20_rx_50_ry_38_rz_2_rlsn_1_subvol_9_17_1.dat -wait - parasol -4 -doms'])  %, ' &'


[status, cmdout] = system(['/apps/cmg/2019.101/bin/mx201910.exe -f IMEX_upscaling_horizontal_2Qg_20_rx_50_ry_38_rz_2_rlsn_1_subvol_9_17_1.dat -wait - parasol -1 -doms'])  %, ' &'

