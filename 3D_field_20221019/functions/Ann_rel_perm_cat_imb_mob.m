
function [kg] = Ann_rel_perm_cat_imb_mob(sw, swi, swirr, cl)


[m,n] = size(sw);
snw = 1 - sw;

sn_res = (1-swi)/(1+cl*(1-swi));
sw_res = 1- sn_res;

sw_star = (sw - swirr)./(1-swirr);
snw_star = 1-sw_star;
swi_star = (swi - swirr)/(1-swirr);
snwi_star = 1-swi_star;

snwr_star = snwi_star./(1+cl.*snwi_star);
% 
% delta = snwr_star - snw_star;
% 
% snwm_star = 0.5.*(-delta+sqrt(delta.^2 - 4.*delta./cl));
% 
% swm_star = 1-snwm_star;
% swm = (swm_star.*(1-swirr))+swirr;


delta = sn_res - snw;

snwm = 0.5.*(-delta + sqrt(delta.^2 - (4.*delta./cl)));

swm = 1-snwm;
swm_star = (swm - swi)./(1-swi);
    
kg= real(0.6*((1-swm_star).^(3)));
    
for i = 1:m
    for j = 1:n
        
       if (sw(i,j) > sw_res)

            kg(i,j) = 0;
          
        end
    end
end    
    
    
 
end






























