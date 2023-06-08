function [krg_best, krw_best] =LET_function(sw,swirr,kwsirr,kgsgi,Kestimates)

    L_w = Kestimates(1);
    E_w = Kestimates(2);
    T_w = Kestimates(3);
    L_o = Kestimates(4);
    E_o = Kestimates(5);
    T_o = Kestimates(6);
    swn = (sw-swirr)./(1-swirr);
    krw_best = (kwsirr).*(swn.^L_w)./(swn.^L_w+E_w.*((1-swn).^T_w));
    krg_best = (kgsgi).*((1-swn).^L_o)./((1-swn).^L_o+E_o.*(swn.^T_o));
   
end
