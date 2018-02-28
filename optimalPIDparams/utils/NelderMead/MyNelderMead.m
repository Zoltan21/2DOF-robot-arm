function [min,fmin,fmins] =  MyNelderMead(f, eps, V)
fmins=0;
cond = MyCond(V,eps);
%limits = [-6 6];
%MyPlot(f,limits);
%hold on;
k=0;
kmax=300;
while (cond)&&(k<kmax)
    k=k+1;
    [Vsorted,fsorted] = MyBGW(f,V);
    M = (sum(Vsorted(:,1:end-1)')/(length(Vsorted(1,:))-1))';
    W =Vsorted(:,end);
    fW = fsorted(end);
    R = 2*M-W;
    fR= f(R);
    if fR<fW
        E = 2*R-M;
        if f(E)<fR
            W = E;
            Vsorted(:,end)=W;
        else
            W = R;
            Vsorted(:,end)=W;
        end
    else
        C1 = (M+W)/2;
        C2 = (M+R)/2;
        if f(C1)<=f(C2)
            C = C1;
        else
            C = C2;
        end
        if f(C)<fW
            W = C;
            Vsorted(:,end)=W;
        else
            %shrinking
            S=[];
            for i=2:length(Vsorted(1,:))
                Vsorted(:,i) = Vsorted(:,1) +(Vsorted(:,i)-Vsorted(:,1))/2;
            end
        end
    end
    V = Vsorted;
    
    fmins = [fmins fsorted(1)];
    cond = MyCond(V,eps);
    %MyDrawVertex(V);
    %pause(0.1)
end
fmins= fmins(2:end);
min = V(:,1);
fmin = fsorted(1);

end

