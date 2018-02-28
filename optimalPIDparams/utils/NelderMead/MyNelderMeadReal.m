function [min,fmin,fmins] =  MyNelderMeadReal(f, eps, V)
fmins=0;
cond = MyCond(V,eps);
%limits = [-6 6];
%MyPlot(f,limits);
%hold on;
%shrinking flag
sr_flag=1;
k=0;
kmax=1000;
while (cond)&&(k<kmax)
    k=k+1
    if (sr_flag==1)
        if (k==1)
            [Vsorted,fsorted] = MyBGW(f,V);
        else
            V1=V(:,2:end);
            [Vsorted1,fsorted1] = MyBGW(f,V1);
            Vsorted = [Vsorted(:,1) Vsorted1];
            fsorted = [fsorted(1) fsorted1];
            %reordering
            [fsorted,ind] = sort(fsorted);
            for i=1:length(V)
                Vsorted(:,i) = V(:,ind(i));
            end
        end
        sr_flag=0;
    else
        [fsorted,ind] = sort(fsorted);
        for i=1:length(V)
            Vsorted(:,i) = V(:,ind(i));
        end
    end
    M = (sum(Vsorted(:,1:end-1)')/(length(Vsorted(1,:))-1))';
    W =Vsorted(:,end);
    fW = fsorted(end);
    R = 2*M-W;
    fR= f(R);
    if fR<fW
        E = 2*R-M;
        fE = f(E);
        if fE<fR
            W = E;
            Vsorted(:,end)=W;
            fsorted(end) = fE;
        else
            W = R;
            Vsorted(:,end)=W;
            fsorted(end) = fR;
        end
    else
        C1 = (M+W)/2;
        C2 = (M+R)/2;
        fC1 = f(C1);
        fC2 = f(C2);
        if fC1<=fC2
            C = C1;
            fC =fC1;
        else
            C = C2;
            fC = fC2;
        end
        if fC<fW
            W = C;
            Vsorted(:,end)=W;
            fsorted(end)=fC;
        else
            %shrinking
            S=[];
            for i=2:length(Vsorted(1,:))
                Vsorted(:,i) = Vsorted(:,1) +(Vsorted(:,i)-Vsorted(:,1))/2;
            end
            sr_flag=1;
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

