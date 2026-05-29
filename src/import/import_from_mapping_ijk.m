function sub_rock = import_from_mapping_ijk(dims_fine,sub_coarse,rock_fine)
% import_from_mapping_ijk map fine-scale rock properties
%   to sub_rock input of strata_trapper
arguments
    dims_fine
    sub_coarse (:,3) {mustBeInteger,mustBeNonnegative} % coarse-grid ijk triplets for each fine cell
    rock_fine 
end

ind_coarse = sub_coarse_to_ind_coarse(sub_coarse);
sub_rock = import_from_mapping_linear(dims_fine, ind_coarse, rock_fine);
end

function ind_coarse =sub_coarse_to_ind_coarse(sub_coarse)
idx_active=find(sub_coarse(:,1));
sub_coarse(sub_coarse(:)<1)=nan;

coarse_sub_min=min(sub_coarse,[],1,"omitmissing");
coarse_sub_max=max(sub_coarse,[],1,"omitmissing");

coarse_dims=coarse_sub_max+1-coarse_sub_min;

ijk_coarse=sub_coarse(idx_active,:)+1-coarse_sub_min;

idx_coarse=sub2ind(coarse_dims,ijk_coarse(:,1),ijk_coarse(:,2),ijk_coarse(:,3));

ind_coarse=nan(size(sub_coarse,1),1);
ind_coarse(idx_active) = idx_coarse;
end
