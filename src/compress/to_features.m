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

krw = tables.krw;
krg = tables.krg;

krw_max = max(krw,[],2);
krg_max = max(krg,[],2);

sw_mins = zeros(size(krw,1),1);
sw_maxs = zeros(size(krw,1),1);

LETw = zeros(size(krw,1),3);

LETg = zeros(size(krg,1),3);


parfor(row_idx = 1:size(krw,1),parfor_arg)
    krw_table = krw(row_idx,:);
    sw_min_idx = find(krw_table==0,1,"last");

    sw_min = sw(sw_min_idx); sw_mins(row_idx) = sw_min;
    swn = (sw-sw_min)./(1 - sw_min);
    swn = max(swn,0);
    swn = min(swn,1);

    LETw(row_idx,:) = fit_LET(swn,krw_table,krw_max(row_idx));

    krg_table = krg(row_idx,:);
    sw_max_idx = find(krg_table==0,1,"first");
    sw_max = sw(sw_max_idx); sw_maxs(row_idx) = sw_max;
    sg_min = 1 - sw_max;
    sg_max = 1 - sw_min;
    sg = 1 - sw;
    sgn = (sg-sg_min)./(sg_max - sg_min);
    sgn = max(sgn,0);
    sgn = min(sgn,1);

    LETg(row_idx,:) = fit_LET(sgn,krg_table,krg_max(row_idx));
end

encoded = [log10(tables.leverett_j),LETw,LETg]';

decoder = @(encoded) decode_j_let(encoded',sw,sw_mins,sw_maxs,krw_max,krg_max);

end

function decoded = decode_j_let(encoded,sw,sw_mins,sw_maxs,kw_max,kg_max)
leverett_j_log = encoded(:,1:numel(sw));
LETw = encoded(:,numel(sw)+(1:3));
LETg = encoded(:,numel(sw)+3+(1:3));

sg = 1-sw;
sg_mins = 1-sw_maxs;
sg_maxs = 1-sw_mins;

krw = zeros(size(encoded,1),numel(sw));
krg = zeros(size(encoded,1),numel(sw));
for i = 1:size(encoded,1)
    krw(i,:) = decode_from_let(sw,sw_mins(i),1,kw_max(i),LETw(i,:));
    krg(i,:) = decode_from_let(sg,sg_mins(i),sg_maxs(i),kg_max(i),LETg(i,:));
end
decoded = [leverett_j_log,krw,krg]';
end

function sn = calc_sat_normalized(sat,s_min,s_max)
sn = (sat-s_min)./(s_max - s_min);
sn = max(sn,0);
sn = min(sn,1);
end

function kr = decode_from_let(sat,s_min,s_max,k_max,LET)
sn = calc_sat_normalized(sat,s_min,s_max);
kr = calc_let_normalized(sn,k_max,LET(1),LET(2),LET(3));
end
