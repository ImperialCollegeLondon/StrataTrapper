%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DO NOT ALTER THIS FUNCTION. CLOSE THIS FILE AND OPEN pcfit.m    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [kg, kw] =LET_function(sw, swirr, kwsgi, kgswirr, l_w, e_w, t_w, l_g, e_g, t_g)


    sw_norm = (sw-swirr)/(1-swirr);

    top_water = kwsgi.*(sw_norm.^l_w);
    bottom_water = (sw_norm.^l_w)+(e_w.*((1-sw_norm).^t_w));
    
    
    kw = top_water./bottom_water;
    
    top_gas = (kgswirr.*((1-sw_norm).^l_g));
    bottom_gas = ((1-sw_norm).^l_g)+(e_g.*(sw_norm.^t_g));
    
    kg= top_gas./bottom_gas;
    
    
    

%     kw = kwsirr.*exp(-A.*((sw-swirr)./(1-sw)).^(-L));
%     kg= kgsgi.*exp(-B.*((sw-swirr)./(1-sw)).^(M));
    
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DO NOT ALTER THIS FUNCTION. CLOSE THIS FILE AND OPEN pcfit.m  %%  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





























