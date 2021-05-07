function uH_x = GPS_x(U,L,m0,N,band)

% Gradient Profile structure
[pu, ~, ~, idx, fx] = gradientprofile_x(U, m0, band);
[pl, ~, ~, ~, ~] = gradientprofile_x(L, m0, band);

% Gradient Profile Description of Models and GPS Metric
[PT0_U, PG0_U] = estimateGPS(pu,N);
[PT0_L, PG0_L] = estimateGPS(pl,N);
% Parameter Estimation of GPS Transformation Relationship
alpha = estimateAlpha(PG0_U,PT0_U,PG0_L,PT0_L);
% Gradient Profile Transformation
ph = transformGPS(pu,N,alpha);

% modify 
[a, b,~] = size(U);
uH_x = modify2(ph,fx,idx,a,b,m0);