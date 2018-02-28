function [] = MyPlot(f, limits)

[X1,X2] = meshgrid(limits(1):0.05:limits(2));
for i = 1:length(X1)
    for j = 1:length(X1)
        F(i,j) = f([X1(i,j),X2(i,j)]);
    end
end
contour(X1,X2,F);
end