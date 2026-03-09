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

    if mod(table_num,500) == 1
        disp(table_num);
    end
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