function [p, d, g, idx, fx] = gradientprofile_x(x_in, m0,band)

% Compute edge map
x_in = x_in(:,:,band);

x_in = double (x_in);
fx = gradient(x_in); % edge map
f = abs(fx);
fn = (f-min(f,[],'all'))./(max(f,[],'all')-min(f,[],'all')); %normalized edge map between 0 and 1

% Gradient Profile structure
[a, ~] = size(fn);
p_int = cell(a,m0);
[p, d, g, idx] = buildprofile(fn,p_int);