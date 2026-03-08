function [features,decoder] = to_features(tables,fit_parametric,fit_total_mobility,...
    num_principal_components)
arguments
    tables
    fit_parametric logical
    fit_total_mobility logical
    num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive} = []
end

fit_total_mobility = fit_total_mobility && ~fit_parametric;

w = (~fit_total_mobility) + 0.5 * fit_total_mobility;
features_krw_transpose = w.*tables.krw + (1-w).* tables.krg;
features = [log10(tables.leverett_j),features_krw_transpose,tables.krg]';

if fit_parametric
    [features, decoder] = reduce_corr(features);
    return;
end

if isempty(num_principal_components)
    decoder = @(x) x;
    return;
end

[features, decoder] = reduce_pca(features,num_principal_components);
end

function [encoded, decoder] = reduce_pca(features,num_pc)
origin = min(features,[],2);
[U,S,V] = svd(features-origin,"econ");
num_pc = min(num_pc,size(V,2));
encoded = V(:,1:num_pc)';
Phi = U(:,1:num_pc)*S(1:num_pc,1:num_pc);
decoder = @(encoded) Phi*encoded + origin;
end

function [encoded, decoder] = reduce_corr(features)
error("not implemented");
fittype; % fit J-functions directly (maybe)
fit; % use constraints for rel perms
end
