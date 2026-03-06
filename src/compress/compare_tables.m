function err = compare_tables(tables_1,tables_2,fit_total_mobility)

err = repmat(struct('delta',[],'delta_mse',Inf),size(tables_1));

for param_id = 1:size(tables_1,1)
    for dir=1:3

        feat_dir_1 = to_features(tables_1(param_id,dir),fit_total_mobility);
        feat_dir_full_1 = feat_dir_1(:,tables_1(param_id,dir).mapping);

        feat_dir_2 = to_features(tables_2(param_id,dir),fit_total_mobility);
        feat_dir_full_2 = feat_dir_2(:,tables_2(param_id,dir).mapping);

        err(param_id,dir).delta = feat_dir_full_2 - feat_dir_full_1;
        err(param_id,dir).delta_mse = norm(err(param_id,dir).delta,"fro")/...
            sqrt(numel(err(param_id,dir).delta));
    end
end
end
