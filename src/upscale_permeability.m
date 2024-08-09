function Kabs = upscale_permeability(permeabilities,Lx,Ly,Lz,mask)
arguments
    permeabilities (:,:,:) double
    Lx (1,1) double
    Ly (1,1) double
    Lz (1,1) double
    mask (1,3) logical = [true,true,true]
end

Kabs = [0,0,0];

[x0,y0,z0] = size(permeabilities);

Q = 1;
Muw = 1;
Pout = 1;

x=x0+2;
y=y0+2;
z=z0+2;

L = [Lx*x0,Ly*y0,Lz*z0];
V = prod(L);
Nr_ext = [x,y,z];

Kai = zeros(x,y,z);
Kai(2:end-1,2:end-1,2:end-1) = permeabilities;

cond_common = Kai(:) ./ Muw;

cond(:,1) = cond_common .* (Ly * Lz / Lx);
cond(:,2) = cond_common .* (Lx * Lz / Ly);
cond(:,3) = cond_common .* (Lx * Ly / Lz);

idx_conductive = find(cond_common>0);

idx_adj(:,1,1) = idx_conductive - 1;
idx_adj(:,1,2) = idx_conductive + 1;
idx_adj(:,2,1) = idx_conductive - x;
idx_adj(:,2,2) = idx_conductive + x;
idx_adj(:,3,1) = idx_conductive - x*y;
idx_adj(:,3,2) = idx_conductive + x*y;

num_eqs = length(idx_conductive) + 1;

A_diag = zeros(num_eqs,3);
A_diag(:,1) = 1:num_eqs;
A_diag(:,2) = 1:num_eqs;

num_cells_ext = x*y*z;

map_to_cond(1:num_cells_ext,1)=0;
map_to_cond(idx_conductive) = 1:length(idx_conductive);

A_ndiag{3,2} = [];

dirs=1:3;

for dir=dirs
    cond_dir = cond(:,dir);
    for neighbour=1:2
        idx_adj_current = idx_adj(:,dir,neighbour);
        pos_cond_adj = find(map_to_cond(idx_adj_current)>0);
        idx_cond_adj = idx_adj_current(pos_cond_adj);
        idx_to_cond_adj = idx_conductive(pos_cond_adj);
        mean_cond_adj = harm_mean(cond_dir(idx_to_cond_adj), cond_dir(idx_cond_adj));
        pos_eq = map_to_cond(idx_to_cond_adj);
        pos_var_adj = map_to_cond(idx_cond_adj);
        A_diag(pos_eq,3) = A_diag(pos_eq,3) + mean_cond_adj;
        A_ndiag{dir,neighbour} = [pos_eq, pos_var_adj, -mean_cond_adj];
    end
end

A_ndiag = cell2mat(reshape(A_ndiag,[],1));

[lin_to_sub(:,1),lin_to_sub(:,2),lin_to_sub(:,3)] = ind2sub([x,y,z],1:num_cells_ext);
is_inner = false(num_cells_ext,3);


for dir = dirs
    is_inner(:,dir) = (lin_to_sub(:,dir) > 1)  & (lin_to_sub(:,dir) < Nr_ext(dir));
end

for dir = dirs(mask)
    A_diag_all = A_diag;
    cond_dir_x2 = cond(:,dir)*2;

    dirs_orth = dirs(dirs~=dir);
    is_inner_orth = prod(is_inner(:,dirs_orth),2);

    is_to_bound_L = (lin_to_sub(:,dir) == 2) & is_inner_orth;
    idx_cond_to_bound_L = find(is_to_bound_L & (cond_common>0));

    cond_dir_Lx2 = cond_dir_x2(idx_cond_to_bound_L);
    A_diag_all(num_eqs,3) = A_diag_all(num_eqs,3) + sum(cond_dir_Lx2);

    pos_eq_L = map_to_cond(idx_cond_to_bound_L);
    A_diag_all(pos_eq_L,3) = A_diag_all(pos_eq_L,3) + cond_dir_Lx2;

    num_eqs_rep = repmat(num_eqs,size(idx_cond_to_bound_L));
    pos_eq_in = [pos_eq_L; num_eqs_rep];
    pos_var_in = [num_eqs_rep; pos_eq_L];

    Ain = [pos_eq_in,pos_var_in,repmat(-cond_dir_Lx2,[2,1])];

    is_to_bound_R = (lin_to_sub(:,dir) == (Nr_ext(dir)-1)) & is_inner_orth;
    idx_cond_to_bound_R = find(is_to_bound_R & (cond_common>0));

    cond_dir_Rx2 = cond_dir_x2(idx_cond_to_bound_R);

    pos_eq_R = map_to_cond(idx_cond_to_bound_R);
    A_diag_all(pos_eq_R,3) = A_diag_all(pos_eq_R,3) + cond_dir_Rx2;

    A=[A_diag_all;A_ndiag;Ain];
    A = sparse(A(:,1),A(:,2),A(:,3),num_eqs,num_eqs);
    B = zeros(num_eqs,1);
    B(pos_eq_R) = Pout * cond_dir_Rx2;
    B(end) = Q;

    condest_a = condest(A);

    if condest_a==Inf
        Kabs(dir) = 0;
        continue;
    end

    if 1/condest_a < eps
        X1 = lsqminnorm(A,B);
    else
        X1=A\B;
    end

    Pin = X1(end);

    dist_to_area = L(dir)^2 / V;

    Kabs(dir) = Q * Muw * dist_to_area / (Pin-Pout);

    if isnan(Kabs(dir))
        warning('unexpected NaN detected');
        Kabs(dir) = 0;
    end
end

end

function result = harm_mean(a,b)
denom = (a + b);
result = (a .* b) ./ denom * 2;
result(denom==0) = 0;
end
