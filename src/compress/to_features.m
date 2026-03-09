function [features,decoder] = to_features(tables,sw,fit_parametric,fit_total_mobility,...
    num_principal_components, parfor_arg)
arguments
    tables (1,1) UpscaledTables
    sw (1,:) double
    fit_parametric (1,1) logical
    fit_total_mobility (1,1) logical
    num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive}
    parfor_arg (1,1) uint32 = 0
end

if fit_parametric
    [features, decoder_fit] = reduce_corr(tables,sw,parfor_arg);
else
    w = (~fit_total_mobility) + 0.5 * fit_total_mobility;
    features_krw_transpose = w.*tables.krw + (1-w).* tables.krg;
    features = [log10(tables.leverett_j),features_krw_transpose,tables.krg]';
    decoder_fit = @(x) x;
end

if isempty(num_principal_components)
    decoder_pca = @(x) x;
else
    [features, decoder_pca] = reduce_pca(features,num_principal_components);
end
decoder = @(x) decoder_fit(decoder_pca(x));

end

function [encoded, decoder] = reduce_pca(features,num_pc)
origin = mean(features,2);
[U,S,V] = svd(features-origin,"econ");
num_pc = min(num_pc,size(V,2));
encoded = V(:,1:num_pc)';
Phi = U(:,1:num_pc)*S(1:num_pc,1:num_pc);
decoder = @(encoded) Phi*encoded + origin;
end
