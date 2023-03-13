
function sw =Van_Genuchten_Sw(pc, alpha, swirr,n)

    m = 1-1/n;
    sw = (((alpha.*pc).^n + 1).^(-m)).*(1-swirr)+swirr;

    if (sw > 1)
        sw = 1;
    end
        
    
end






























