function upscaled_permeability = upscale_permeability(permeabilities,Lx,Ly,Lz)
upscaled_permeability = Calculate_Kabs(permute(permeabilities,[3,1,2]),Lz,Lx,Ly,true,true,true);
end

% NOTE: size(Kai0) = [Nz,Nx,Ny]
% NOTE: output order is [Kx, Ky, Kz]
function [Estimate] = Calculate_Kabs(Kai0,Lx,Ly,Lz,h1,h2,v1)
Kh1 = 0;
Kh2 = 0;
Kv1 = 0;

% effective simulation domain, along y direction
[x0,y0,z0] = size(Kai0);

Q = 1;
Muw = 1;
Pout = 1;

x=x0+2; %for layer
y=y0+2; %for layer
z=z0+2;

Kai = zeros(x,y,z);
Kai(2:end-1,2:end-1,2:end-1) = Kai0;
%no value for first and endlayer

cond_common = Kai(:) ./ Muw;

Condx = cond_common .* (Ly *Lz / Lx);
Condy = cond_common .* (Lx *Lz / Ly);
Condz = cond_common .* (Lx *Ly / Lz);

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
    B(end) = Q; %due to D
    X1=mldivide(A,B);
    Pin = X1(end);
    Ae = x0*z0*Lx*Lz;          %m2
    Le = (y0+0)*Ly;            %m,+0 considering bouyndary is half, +1 for one
    Kh1 = Q/((Pin-Pout)*Ae/Le/Muw);
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
    B(end) = Q; %due to D
    X1=mldivide(A,B);
    Pin = X1(end);
    Ae = x0*y0*Lx*Ly;          %m2
    Le = (z0+0)*Lz;            %m
    Kh2 = Q/((Pin-Pout)*Ae/Le/Muw);
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
    B(end) = Q; %due to D
    X1=mldivide(A,B);
    Pin = X1(end);
    Ae = y0*z0*Ly*Lz;          %m2
    Le = (x0+0)*Lx;            %m
    Kv1 = Q/((Pin-Pout)*Ae/Le/Muw);
end

Estimate = [Kh1,Kh2,Kv1];

end
