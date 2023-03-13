%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Brooks-Corey Pc fitting tool, that uses fminsearch, with default step size
%and error tolerance.This takes in a guess of pe, swirr and lambda to use 
%as a starting point. Note the residual error, between the predicted BC
%curve and the MICP points is based on both Pc and Sw calculation with the
%BC formula. This normalises the error function. Relative errors can also
%be used, but can adversely weight towards low Pc or Sw. 

function [estimates] = pc_BC(xdata,ydata,pe,swirr,lambda)

estimates = fminsearch(@coreyfun,lambda);

    function sse = coreyfun(params)
    A = pe; %params(1);  %Entry pressure
    B = params(1); %Lambda
    C = swirr; %Swirr
    
    FittedCurveX = A.*((1-C)./(xdata-C)).^(1./B);
    inde = FittedCurveX > max(ydata);
    FittedCurveX(inde) = max(ydata);
    
    FittedCurveY = C + (1 - C)./(ydata./A).^(B);
    
    ErrorVecX = ((FittedCurveX) - (ydata))./(1);
    ErrorVecY = ((FittedCurveY) - (xdata))./(1);
    
    sse = sum(sqrt(ErrorVecX.^2).*sqrt(ErrorVecY.^2));
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




























