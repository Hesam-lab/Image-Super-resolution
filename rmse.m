function r=rmse(data,estimate)
% Function to calculate root mean square error from a data vector or matrix 
% and the corresponding estimates.
I = ~isnan(data) & ~isnan(estimate); 
data = data(I); estimate = estimate(I);
r=sqrt(sum((data(:)-estimate(:)).^2)/numel(data));