function dynamic_model = CollectModelCoefficients( Qm )
% the dynamic model in a state space form, where
% Qm = M(q)*ddq + B(q)*dq + C(q)*dq^2 + G(q)
% Qm is the torque, q - the angle, dq - angular velocity of the joint
% ddq - angular acceleration -- they
% are vectors, M(q),B(q,dq),C(q) - n*n matrix, G(q) n*1 matrix
% n is the number of joints
%this function returns a structure which contains the M,B,C,G matrices and
%the res - the result, which should be a vector of zeros if the collection
%was correct.

%#define constants
DDQL=4;
DQL=3;
DQL_2=5;
QL=2;
BL=2;
N=length(Qm);
%symbolic constants
q = sym('q',[1 N]);
dq = sym('dq',[1 N]);
ddq = sym('ddq',[1 N]);
syms g 'real'
syms q1 q2 q3 q4 q5 q6 q7 L1 L2 L3 L4 L5 L6 L7  'real'
syms dq1 dq2 dq3 dq4 dq5 dq6 dq7 ddq1 ddq2 ddq3 ddq4 ddq5 ddq6 ddq7 'real'
syms I1x I1y I1z I2x I2y I2z I3x I3y I3z 'real'
syms I4x I4y I4z I5x I5y I5z I6x I6y I6z I7x I7y I7z 'real'
syms M1 M2 M3 M4 M5 M6 M7 'real'

%for the linear case
syms q01 q02 q03 dq01 dq02 dq03 ddq01 ddq02 ddq03 'real'

%number of joints

for i=1:N
    %i
    stringEq=Qm(i);
    for j=1:N
        stringEq=char(collect(sym(stringEq),ddq(j)));
        %check if not empty
        aux=findstr(stringEq,char(ddq(j)));
        if ~isempty(aux)
            M(i,j) = sym(stringEq(1:aux-BL));
            stringEq = stringEq(aux+DDQL:end);
        else
            M(i,j) = sym(0);
        end        
    end
    %at this time stringEq does not contains ddq elements
    
    %collect the ^2 terms
    
    
    for j=1:N
        if (length(stringEq)>1)
            stringEq=char(collect(sym(stringEq),dq(j)));
        end
        aux=findstr(stringEq,char(dq(j)^2));
        if ~isempty(aux)
            while((stringEq(aux(1))~=' '))
                if (aux==length(stringEq))
                    stringEq=[stringEq ' '];
                end
                aux(1)=aux(1)+1;
            end
            
            C(i,j) = sym(StringCutter(stringEq(1:aux(1)),char(dq(j)^2)));
            
            stringEq = stringEq(aux(1):end);

        else
            C(i,j)=sym(0);
        end
    end
    
    for j=1:N
        if (length(stringEq)>1)
            stringEq=char(collect(sym(stringEq),dq(j)));
        end
        aux=findstr(stringEq,char(dq(j)));
        if ~isempty(aux)
            B(i,j) = sym(stringEq(1:aux(1)-BL));
            if((aux(1)+DQL)<=length(stringEq))
                stringEq = stringEq(aux(1)+DQL:end);
            else
                stringEq=sym(0);
            end
        else
            B(i,j)=sym(0);
        end
    end
    
    
    %the remaining part only contains q-s
    if (length(stringEq)>1)
        G(i)=sym(stringEq);
    else
        G(i)=sym(0);
    end
end

%verification
QmNew=M*ddq' + B*dq' + C*(dq.^2)' + G';
verify=Qm-QmNew;
res=simplify(verify);
res;

dynamic_model.M=M;
dynamic_model.B=B;
dynamic_model.C=C;
dynamic_model.G=G;
dynamic_model.res=res;

end


