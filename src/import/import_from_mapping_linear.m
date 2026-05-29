function sub_rock=import_from_mapping_linear(dims_fine,ind_coarse,rock_fine)
% import_from_mapping_linear map fine-scale rock properties
%   to sub_rock input of strata_trapper
arguments
    dims_fine (1,3) {mustBeInteger,mustBeNonnegative} % Cartesian index dimensions of the fine grid
    ind_coarse (:,1) {mustBeNumeric} % coarse-grid indices for each fine cell
    rock_fine (1,1) struct % MRST-like rock data struct with .poro and .perm
end

min_ind_coarse=min(ind_coarse,[],"all","omitmissing");
max_ind_coarse=max(ind_coarse,[],"all","omitmissing");

sub_rock(1:max_ind_coarse)=struct('poro',[],'perm',[]);

for i=min_ind_coarse:max_ind_coarse
    [ind_local,ijk_local,ind_fine_local,dims_local] ...
        = ind_fine_to_ind_local(ind_coarse,i,dims_fine);

    sub_poro = zeros(dims_local);
    sub_poro(ind_local)=rock_fine.poro(ind_fine_local);
    sub_rock(i).poro=sub_poro;

    sub_perm = zeros([dims_local,3]);
    for dir = 1:3
        ind_perm_dir=sub2ind([dims_local,3],ijk_local(:,1),ijk_local(:,2),ijk_local(:,3),...
            repmat(dir,numel(ind_local),1));
        sub_perm(ind_perm_dir) = rock_fine.perm(ind_fine_local, dir);
    end

    sub_rock(i).perm=sub_perm;
end

end

function [ind_local,ijk_local,ind_fine_local,dims_local] ...
    = ind_fine_to_ind_local(ind_coarse,i,dims_fine)
ind_fine_local=find(ind_coarse==i);
[i_fine_local,j_fine_local,k_fine_local]=ind2sub(dims_fine,ind_fine_local);
ijk_fine_local=[i_fine_local,j_fine_local,k_fine_local];
local_sub_min=min(ijk_fine_local,[],1,"omitmissing");
local_sub_max=max(ijk_fine_local,[],1,"omitmissing");
dims_local=local_sub_max+1-local_sub_min;
ijk_local = ijk_fine_local +1-local_sub_min;
ind_local=sub2ind(dims_local,ijk_local(:,1),ijk_local(:,2),ijk_local(:,3));
end
