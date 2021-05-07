function [p, d, g, idx] = buildprofile(fn,p_int)
% assigning intial profiles: dividing the gradients into a cell with different length 

p = p_int;
[a, b] = size(p);
d = zeros(a,b);
g = zeros(a,b);
idx = zeros(a,2);
for i = 1:a
    [~, m] = findpeaks(-1.*fn(i,:));
    [h, n] = findpeaks(fn(i,:));
    k = length(m);
    if k>0
            for z = 1:k-1
                p{i,z+1} = fn(i,m(z):m(z+1));
                d(i,z+1) = n(z+1);
                g(i,z+1) = h(z+1);
            end
            temp = find(fn(i,:));
            p{i,1} = fn(i,temp(1)-1:m(1));
            d(i,1) = n(1);
            g(i,1) = h(1);
            p{i,k+1} = fn(i,m(k):temp(end)+1);
            d(i,k+1) = n(k+1);
            g(i,k+1) = h(k+1);
            idx(i,1) = temp(1)-1;
            idx(i,2) = temp(end)+1;
    else
    end
end
