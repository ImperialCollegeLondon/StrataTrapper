%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DO NOT ALTER THIS FUNCTION. CLOSE THIS FILE AND OPEN pcfit.m    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [estimates] =Chierici_optimiser(sw_kg, sw_kw, kg, kw, kgsgi,kwswirr,swirr, A_chierici, L_chierici, B_chierici, M_chierici)

AA = [];
b = [];
Aeq = [];
beq = [];

lb = [0,0];
ub = [40,40];

estimates(1:2) = fmincon(@chierici_water,[A_chierici, L_chierici],AA,b,Aeq,beq,lb,ub);
estimates(3:4) = fmincon(@chierici_gas,[B_chierici, M_chierici],AA,b,Aeq,beq,lb,ub);

    function sse = chierici_water(params)
    A = params(1); % Entry pressure
    L = params(2); 

    
    kw_estimate = log(kwswirr)-A.*((sw_kw-swirr)./(1-sw_kw)).^(-L);
    kw_log = log(kw);
    sse =  sum(sqrt(((kw_estimate-kw_log)./kw_log).^2));
    
%   for i = 1:m
%     sw_estimate_kw(i,1) = fminbnd(@inv_chierici_w, 0, 1);
%   end
%     function res = inv_chierici_w(sw_2)  
%        res =  sum(abs(kwsirr.*exp(-A.*((sw_2-swirr)./(1-sw_2)).^(-L)) - kw(i)));
%     end

    
    end

function sse = chierici_gas(params)
    B = params(1);
    M = params(2);

    kg_estimate = log(kgsgi)-B.*((sw_kg-swirr)./(1-sw_kg)).^(M);
    kg_log = log(kg);
    sse =  sum(sqrt(((kg_estimate-kg_log)./kg_log).^2));
    
%  for i = 1:m
%    sw_estimate_kg(i,1) = fminbnd(@inv_chierici_g, 0, 1);
%  end  
%  function res = inv_chierici_g(sw_2)
%   res =  sum(abs(kgsgi.*exp(-B.*((sw_2-swirr)./(1-sw_2)).^(M)) - kg(i)));
%  end

    end


end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DO NOT ALTER THIS FUNCTION. CLOSE THIS FILE AND OPEN pcfit.m  %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























