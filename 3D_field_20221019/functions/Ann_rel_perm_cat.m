


function [kg, kw] =Ann_rel_perm_cat(sw, swirr, test)
    kw = ((sw - test)./(1 - test)).^(7);
    kg= 0.6*((1-((sw - swirr)./(1 - swirr))).^(3)); 
    
    
    
    
    
    
 
end






























