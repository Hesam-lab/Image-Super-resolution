function alpha = estimateAlpha(x1,x2,y1,y2)
% the parameter alpha can be estimated by minimizing the histogram
% difference of Y and X.
nbins = 50;
up = 0.1;
down = 10e-10;
idx = cellfun(@isempty, y1);
y1(idx) = {0};
idx = cellfun(@isempty, y2);
y2(idx) = {0};
Y = cell2mat(y2) + cell2mat(y1);
h_y = histcounts(Y,nbins,'BinLimits',[down,up]);
y = h_y;
y = (y-min(y))./(max(y)-min(y));

idx = cellfun(@isempty, x1);
x1(idx) = {0};
idx = cellfun(@isempty, x2);
x2(idx) = {0};
X = cell2mat(x2) + cell2mat(x1);
a = 0:0.01:20;
r = length(a);
d = zeros(1,r-1);
for i = 2:r
X0 = a(i).*X;
x = histcounts(X0,nbins,'BinLimits',[down,up]);
x = (x-min(x))./(max(x)-min(x));
d(i-1) = rmse(y,x);
end
opt = (d==min(d));
alpha = a(opt);


