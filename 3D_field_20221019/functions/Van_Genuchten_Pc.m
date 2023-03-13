
function [pc] =Van_Genuchten_Pc(sw, alpha, swirr,n)
    sw_star = (sw - swirr)./(1-swirr);
    
    m = 1-1./n;
    pc = (1./(alpha)).*(sw_star.^(-1./m)-1).^(1./n);
    
 
end






























