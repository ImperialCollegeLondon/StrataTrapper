
function [kg, kw] =Chierici_rel_perm(sw, swirr,kwsirr, kgsgi, A, L, B, M)
    kw = kwsirr.*exp(-A.*((sw-swirr)./(1-sw)).^(-L));
    kg= kgsgi.*exp(-B.*((sw-swirr)./(1-sw)).^(M));
end






























