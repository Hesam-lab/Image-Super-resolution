function ph = transformGPS(p,N,alpha)
[a, b] = size(p);
p_int = cell(a,b);

% Modify initial Gradient Profiles
Q = modify1(p,p_int);  

ptH = p_int;
pgH = p_int;
lambda = (1/alpha)^(1/2); %GPS transformation parameter

% function of mixed gaussian model
fun = @(z,x)(z(1)./((2*pi).^(1/2)*lambda*z(2)).*exp(-(x-lambda*z(3)).^2/(2*(lambda*z(2)).^2))...
+z(4)./((2*pi).^(1/2)*lambda*z(5)).*exp(-(x-lambda*z(6)).^2/(2*(lambda*z(5)).^2)));

xint = [1,1,1,1,1,1];

for i = 1:a
    for j = 1:b
        temp = Q{i,j};
        dif = diff(temp);
        t = dif==0;
        if any(t==0)
            temp(1,t)=-1;
            temp(temp==-1)=[];
        end
        n = size(temp,2);
        if n > N
            % mixed gaussian model calculation
            pg = p{i,j}; %outout of function
            dgU = length(pg);    % spatial scattering
            x = 1:dgU; % input of function
            options = optimoptions('lsqcurvefit','Display','off');
            par = lsqcurvefit(fun,xint,x,pg,[],[],options);   % nonlinear curvefitting
            temp = fun(par,x);
            temp(temp<0)=0;  
            pgH{i,j} = temp;
        elseif n <= N && n > 0
            % triangle model calculation
            ptU = Q{i,j};
            Qhat = ptU;
            dif = diff(ptU);
            t = dif==0; 
            if any(t==0)
                Qhat(1,t)=-1;
                ptU(Qhat==-1)=[];
            end
         
            [hU, x0] = max(ptU); % edge contrast (intercept)
            mtU = ptU - hU;
            mt_lU = mtU(1:find(mtU==0));
            mt_rU = mtU(find(mtU==0):end);
            dtU = length(ptU);    % spatial scattering (slope)
            dU = (1:dtU) - x0;
            dlU = dU(dU<=0);
            drU = dU(dU>=0);
            klU = dlU'\mt_lU'; %linear fitting for left-side of triangle model
            krU = drU'\mt_rU'; %linear fitting for right-side of triangle model
            hH = alpha^(1/2)*hU;
            dlH = abs((1/alpha)^(1/2)*dlU(1));
            drH = (1/alpha)^(1/2)*drU(end);
            klH = alpha*klU;
            krH = alpha*krU;
            mx_lH = klH.*dlU+hH;
            mx_rH = krH.*drU+hH;
            dxlU = length(dlU);
            for r = 1:dxlU
                if abs(dlU(r)) > dlH
                    mx_lH(r)  = 0;
                else
                end
            end
            dxrU = length(drU);
            for r = 1:dxrU
                if drU(r) > drH
                    mx_rH(r)  = 0;
                else
                end
            end
            temp = abs([mx_lH,mx_rH(2:end)]);
            Qhat(Qhat~=-1) = temp;
            v = [double(t),0];
            l0 = length(v);
            temp1 = zeros(1,l0);
            for r = 1:l0-1
                if v(r)==1 && v(r+1)==1
                    temp1(r) = r+1;
                elseif v(r)==1 && v(r+1)==0
                    temp1(r) = r+1;
                end
            end
            temp1(temp1==0)=[];
            v(temp1)=-1;
            v(v==-1)=[];
            y = Qhat;
            y(y>0)=0; y(y<0)=1;
            f = find(diff([0,y,0]==1));
            u = f(2:2:end)-f(1:2:end-1);
            Qhat(Qhat==-1) = repelem(temp(v==1),u); 
            ptH{i,j} = Qhat;
            [~, xu] = max(p{i,j});
            [~, xh] = max(ptH{i,j});
            d = xu - xh;
            dU = length(p{i,j});
            z = zeros(1,dU);
            for r = xh:l0
                z(1,r+d) = ptH{i,j}(1,r);
            end
            for r = 1:(xh-1)
                z(1,r+d) = ptH{i,j}(1,r);
            end
            ptH{i,j} = z;
        else
        end
    end
end

% combine ptH and pgH
ph = ptH;
for i=1:a
    for j=1:b
        if size(ptH{i,j},1)==0
            ph{i,j} = pgH{i,j};
        else
        end
    end
end

