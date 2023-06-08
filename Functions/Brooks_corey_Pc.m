
function [pc] =Brooks_corey_Pc(sw, pe, swirr,lambda)
    sw_star = (sw - swirr)./(1-swirr);
    pc = real(pe.*sw_star.^(-1./lambda));
end






























