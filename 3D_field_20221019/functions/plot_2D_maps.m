tic

clc
clear all
close all

set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', 14)
 set(0,'DefaultFigurePosition', [680   300   800  600])
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', 14)


tic
clc
clearvars
close all


Rx = 50;
Ry = 50;

run = 3;

s_append = ['rx',int2str(Rx),'_ry',int2str(Ry), '_r', int2str(run)];
s_append2 = ['rx',int2str(Rx),'_ry',int2str(Ry)];
Matlab_title = 'CMG_simulation_data_Drain_horizontal_q_1_kr_iso_Pe_';
Matlab_title = [Matlab_title,s_append2,'_no_pe_het', '.mat'];
load(Matlab_title)

figure
pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,50))
shading interp
set(gca,'Ydir','reverse')
axis equal
axis([0 66 2984 2989])
%colorbar
colormap jet
axis off
%set(gcf,'color','w');
caxis([ 0 0.6])
export_fig sat1.png
figure
pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,100))
shading interp
set(gca,'Ydir','reverse')
axis equal
axis([0 66 2984 2989])
%colorbar
colormap jet
axis off
%set(gcf,'color','w');
caxis([ 0 0.6])
export_fig sat2.png


figure
pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,200))
shading interp
set(gca,'Ydir','reverse')
axis equal
axis([0 66 2984 2989])
% h = colorbar;
% set(get(h,'title'),'string','$S_{CO_2}$ [-]', 'Interpreter', 'latex', 'fontsize', 16);
%colorbar
colormap jet
axis off
%set(gcf,'color','w');
caxis([ 0 0.6])
export_fig sat3.png
figure
pcolor(data_struct.xMat, data_struct.zMat, data_struct.peMat(:,:,1))
shading interp
set(gca,'Ydir','reverse')
axis equal

axis([0 66 2984 2989])
% = colorbar;
%set(get(h,'title'),'string','$P_e$ [kPa]', 'Interpreter', 'latex');
axis off
set(gcf,'color','w');
%colorbar
axis off
%saveas(gcf, 'test.png');
export_fig pe_colorbar.png

%set(gcf,'color','w');

figure
pcolor(data_struct.xMat, data_struct.zMat, log(data_struct.permMat(:,:,1)))
shading interp
set(gca,'Ydir','reverse')
axis equal
axis([0 66 2984 2989])
%colorbar
axis off
%set(gcf,'color','w');
%caxis([ 0 0.6])
export_fig perm.png

figure
pcolor(data_struct.xMat, data_struct.zMat, log(data_struct.permMat(:,:,1)))
shading interp
set(gca,'Ydir','reverse')
axis equal
axis([0 66 2980 2993])
h = colorbar;
set(get(h,'title'),'string','Ln$(K_a)$ [mD]', 'Interpreter', 'latex');
axis off
set(gcf,'color','w');
%caxis([ 0 0.6])
export_fig perm_colorbar.png
%pressure_title = ['press_1PV_', s_append, '.inc'];
%saturation_title = ['sat_1PV_', s_append, '.inc'];

results_file = [s0, s_append, '.txt'];



%imex_drain_horizontal_q_0_001_kr_iso_pe_rx0_ry0 Oil Saturation

Reservior_bottom = 2989;
Reservior_top = 2984;

Lz = Reservior_bottom - Reservior_top;
Lx = 66;
Ly = 0.1;
ds = 0.1;

Nx = round(Lx/ds);
Ny = round(Ly/ds);
Nz = round(Lz/ds);
Ntot = Nx*Ny*Nz;

%Geometry vectors, cell centred akin to CMG IMEX.
z_vec = ((Reservior_top + ds/2):ds:(Reservior_bottom-ds/2))';
x_vec = (ds/2:ds:(Lx-ds/2));

nt= 1000;
dt = 0.001;
dv = ds.^3;


lambda = 0.444;
pe = 6.9968; % kPa
swirr = 0.0;
pc_end = 5958.64069020211; %(kpa)
k_abs = 154.8;
jsw1 = 0.131;
surface_tension = 32.9;
cl = 1.4;
rho_w= 1025.0;
por_av = 0.2922574;
por_std = 0.018544005;


Qg = 0.001;
bound_press = 9.81*rho_w*(Reservior_top+Reservior_bottom)/2;


pore_volume = (Lz-2)*(Lx*ds)*Ly*por_av;

del_s = 1-swirr;
t_mult = Qg/(pore_volume*del_s);

dt_nd = 0.001;
non_dim_times = dt_nd:dt_nd:1;

Times = non_dim_times/t_mult;

satAv_trans = zeros(Nx, nt);

p_drop_av = zeros(nt,1);
front_pos_dt = zeros(nt,1);
front_vel_dt = zeros(nt,1);
tol = 1e-5;




count = 0;
for k = 1:nt
for i = Nx-1:-1:2
    
    satAv_trans(i,k) = mean(data_struct.satMat(:,i,k), 'omitnan');

    %satAv_trans(i,k) = nanmean(data_struct.satMat(:,i,k));
end

for i = 2:Nx
    if (satAv_trans(i,k) < tol)
        front_pos_dt(k) = i*ds;
        break
    end

end


%p_drop_av(k) = nanmean(data_struct.pressMat(:,1,k)) - nanmean(data_struct.pressMat(:,Nx,k));

if (i == (Nx))
    front_pos_dt(k) = i*ds;
    count = count + 1;
    if (count == 1)
        breakthrough_time = k/nt;
        breakthrough_k = k;
    end
end

end

for k = 2:nt-1
    front_vel_dt(k) = ((front_pos_dt(k+1) - front_pos_dt(k-1))/Lx)/(2*dt_nd);
end

sat_av_1pv = 0;
porvol_av_1pv = 0;
sweep_av_1pv = 0;
query = nt;
tol2 = 1e-15;
count = 0;
sat_vec = zeros((Nz-2)*Nx, 1);
pe_vec = zeros((Nz-2)*Nx, 1);
for i = 1:Nz
    for j = 2:Nx-1
        count = count + 1;
        
        sat_vec(count,1) = data_struct.satMat(i,j,query);
        pe_vec(count,1) = data_struct.peMat(i,j,1);
        
        if (data_struct.satMat(i,j,query) > tol2)
            sweep_av_1pv = sweep_av_1pv + data_struct.porMat(i,j,1)*dv;
        end
        
        sat_av_1pv = sat_av_1pv + data_struct.satMat(i,j,query)*data_struct.porMat(i,j,1)*dv;
        porvol_av_1pv = porvol_av_1pv + data_struct.porMat(i,j,1)*dv;
    end
end

% figure
% histogram(pe_vec)

std_pe = std(pe_vec);

%Nc = (p_drop_av(end)/Lx)*(ds/std_pe);


sat_av_1pv = sat_av_1pv/porvol_av_1pv;
sweep_av_1pv = sweep_av_1pv/porvol_av_1pv;
eta_sat = std(sat_vec)/sat_av_1pv;
eta_pe = std(pe_vec)/mean(pe_vec);


% figure
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.peMat)
% shading interp
% set(gca,'Ydir','reverse')
% axis equal
% colorbar

% figure
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,50))
% shading interp
% set(gca,'Ydir','reverse')
% axis equal
% colorbar
% colormap jet
% caxis([ 0 0.4])


% v = VideoWriter('drainage_001_new.avi');
% v.FrameRate = 15;
% open(v);
% 
% for k = 1:breakthrough_k
%     
% figure
% h1 = subplot(1,2,1)
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,k))
% shading interp
% set(gca,'Ydir','reverse')
% axis([0 5 2984 3050])
% axis off
% pbaspect([1 13.2 1])
% c = colorbar('Position',...
%     [0.133920454446117 0.433323323323316 0.0310795455538849 0.154264264264272]);
% 
% xlabel(c,'\itS_{\rmCO_2} \rm[-]', 'fontsize',14)
% %hL = zlabel(c,'\itS_{\rmCO_2} \rm[-]', 'fontsize',14); 
% %set(hL,'Rotation',0);
% colormap jet
% caxis([ 0 0.4])
% 
% set(h1, 'Units', 'normalized');
% set(h1, 'Position', [0.2, 0, 0.1, 1]);
% 
% h2=    subplot(1,2,2)
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.peMat(:,:,1))
% shading interp
% set(gca,'Ydir','reverse')
% axis([0 5 2984 3050])
% axis off
% pbaspect([1 13.2 1])
% d = colorbar('Position',...
%       [0.526420454446119 0.433323323323316 0.0310795455538849 0.154264264264272]);
% hL = ylabel(d,'\itP_e \rm[kPa]', 'fontsize',14); 
% 
% set(h2, 'Units', 'normalized');
% set(h2, 'Position', [0.4, 0, 0.1, 1]);
% 
% 
% %colorbar
% %colormap jet
% %caxis([ 0 0.4])
% 
% frame = getframe(gcf);
%    writeVideo(v,frame);
%    
%    close
% end
% 
% close(v);

% figure
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,100))
% shading interp
% set(gca,'Ydir','reverse')
% axis equal
% colorbar
% colormap jet
% caxis([ 0 0.3])

% figure
% pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,150))
% shading interp
% set(gca,'Ydir','reverse')
% axis equal
% colorbar
% colormap jet
% caxis([ 0 0.3])

figure
pcolor(data_struct.xMat, data_struct.zMat, data_struct.satMat(:,:,breakthrough_k))
shading interp
set(gca,'Ydir','reverse')
axis equal
colorbar
colormap jet
caxis([ 0 0.3])

figure
%plot(x_vec, satAv_trans(:,1),'k-')
hold on
plot(x_vec(2:end-1)/Lx, satAv_trans((2:end-1), 50),'r--')
plot(x_vec(2:end-1)/Lx, satAv_trans((2:end-1), 100),'g--')
plot(x_vec(2:end-1)/Lx, satAv_trans((2:end-1), 150),'b-.')
plot(x_vec(2:end-1)/Lx, satAv_trans((2:end-1), 300),'k-', 'linewidth', 2)


xlabel('Distance from inlet, x/L_x [-]')
ylabel('Transverse average CO_2 saturation [-]')
legend('t = 0.05', 't = 0.1', 't = 0.25', 't = 0.3')

% figure
% plot(non_dim_times, front_pos_dt, 'k')
% figure
% plot(non_dim_times, front_vel_dt, 'k')
%     

fileID = fopen(results_file,'wt');
fprintf(fileID,'%25.25f\r\n',breakthrough_time);
fprintf(fileID,'%25.25f\r\n',eta_pe);
fprintf(fileID,'%25.25f\r\n',eta_sat);
fprintf(fileID,'%25.25f\r\n',sat_av_1pv);
fprintf(fileID,'%25.25f\r\n',sweep_av_1pv);

sol(1,1) = Rx;
sol(2,1) = Ry;
sol(3,1) = breakthrough_time;
sol(4,1) = eta_pe;
sol(5,1) = eta_sat;
sol(6,1) = sat_av_1pv;
sol(7,1) = sweep_av_1pv;

% fileID = fopen(saturation_title,'w');
% for i = 1:Nz
%         for j = 1:Nx
%             
%             col = Nz - i+1;
%             row = j;
%             
%             fprintf(fileID,'%u %u %u %1s %12.8f\r\n',row,1, col,'=', data_struct.satMat(i,j, query));
%         end
% end
% fclose(fileID);
% 
% fileID = fopen(pressure_title,'w');
% for i = 1:Nz
%         for j = 1:Nx
%            col = Nz - i+1;
%             row = j;
%             
%             fprintf(fileID,'%u %u %u %1s %12.8f\r\n',row,1, col,'=', data_struct.pressMat(i,j, query));
%         end
% end


toc
