%This program takes the outputs from CMG, i.e. gas saturation, Pc, PCWmax.
%These outputs from CMG must be in .txt XYZ format, for all layers. Here,
%the number of fracitonal flows refers tot he number of outputs from the
%CMG simulation. The outputs from CMG are then converted into the format
%necesary for the matlab experimental files, so that direct comparison is
%possible.

%At the end of the program, the datastrcutre is saved, so that this only
%program only needs be run once, and the dataset can be loaded into other
%routines.

tic
clc
clearvars
close all

Lz = 5;
Lx = 66;
Ly = 0.1;
ds = 0.1;

x_vec = (ds/2:ds:(Lx-ds/2));


sat = importdata('qg_01_upscaling_results.txt');

figure
plot( x_vec, sat(:, 1), 'k', 'linewidth', 1.5)
hold on
plot( x_vec, sat(:, 2), 'r', 'linewidth', 2)
plot( x_vec, sat(:, 3), 'b', 'linewidth', 2)
axis([0  66 0 0.45]) 
xlabel('Horizontal distance, $x$ [m]','interpreter','latex') 
ylabel('Avg. transverse saturation, $\bar{S}_{CO_2}$ [-]','interpreter','latex') 
L = legend('Fine scale', 'Upscaled CL',  'Upscaled VL') %, 'Upscaled VL');
set(L,'Interpreter','latex')
ytickformat('%,.2f')


