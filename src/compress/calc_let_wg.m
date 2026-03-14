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