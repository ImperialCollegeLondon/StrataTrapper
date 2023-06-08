
clc
clear
close all 

%The functions shoule not be changed
addpath('./Functions')
%The setting for simuation should be changed
addpath('./Input')
% load the fluid properties
load('Fluid_transport_properties.mat');

% if you would like save data in each step, set as 1
Step_save = 0;

% start runing bbbbbbbb
A1_1_Generate_global_parameters
A2_1_Generate_data_structure_fine
A2_2_Generate_shift_structure_fine
A2_3_Generate_data_structure_upscaled
A3_1_Perform_MIP_upscaling
A4_1_Generate_relative_permeability
A5_1_Generate_upscaled_files


