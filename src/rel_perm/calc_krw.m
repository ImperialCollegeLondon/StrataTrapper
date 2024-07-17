function [krw, sw_irr] = calc_krw(sw)
persistent data sw_irr_

if isempty(data)
    data = [...
        0.42 0.00;
        0.45 0.01;
        0.50 0.03;
        0.55 0.08;
        0.60 0.13;
        0.65 0.20;
        0.70 0.28;
        0.71 0.29;
        0.75 0.38;
        0.80 0.50;
        0.85 0.60;
        0.90 0.70;
        0.95 0.85;
        1.00 1.00;
        ];
    sw_irr_ = interp1(data(:,2), data(:,1), 0);
end

krw = interp1(data(:,1), data(:,2), sw, "linear");
sw_irr = sw_irr_;

end

