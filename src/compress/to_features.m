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
% TODO: consider applying PCA to the derivative to preserve monotonicity
    origin = mean(features,2);
[U,S,V] = svd(features-origin,"econ");
num_pc = min(num_pc,size(V,2));
encoded = V(:,1:num_pc)';
Phi = U(:,1:num_pc)*S(1:num_pc,1:num_pc);
decoder = @(encoded) Phi*encoded + origin;
end

function [encoded, decoder] = reduce_corr(tables,sw,parfor_arg)
arguments
    tables (1,1) UpscaledTables
    sw (1,:) double
    parfor_arg (1,1) uint32
end

x0 = [0,0,1,1,1,1,1,1,1,1];

krw = tables.krw;
krg = tables.krg;

encoded_krwg = repmat(x0,size(krw,1),1);

parfor (table_num = 1:size(krw,1),parfor_arg)

    x = fit_LET(krw(table_num,:),krg(table_num,:),sw);

    encoded_krwg(table_num,:) = x;
end

encoded = [log10(tables.leverett_j),encoded_krwg]';
decoder = @(encoded) let_decoder(encoded',sw);

end

function decoded = let_decoder(encoded,sw)
leverett_j_log = encoded(:,1:numel(sw));
x = encoded(:,numel(sw)+1:end);
krwg = zeros(size(encoded,1),numel(sw)*2);
for i = 1:size(encoded,1)
     krwg(i,:) = calc_let_wg(sw,...
         x(i,1),x(i,2),x(i,3),x(i,4),x(i,5),x(i,6),x(i,7),x(i,8),x(i,9),x(i,10));
end
decoded = [leverett_j_log,krwg]';
end
