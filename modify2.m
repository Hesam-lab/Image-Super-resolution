function uH = modify2(ph,fu,idx,a,b,m0)
% modify 
uH = zeros(a,b);
for i = 1:a
    for j = 2:m0
        k = size(ph{i,j},2);
        if k > 0 
            ph{i,j-1}(end) = (ph{i,j-1}(end)+ph{i,j}(1))/2;
            ph{i,j}(1) = [];
        end
    end
end
% transformed GPS to uniform gradients
for i = 1:a
    k = size(ph{i,1},2);
    if k > 0
        temp = ph(i,:);
        uH(i,idx(i,1):idx(i,2)) = cat(2,temp{:});
    else
    end 
end

m = find(fu<0);
fu = abs(fu);
uH(m) = -1*uH(m);
 range = max(fu,[],'all') - min(fu,[],'all');
 uH = uH * range;   %normalized edge map between 0 and max
 
 
 
 
 