function err = compare_tables(tables_1,tables_2,fit_total_mobility)

err = repmat(struct('delta',[],'delta_mse',Inf),3,1);

for dir=1:3

    feat_dir_1 = to_features(tables_1(dir),fit_total_mobility);
    feat_dir_full_1 = feat_dir_1(:,tables_1(dir).mapping);

    feat_dir_2 = to_features(tables_2(dir),fit_total_mobility);
    feat_dir_full_2 = feat_dir_2(:,tables_2(dir).mapping);

    err(dir).delta = feat_dir_full_2 - feat_dir_full_1;
    err(dir).delta_mse = norm(err(dir).delta,"fro")/sqrt(numel(err(dir).delta));
end
end
