%% These are all from the K40 reports %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%porosity and permeability relations
por_std = 0.02;                        %standard deviation of the por field
fporosity = @porosity_cal;
fpermeability = @permeability_cal;

%Pc brooks-corey parameters and Leverett - J scaling.
lambda = 0.75;   %Brooks corey Pc curve Lambda  
jsw1 = 0.25;     %Leverett-J function J(sw = 1) value.
angle = 37;      %contact angle

function y = porosity_cal(x)
    y = ((x - 5331.5)/(-171.68))/100;  %total por depth trend equation
end
function y = permeability_cal(x)
    %y = ((2*10^6).*(x.^5.4833));       %perm equation from K40 report, perm is in mD
    y = 10.^(4.19211.*log10(x)+5.168417);    
end