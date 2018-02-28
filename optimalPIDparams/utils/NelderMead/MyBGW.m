function [Vsorted,Veval] = MyBGW(objF, V)
%getting the best, good and worst vertexes

for i =1:length(V)
    
    F(i) = objF(V(:,i));
    
end
[Veval,ind] = sort(F);
for i=1:length(V)
Vsorted(:,i) = V(:,ind(i));
end

end