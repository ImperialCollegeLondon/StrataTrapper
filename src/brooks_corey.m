function pc = brooks_corey(sw,sw_resid,p_entry,lambda)
if sw <= sw_resid
    pc = Inf;
    return;
end
sw = min(sw,1);
pc = p_entry .* ((1-sw_resid)./(sw-sw_resid)).^(1/lambda);
end
