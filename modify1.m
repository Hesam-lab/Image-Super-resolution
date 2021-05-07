function Q = modify1(p,p_int)
% temporarily removing zero gradients 

[a, m0] = size(p_int);
Q = p_int;
[~,ncols] = cellfun(@size,p);
N = max(ncols,[],'all');
for i = 1:a
    for j = 1:m0
        q = p{i,j};
        r = length(q);
        temp1 = zeros(1,N);
        for m = 1:r-1
            if q(m)==q(m+1) && q(m)==0
                temp1(m) = m;
            end
        end
        temp1(temp1==0)=[];
        if any(temp1)==1
            q(temp1)=[];
        else
        end
        Q{i,j} = q;
    end
end