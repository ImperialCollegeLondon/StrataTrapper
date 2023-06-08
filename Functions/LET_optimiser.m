function [estimates] =LET_optimiser(sw_kg, sw_kw, kg, kw,kwswirr, kgsgi,swirr, L_w, E_w, T_w, L_o, E_o, T_o)

    %AA = [];
    %b = [];
    %Aeq = [];
    %beq = [];
    %lb = [0, 0, 0];
    %ub = [10, 10, 10];
    ind = find (kw == min(kw));
    if length(ind) >= 2 
        sw_kw(ind(floor(end/2)):ind(end)) = [];
        kw(ind(floor(end/2)):ind(end)) = [];
        sw_kg(ind(floor(end/2)):ind(end)) = [];
        kg(ind(floor(end/2)):ind(end))= [];
    end
    ind = find (kg == min(kg));
    if length(ind) >= 2 
        sw_kw(ind(1):ind(floor(end/2))) = [];
        kw(ind(1):ind(floor(end/2))) = [];
        sw_kg(ind(1):ind(floor(end/2))) = [];
        kg(ind(1):ind(floor(end/2))) = [];
    end
    swnw = (sw_kw-swirr)./(1-swirr);
    swng = (sw_kg-swirr)./(1-swirr);

    x0 = [L_w, E_w, T_w];
    options = optimset('Display','off');
    estimates(1:3) = fminsearch(@chierici_water, x0, options);
    %estimates(1:3) = fmincon(@chierici_water,x0,AA,b,Aeq,beq,lb,ub);
    x0 = [L_o, E_o, T_o];
    estimates(4:6) = fminsearch(@chierici_gas, x0, options);
    %estimates(4:6) = fmincon(@chierici_gas,x0,AA,b,Aeq,beq,lb,ub);

    function sse = chierici_water(params)
        L = params(1);
        E = params(2); 
        T = params(3);
        k_estimate = (kwswirr).*(swnw.^L)./(swnw.^L+E.*((1-swnw).^T));
        k_log = kw;
        %k_log = log(k_log);
        %k_estimate = log(k_estimate);
        %sse = norm((k_estimate-k_log));
        sse = mean(sqrt(((k_estimate-k_log)).^2)); 
        %sse =  sum(sqrt(((k_estimate-k_log)./k_log).^2));
%         plot(swn,k_log,'o');
%         hold on
%         plot(swn,k_estimate);
%         hold off
    end    
    
    function sse = chierici_gas(params)
        L = params(1);
        E = params(2); 
        T = params(3); 
        k_estimate = (kgsgi).*((1-swng).^L)./((1-swng).^L+E.*(swng.^T));
        k_log = kg;
        %k_log = log(k_log);
        %k_estimate = log(k_estimate);       
        %sse = norm((k_estimate-k_log));%
        sse = mean(sqrt(((k_estimate-k_log)).^2));
        %sse = sum(sqrt(((k_estimate-k_log)./k_log).^2));
%         plot(swng,k_log,'o');
%         hold on
%         plot(swng,k_estimate);
%         hold off
    end 

end































