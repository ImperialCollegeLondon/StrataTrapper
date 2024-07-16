function [Kabs, sw_upscaled, pc_upscaled, krw, krg] = upscale(...
    dr, saturations, params, options, ...
    downscale_dims, porosities, permeabilities, entry_pressures)

if max(porosities,[],'all') <= 0
    error('inactive cell');
end

dr_sub = dr ./ downscale_dims;

Kabs = Calculate_Kabs(permeabilities, dr_sub(1),dr_sub(2),dr_sub(3), 1, 1, 1);

sw_upscaled = saturations;
pc_upscaled = zeros(size(saturations));

Nz_sub = downscale_dims(3);
Nx_sub = downscale_dims(1);
Ny_sub = downscale_dims(2);

krg = zeros(3,length(sw_upscaled));
krw = zeros(3,length(sw_upscaled));

tol_kr = options.perm_min_threshold;

for index_saturation = 1:length(saturations)
    
    sw_target = saturations(index_saturation);

    pc_mid = params.capil.pres_func(sw_target, mean(entry_pressures,'all'));
    sw_mid = sw_target;
    for iteration_num=1:1000
        
        [pc_mid_tot, sw_mid, pc_mid, invaded_mat_mid, converged] = mip_iteration(...
            sw_target, dr, entry_pressures, porosities, pc_mid, ...
            Nz_sub, Nx_sub, Ny_sub,...
            params.capil.pres_func_inv, params.capil.pres_deriv,...
            options.sat_tol ...
            );

        if converged
            break;
        end
    end

    sw_upscaled(index_saturation) = sw_mid;
    pc_upscaled(index_saturation) = pc_mid_tot;

    sw = invaded_mat_mid .* sw_mid + ~invaded_mat_mid .* 1;

    kg_mat_local = params.rel_perm.gas_func(1-sw);
    kw_mat_local = params.rel_perm.wat_func(sw);

    kg_mat_local = kg_mat_local.*permeabilities; % FIXME scaling to absolute permeabilities
    kw_mat_local = kw_mat_local.*permeabilities; % FIXME scaling to absolute permeabilities

    kg_phase_connected_local = check_axis_connectivity(kg_mat_local, Nx_sub, Ny_sub, Nz_sub, tol_kr);
    kw_phase_connected_local = check_axis_connectivity(kw_mat_local, Nx_sub, Ny_sub, Nz_sub, tol_kr);

    [krg(:,index_saturation), krw(:,index_saturation)] = calc_phase_permeabilities(...
        dr_sub, Kabs, ...
        kg_phase_connected_local, kw_phase_connected_local,...
        kg_mat_local, kw_mat_local...
        );
end

sw_upscaled(end) = 1;
[sw_upscaled,unique_idx] = unique(sw_upscaled);
pc_upscaled = pc_upscaled(unique_idx);
krg = krg(:,unique_idx);
krw = krw(:,unique_idx);

[sw_upscaled,sorted_idx] = sort(sw_upscaled);
pc_upscaled = pc_upscaled(sorted_idx);
krg = krg(:,sorted_idx);
krw = krw(:,sorted_idx);

pc_upscaled(isinf(pc_upscaled)) = max(pc_upscaled(~isinf(pc_upscaled)));

if ~allfinite(pc_upscaled)
    disp(pc_upscaled);
end

end

function [pc_mid_tot, sw_mid, pc_mid, invaded_mat_mid, converged] = mip_iteration(...
    sw_target, dr, entry_pressures, porosities, pc_mid,...
    Nz_sub, Nx_sub, Ny_sub, ...
    pc_func_inv, pc_deriv, ...
    tol_sw)

invaded_mat_mid = check_box_connectivity(pc_mid, entry_pressures, Nz_sub, Nx_sub, Ny_sub);

volume = prod(dr);
sub_volume = volume./double(Nz_sub*Nx_sub*Ny_sub);
pore_volumes = porosities .* sub_volume;
pore_volume = sum(pore_volumes,'all');

sub_sw_mid = invaded_mat_mid .* pc_func_inv(pc_mid,entry_pressures) + ~invaded_mat_mid .* 1;
sub_sw_mid(~isfinite(sub_sw_mid)) = 1;
sw_mid = sum(sub_sw_mid.*pore_volumes,'all')/pore_volume;

pc_mid_tot = sum((1-sub_sw_mid).*pore_volumes.*pc_mid,"all")/(pore_volume*(1-sw_mid));

if sw_mid >=1
    pc_mid_tot = pc_mid; % FIXME remove
end

sw_err = sw_target - sw_mid;
err = abs(sw_err);
converged = err <= tol_sw;
if converged
    return;
end

deriv = pc_deriv(sw_mid, mean(entry_pressures,'all'));

dpc = sw_err*deriv;

pc_mid = pc_mid + dpc * 0.5;
if ~isfinite(pc_mid)
    error('')
end
pc_mid = max(pc_mid,min(entry_pressures,[],'all'));
end

function [krg, krw] = calc_phase_permeabilities(...
    dr_sub, Kabs,...
    kg_phase_connected, kw_phase_connected, kg_mat, kw_mat ...
    )

Kx = Kabs(1);
Ky = Kabs(2);
Kz = Kabs(3);

Kalli = zeros(1,6);

h1g = (kg_phase_connected(3) > 0);
h1w = (kw_phase_connected(3) > 0);
h2g = (kg_phase_connected(2) > 0);
h2w = (kw_phase_connected(2) > 0);
v1g = (kg_phase_connected(1) > 0);
v1w = (kw_phase_connected(1) > 0);
if h1g || h2g || v1g
    Estimate = Calculate_Kabs(kg_mat, dr_sub(1), dr_sub(2), dr_sub(3), h1g, h2g, v1g);
    Kalli(1) = Estimate(1);
    Kalli(2) = Estimate(2);
    Kalli(3) = Estimate(3);
end
if h1w || h2w || v1w
    Estimate = Calculate_Kabs(kw_mat,dr_sub(1), dr_sub(2), dr_sub(3), h1w, h2w, v1w);
    Kalli(4) = Estimate(1);
    Kalli(5) = Estimate(2);
    Kalli(6) = Estimate(3);
end

Kalli([1,4]) = Kalli([1,4]) ./ Kx;
Kalli([2,5]) = Kalli([2,5]) ./ Ky;
Kalli([3,6]) = Kalli([3,6]) ./ Kz;

krg = Kalli(1:3)';
krw = Kalli(4:6)';

end

function [Estimate] = Calculate_Kabs(Kai0,Lx,Ly,Lz,h1,h2,v1) % TODO support anisotropic inputs
Kh1 = 0;
Kh2 = 0;
Kv1 = 0;

% effective simulation domain, along y direction
[x0,y0,z0] = size(Kai0);
Q = 1 * 10^-6 / 60;      % (ml/min)->m3/s % FIXME: replace with input parameter
Muw = 1 * 10^-3;         % cp-PaS         % FIXME: replace with input parameter
Pout = 1.0;                               % FIXME: replace with input parameter

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
    X1=mldivide(A,B);
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
    X1=mldivide(A,B);
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
    X1=mldivide(A,B);
    Pin = X1(end);
    Ae = y0*z0*Ly*Lz;          %m2
    Le = (x0+0)*Lx;            %m
    Kv1 = Q/((Pin-Pout)*Ae/Le/Muw) * 10^12; %Darcy
end

Estimate = [Kh1,Kh2,Kv1];

end
