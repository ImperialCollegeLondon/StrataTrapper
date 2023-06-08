
function [sw] =Brooks_corey_Sw(pc, pe, swirr,lambda)

if (pc < pe)
    sw = 1;
else
    sw = real(((pc./pe).^(-lambda)).*(1-swirr) + swirr);
end
end






























