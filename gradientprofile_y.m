function [p, d, g, idx, fy] = gradientprofile_y(x_in, m0,band)

% Compute edge map
x_in = x_in(:,:,band);

x_in = double (x_in);
[~, fy] = gradient(x_in); % edge map
fy = imrotate(fy,90);
f = abs(fy);
fn = (f-min(f,[],'all'))./(max(f,[],'all')-min(f,[],'all')); %normalized edge map between 0 and 1

% Gradient Profile structure
[a, ~] = size(fn);
p_int = cell(a,m0);
[p, d, g, idx] = buildprofile(fn,p_int);