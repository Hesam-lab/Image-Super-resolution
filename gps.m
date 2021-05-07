function [p_t, p_g] = gps(Q,p_int,N)
%GPS of triangle models (p_t) & GPS of mixed gaussian models (p_g) 

[a, m0] = size(p_int);
p_g = p_int;
p_t = p_int;

for i = 1:a
    for j = 1:m0
        n = size(Q{i,j},2);
        if n > N
            % mixed gaussian model calculation
            pg = Q{i,j}; %outout of function
            dg = length(pg);    % spatial scattering
            h = max(pg);    % edge contrast
            eta = h./dg;
            p_g{i,j} = eta;
        elseif n <= N && n > 0
            % triangle model calculation
            pt = Q{i,j};
            [h, x0] = max(pt); % edge contrast (intercept)
            dt = length(pt);    % spatial scattering (slope)
            eta = h./dt;
            p_t{i,j} = eta;
        else
        end
    end
end