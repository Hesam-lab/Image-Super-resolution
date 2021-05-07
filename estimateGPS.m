function [p_t, p_g] = estimateGPS(p,N)
% P_t and p_g are GPS metrics for triangle and mixed gaussian model, respectively.

[a, b] = size(p);
p_int = cell(a,b);

% Modify initial Gradient Profiles
Q = modify1(p,p_int);

% Gradient Profile sharpness (GPS) calculation
[p_t, p_g] = gps(Q,p_int,N);    
