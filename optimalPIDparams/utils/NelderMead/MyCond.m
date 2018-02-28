function res = MyCond(V,eps)

    res = 1;
    for i = 2:length(V(1,:))
        for j= 1:length(V(1,:))
            S(i-1,j)=sum((V(:,i)-V(:,j)).^2);
        end
    end
    Ss= sum(sum(S));
    if Ss<eps
        res = 0;
    end
end