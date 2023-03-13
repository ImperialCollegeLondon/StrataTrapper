function [estimates] =LET_optimiser_senyou(sw_kw, sw_kg, kg, kw,kwswirr, kgsgi,swirr, L_w, E_w, T_w, L_o, E_o, T_o)

AA = [];
b = [];
Aeq = [];
beq = [];

lb = [0,0, 0];
ub = [10,10, 10];

estimates(1:3) = fmincon(@chierici_water,[L_w, E_w, T_w],AA,b,Aeq,beq,lb,ub);
estimates(4:6) = fmincon(@chierici_gas,[L_o, E_o, T_o],AA,b,Aeq,beq,lb,ub);

function sse = chierici_water(params)
    L = params(1);
    E = params(2); 
    T = params(3); 
    swn = (sw_kw-swirr)./(1-swirr);
    k_estimate = (kwswirr).*(swn.^L)./(swn.^L+E.*((1-swn).^T));
    k_log = kw;
    k_estimate = log(k_estimate);
    k_log = log(k_log);
%     sse =  sum(sqrt(((k_estimate-k_log)./k_log).^2));
    sse =  sum(sqrt(((k_estimate-k_log)).^2));
end    

function sse = chierici_gas(params)
    L = params(1);
    E = params(2); 
    T = params(3); 
    swn = (sw_kg-swirr)./(1-swirr);
    k_estimate = (kgsgi).*((1-swn).^L)./((1-swn).^L+E.*(swn.^T));
    k_log = kg;
    k_estimate = log(k_estimate);
    k_log = log(k_log);
%     sse =  sum(sqrt(((k_estimate-k_log)./k_log).^2));
    sse =  sum(sqrt(((k_estimate-k_log)).^2));
end 

end































