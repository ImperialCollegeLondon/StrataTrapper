function [features,decoder] = to_features(tables,sw,fit_parametric,fit_total_mobility,...
    num_principal_components)
arguments
    tables
    sw
    fit_parametric logical
    fit_total_mobility logical
    num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive} = []
end

if fit_parametric
    [features, decoder_fit] = reduce_corr(tables,sw);
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
origin = min(features,[],2);
[U,S,V] = svd(features-origin,"econ");
num_pc = min(num_pc,size(V,2));
encoded = V(:,1:num_pc)';
Phi = U(:,1:num_pc)*S(1:num_pc,1:num_pc);
decoder = @(encoded) Phi*encoded + origin;
end

function [encoded, decoder] = reduce_corr(tables,sw)

x0 = [0,0,1,1,1,1,1,1,1,1];

encoded_krwg = repmat(x0,size(tables.krw,1),1);

options.Display = "off";

for table_num = 1:size(tables.krw,1)

    krwg = [tables.krw(table_num,:),tables.krg(table_num,:)];
    resid_fun = @(x) let_residual(krwg,sw,x(1),x(2),x(3),x(4),x(5),x(6),x(7),x(8),x(9),x(10));

    [x,~,~,~] = fmincon(resid_fun,x0,[],[],[],[],...
        [0,0,0,0,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf],...
        [1,1,Inf,Inf,Inf,Inf,Inf,Inf,Inf,Inf],[],options);

    encoded_krwg(table_num,:) = x;
end

encoded = [log10(tables.leverett_j),encoded_krwg]';
decoder = @(encoded) let_decoder(encoded',sw);

end

function krwg = calc_let_wg(sw,sw_irr,sg_cr,kw_max,kg_max,L_w,E_w,T_w,L_g,E_g,T_g)

    swn = (sw-sw_irr-sg_cr)/(1-sw_irr-sg_cr);
    swn = min(swn,1);
    swn = max(swn,0);

    krw = calc_let(kw_max,L_w,E_w,T_w,swn);
    krg = calc_let(kg_max,L_g,E_g,T_g,1 - swn);

    krwg = [krw,krg];
end

function kr = calc_let(k_max,L,E,T,sn)
    kr = k_max.*(sn.^L)./(sn.^L+E.*((1-sn).^T));
end


function resid = let_residual(krwg,sw,sw_irr,sg_cr,kw_max,kg_max,L_w,E_w,T_w,L_g,E_g,T_g)
    resid = norm(krwg-calc_let_wg(sw,sw_irr,sg_cr,kw_max,kg_max,L_w,E_w,T_w,L_g,E_g,T_g));
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
