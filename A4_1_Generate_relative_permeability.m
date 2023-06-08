%% Now we generate and run the fine-scale simulations. --------------------
% This is essentially the same as the fine scale code, so will not be commented here. 


warning('off')
for m = 1:1
% disp(m)
% clc
% clearvars -except m
% close all
plotfit = 0;

if Step_save
    load("./Output/post_A3_1")
    %load(['./Output/post_A3_1_3D_',num2str(m)]);
end
%[kg_fine_VL, kw_fine_VL] = LET_function(sw_aim, swirr, kwsirr, kgsgi, L_w, E_w, T_w, L_g, E_g, T_g);
%kw_fine_VL(1) = 0;
%kg_fine_VL(end) = 0;

tic
%for iii = 1:N_hom_subs_z
mm = N_hom_subs_z; %min(m*20, N_hom_subs_z);
for iii = 1:mm
    disp(['iii = ', num2str(iii)])
    for jjj = 1:N_hom_subs_x
        for kkk = 1:N_hom_subs_y
            subvol_struct2(iii,jjj,kkk).in_domain = subvol_struct(iii,jjj,kkk).in_domain;
            if (subvol_struct(iii,jjj,kkk).in_domain(1) ~= 1)
                continue;
            end
            sw = subvol_struct(iii,jjj,kkk).sw_upscaled;
            Kai00 = subvol_struct(iii,jjj,kkk).permMat(1:Nz_sub,1:Nx_sub,1:Ny_sub);
            Estimate = Calculate_Kabs(Kai00,ds_x,ds_y,ds_z, 1, 1, 1);
            Kh1 = Estimate(1); Kh2 = Estimate(2); Kv1 = Estimate(3);
            subvol_struct2(iii,jjj,kkk).k_eff_mD_hor = Kh1;
            subvol_struct2(iii,jjj,kkk).k_eff_mD_hor_2 = Kh2;
            subvol_struct2(iii,jjj,kkk).k_eff_mD_vert = Kv1;
            %m = length(find(sw==1));
            %sw(end-m+1:end) = [];
            Kalli = zeros(n_pts,6); %-m
            %horizontal
            for j = 1:n_pts %-m
                h1g = (subvol_struct(iii,jjj,kkk).kg_phase_connected(j,3) > 0);
                h1w = (subvol_struct(iii,jjj,kkk).kw_phase_connected(j,3) > 0);
                h2g = (subvol_struct(iii,jjj,kkk).kg_phase_connected(j,2) > 0);
                h2w = (subvol_struct(iii,jjj,kkk).kw_phase_connected(j,2) > 0);
                v1g = (subvol_struct(iii,jjj,kkk).kg_phase_connected(j,1) > 0);
                v1w = (subvol_struct(iii,jjj,kkk).kw_phase_connected(j,1) > 0);
                if h1g || h2g || v1g
                   Kai0 = subvol_struct(iii,jjj,kkk).kg_mat(1:Nz_sub,1:Nx_sub,1:Ny_sub,j);
                   Estimate = Calculate_Kabs(Kai0,ds_x,ds_y,ds_z, h1g, h2g, v1g);
                   Kalli(j,1) = Estimate(1); Kalli(j,2) = Estimate(2); Kalli(j,3) = Estimate(3);
                   %Kalli(j,1:3) = [Kgh1,Kgh2,Kgv1];
                end
                if h1w || h2w || v1w
                   Kai0 = subvol_struct(iii,jjj,kkk).kw_mat(1:Nz_sub,1:Nx_sub,1:Ny_sub,j);
                   Estimate = Calculate_Kabs(Kai0,ds_x,ds_y,ds_z, h1w, h2w, v1w);
                   Kalli(j,4) = Estimate(1); Kalli(j,5) = Estimate(2); Kalli(j,6) = Estimate(3);
                end
            end
            Kalli(:,[1,4]) = Kalli(:,[1,4]) / Kh1;
            Kalli(:,[2,5]) = Kalli(:,[2,5]) / Kh2;
            Kalli(:,[3,6]) = Kalli(:,[3,6]) / Kv1;

            ind1 = find(sw<1 & sw>swirr);        %find(Kalli(:,1) > 1e-6);
            %ind2 = find(sw>swirr);    %find(Kalli(:,4) > 1e-6);
            Kalli(Kalli==0) = 1e-6;
            estimates = LET_optimiser(sw(ind1),sw(ind1),Kalli(ind1,1),Kalli(ind1,4),kwsirr,kgsgi,min(sw),L_w,E_w,T_w,L_g,E_g,T_g);
            subvol_struct2(iii,jjj,kkk).LET_wg_h1 = estimates;
            %[fitg1,fitw1]=LET_function(sw,swirr,kwsirr,kgsgi,estimates(1),estimates(2),estimates(3),estimates(4),estimates(5),estimates(6));
            [fitg1,fitw1]=LET_function(sw,swirr,kwsirr,kgsgi,estimates);
            fitg1 = sort(fitg1,'descend'); fitw1 = sort(fitw1,'ascend');
            fitg1(fitg1>1) = 1; fitg1(fitg1<0) = 0;
            fitw1(fitw1>1) = 1; fitw1(fitw1<0) = 0;
            subvol_struct2(iii,jjj,kkk).krg_optim_hor = fitg1;
            subvol_struct2(iii,jjj,kkk).krw_optim_hor = fitw1;
            estimates = LET_optimiser(sw(ind1),sw(ind1),Kalli(ind1,2),Kalli(ind1,5),kwsirr,kgsgi,min(sw),L_w,E_w,T_w,L_g,E_g,T_g);
            subvol_struct2(iii,jjj,kkk).LET_wg_h2 = estimates;
            [fitg2,fitw2]=LET_function(sw,swirr,kwsirr,kgsgi,estimates);
            fitg2 = sort(fitg2,'descend'); fitw2 = sort(fitw2,'ascend');
            fitg2(fitg2>1) = 1; fitg2(fitg2<0) = 0;
            fitw2(fitw2>1) = 1; fitw2(fitw2<0) = 0;
            subvol_struct2(iii,jjj,kkk).krg_optim_hor_2 = fitg2;
            subvol_struct2(iii,jjj,kkk).krw_optim_hor_2 = fitw2;
            estimates = LET_optimiser(sw(ind1),sw(ind1),Kalli(ind1,3),Kalli(ind1,6),kwsirr,kgsgi,min(sw),L_w,E_w,T_w,L_g,E_g,T_g);
            subvol_struct2(iii,jjj,kkk).LET_wg_v1 = estimates;
            [fitg3,fitw3]=LET_function(sw,swirr,kwsirr,kgsgi,estimates);
            fitg3 = sort(fitg3,'descend'); fitw3 = sort(fitw3,'ascend');
            fitg3(fitg3>1) = 1; fitg3(fitg3<0) = 0;
            fitw3(fitw3>1) = 1; fitw3(fitw3<0) = 0;
            subvol_struct2(iii,jjj,kkk).krg_optim_vert = fitg3;
            subvol_struct2(iii,jjj,kkk).krw_optim_vert = fitw3;
            if plotfit
                figure
                hold on
                plot(sw,Kalli(:,1),'ro')
                plot(sw,Kalli(:,2),'k+')
                plot(sw,Kalli(:,3),'bx')
                plot(sw,Kalli(:,4),'ro')
                plot(sw,Kalli(:,5),'k+')
                plot(sw,Kalli(:,6),'bx')
                plot(sw,fitg1,'r-.')
                plot(sw,fitg2,'k')
                plot(sw,fitg3,'b--')
                plot(sw,fitw1,'r-.')
                plot(sw,fitw2,'k')
                plot(sw,fitw3,'b--')
                hold off
            end
            subvol_struct2(iii,jjj,kkk).sw_upscaled = sw(ind1);
            subvol_struct2(iii,jjj,kkk).por_upscaled = subvol_struct(iii,jjj,kkk).por_upscaled;
            subvol_struct2(iii,jjj,kkk).pc_upscaled = subvol_struct(iii,jjj,kkk).pc_upscaled(ind1);
        end
    end
end

% clearvars subvol_struct data_struct sat_initial_mat pressure_initial_mat x_grid y_grid z_grid

subvol_struct = subvol_struct2;
clearvars subvol_struct2
if Step_save
    %save(['./Output/post_A4_1_3D_',num2str(m),'.mat'],'-v7.3');
    save("./Output/post_A4_1", '-v7.3')
end

disp('Fininished generating upscaling files')
%disp(' ')
toc 
end

function [Estimate] = Calculate_Kabs(Kai0,Lx,Ly,Lz,h1,h2,v1)
format long
Kh1 = 0;
Kh2 = 0;
Kv1 = 0;
% Lx = 1;
% Ly = 1; 
% Lz = 1; 
% Kai0 = ones(5,5,5);

% effective simulation domain, along y direction
[x0,y0,z0] = size(Kai0);
Q = 1 * 10^-6 / 60;      %(ml/min)->m3/s
Muw = 1 * 10^-3;         %cp-PaS
Pout = 1.0;

x=x0+2; %for layer
y=y0+2; %for layer
z=z0+2;

Kai = zeros(x,y,z);
Kai(2:end-1,2:end-1,2:end-1) = Kai0;
%no value for first and endlayer

Condx = Kai(:) .* (Ly*Lz) ./ Muw ./Lx;
Condy = Kai(:) .* (Lx*Lz) ./ Muw ./Ly;
Condz = Kai(:) .* (Lx*Ly) ./ Muw ./Lz;

Loc=zeros(x,y,z);
Ind = sub2ind(size(Loc),find(Condz>0));
Loc(Ind) = (1:length(Ind));
n = length(Ind) + 1; %+1 for constant Q 

Dim = find(Loc>0);
Dim1 = Dim - 1;
Dim2 = Dim + 1;
Dim3 = Dim - x;
Dim4 = Dim + x;
Dim5 = Dim - x*y;
Dim6 = Dim + x*y;
%Loc(Dim) already > 0
A0 = zeros(length(Dim)+1,3);
A0(:,1) = [Loc(Dim);n];
A0(:,2) = [Loc(Dim);n];
ind = find(Loc(Dim1)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condx(Dim(ind))+1./Condx(Dim1(ind)));
A1 = [Loc(Dim(ind)),Loc(Dim1(ind)), -2./(1./Condx(Dim(ind))+1./Condx(Dim1(ind)))];
ind = find(Loc(Dim2)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condx(Dim(ind))+1./Condx(Dim2(ind)));
A2 = [Loc(Dim(ind)),Loc(Dim2(ind)), -2./(1./Condx(Dim(ind))+1./Condx(Dim2(ind)))];
ind = find(Loc(Dim3)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condy(Dim(ind))+1./Condy(Dim3(ind)));
A3 = [Loc(Dim(ind)),Loc(Dim3(ind)), -2./(1./Condy(Dim(ind))+1./Condy(Dim3(ind)))];
ind = find(Loc(Dim4)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condy(Dim(ind))+1./Condy(Dim4(ind)));
A4 = [Loc(Dim(ind)),Loc(Dim4(ind)), -2./(1./Condy(Dim(ind))+1./Condy(Dim4(ind)))];
ind = find(Loc(Dim5)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condz(Dim(ind))+1./Condz(Dim5(ind)));
A5 = [Loc(Dim(ind)),Loc(Dim5(ind)), -2./(1./Condz(Dim(ind))+1./Condz(Dim5(ind)))];
ind = find(Loc(Dim6)>0);
A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2./(1./Condz(Dim(ind))+1./Condz(Dim6(ind)));
A6 = [Loc(Dim(ind)),Loc(Dim6(ind)), -2./(1./Condz(Dim(ind))+1./Condz(Dim6(ind)))];
A0b = A0;
X0 = ones(n,1);
%boundary y direction
if h1
    ind = find(Loc(Dim3)<=0);
    A0(n,3) = A0(n,3) + 2.0.*sum(Condy(Dim(ind)));
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condy(Dim(ind));
    Ain = [[Loc(Dim(ind));ind*0+n],[ind*0+n;Loc(Dim(ind))],[-2.0.*Condy(Dim(ind));-2.0.*Condy(Dim(ind))]];
    ind = find(Loc(Dim4)<=0);
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condy(Dim(ind));
    Aall=[A0;A1;A2;A3;A4;A5;A6;Ain];
    A = sparse(Aall(:,1),Aall(:,2),Aall(:,3),n,n);
    B = zeros(n,1);
    B(Loc(Dim(ind))) = Pout * 2.0.*Condy(Dim(ind));
    B(end) = Q * 10^12; %due to D
    [L,U] = ilu(A);
    [X1,flag]=bicgstab(A,B,1e-10,3000,L,U,X0);
    if flag; X1=mldivide(A,B); end
    Pin = X1(end);
    Ae = x0*z0*Lx*Lz;          %m2
    Le = (y0+0)*Ly;            %m,+0 considering bouyndary is half, +1 for one
    Kh1 = Q/((Pin-Pout)*Ae/Le/Muw) * 10^12; %Darcy
end
if h2
    A0 = A0b;
    ind = find(Loc(Dim5)<=0);
    A0(n,3) = A0(n,3) + 2.0.*sum(Condz(Dim(ind)));
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condz(Dim(ind));
    Ain = [[Loc(Dim(ind));ind*0+n],[ind*0+n;Loc(Dim(ind))],[-2.0.*Condz(Dim(ind));-2.0.*Condz(Dim(ind))]];
    ind = find(Loc(Dim6)<=0);
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condz(Dim(ind));
    Aall=[A0;A1;A2;A3;A4;A5;A6;Ain];
    A = sparse(Aall(:,1),Aall(:,2),Aall(:,3),n,n);
    B = zeros(n,1);
    B(Loc(Dim(ind))) = Pout * 2.0.*Condz(Dim(ind));
    B(end) = Q * 10^12; %due to D
    [L,U] = ilu(A);
    [X1,flag]=bicgstab(A,B,1e-10,3000,L,U,X0);
    if flag; X1=mldivide(A,B); end
    Pin = X1(end);
    Ae = x0*y0*Lx*Ly;          %m2
    Le = (z0+0)*Lz;            %m
    Kh2 = Q/((Pin-Pout)*Ae/Le/Muw) * 10^12; %Darcy
end
if v1
    A0 = A0b;
    ind = find(Loc(Dim1)<=0);
    A0(n,3) = A0(n,3) + 2.0.*sum(Condx(Dim(ind)));
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condx(Dim(ind));
    Ain = [[Loc(Dim(ind));ind*0+n],[ind*0+n;Loc(Dim(ind))],[-2.0.*Condx(Dim(ind));-2.0.*Condx(Dim(ind))]];
    ind = find(Loc(Dim2)<=0);
    A0(Loc(Dim(ind)),3) = A0(Loc(Dim(ind)),3) + 2.0.*Condx(Dim(ind));
    Aall=[A0;A1;A2;A3;A4;A5;A6;Ain];
    A = sparse(Aall(:,1),Aall(:,2),Aall(:,3),n,n);
    B = zeros(n,1);
    B(Loc(Dim(ind))) = Pout * 2.0.*Condx(Dim(ind));
    B(end) = Q * 10^12; %due to D
    [L,U] = ilu(A);
    [X1,flag]=bicgstab(A,B,1e-10,3000,L,U,X0);
    if flag; X1=mldivide(A,B); end
    Pin = X1(end);
    Ae = y0*z0*Ly*Lz;          %m2
    Le = (x0+0)*Lx;            %m
    Kv1 = Q/((Pin-Pout)*Ae/Le/Muw) * 10^12; %Darcy
end

Estimate = [Kh1,Kh2,Kv1];

end
