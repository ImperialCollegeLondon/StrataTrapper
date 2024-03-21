function sw = brooks_corey_inv(pc,sw_resid,p_entry,lambda)
sw = (p_entry./pc).^lambda .* (1-sw_resid) + sw_resid;
end