function kr_let = calc_let_normalized(sn,k_max,L,E,T)
    kr_let = k_max.*(sn.^L)./(sn.^L+E.*((1-sn).^T));
end