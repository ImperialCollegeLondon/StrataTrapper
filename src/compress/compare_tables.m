function err = compare_tables(tables_1,tables_2,saturations,fit_parametric,fit_total_mobility,...
    num_principal_components)
arguments
    tables_1
    tables_2
    saturations
    fit_parametric logical
    fit_total_mobility logical
    num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive} = []
end

err = repmat(struct('delta',[],'delta_mse',Inf),size(tables_1));

transform = @(table,sw) ...
    to_features(table,sw,fit_parametric,fit_total_mobility,num_principal_components);

for param_id = 1:size(tables_1,1)
    sw = saturations(param_id,:);
    for dir=1:3

        feat_dir_1 = transform(tables_1(param_id,dir),sw);
        feat_dir_full_1 = feat_dir_1(:,tables_1(param_id,dir).mapping);

        feat_dir_2 = transform(tables_2(param_id,dir),sw);
        feat_dir_full_2 = feat_dir_2(:,tables_2(param_id,dir).mapping);

        err(param_id,dir).delta = feat_dir_full_2 - feat_dir_full_1;
        err(param_id,dir).delta_mse = norm(err(param_id,dir).delta,"fro")/...
            sqrt(numel(err(param_id,dir).delta));
    end
end
end
