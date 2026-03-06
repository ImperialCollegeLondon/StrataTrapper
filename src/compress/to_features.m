function features = to_features(tables,fit_total_mobility)
    w = (~fit_total_mobility) + 0.5 * fit_total_mobility;
    features_krw_transpose = w.*tables.krw + (1-w).* tables.krg;
    features = [log10(tables.leverett_j),features_krw_transpose,tables.krg]';
end
