function err = compare_tables(tables_1,tables_2,saturations,args)
arguments
    tables_1
    tables_2
    saturations
    args.fit_parametric logical = false
    args.fit_total_mobility logical = false
    args.num_principal_components (:,1) uint32 {mustBeScalarOrEmpty,mustBePositive} = []
    args.verbose (1,1) logical = false
end

err = repmat(struct('delta',[],'delta_mse',Inf),size(tables_1));

transform = @(table,sw) ...
    to_features(table,sw,args.fit_parametric,args.fit_total_mobility,args.num_principal_components);

for param_id = 1:size(tables_1,1)
    sw = saturations(param_id,:);
    for dir=1:3

        feat_dir_1 = transform(tables_1(param_id,dir),sw);
        feat_dir_full_1 = feat_dir_1(:,tables_1(param_id,dir).mapping);

        feat_dir_2 = transform(tables_2(param_id,dir),sw);
        feat_dir_full_2 = feat_dir_2(:,tables_2(param_id,dir).mapping);

        delta = feat_dir_full_2 - feat_dir_full_1;
        err(param_id,dir).delta_mse = norm(delta,"fro")/...
            sqrt(numel(delta));
        if args.verbose
            err(param_id,dir).delta = delta;
        end
    end
end
end
