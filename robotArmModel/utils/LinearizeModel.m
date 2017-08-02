function linearized_model = LinearizeModel( Qm )
%linearize the equations
%using Jacobian
%ML is the coeffs of the ddq
%BL coeffs of dq
%DL coeffs of q
%GL free coeff
syms M1 M2 'real'
syms I1x I1y I1z I1xy I1xz I1yz I2x I2y I2z I2xy I2xz I2yz 'real'
syms  L1 L2 'real'
syms g 'real'
syms q01 q02 dq01 dq02 ddq01 ddq02 'real'

    q1=q01;
    q2=q02;

    dq1=dq01;
    dq2=dq02;

    ddq1=ddq01;
    ddq2=ddq02;


N=length(Qm);

%the x0 term
GL=eval(Qm);
clear q1 q2 dq1 dq2 ddq1 ddq2
syms q1 q2 dq1 dq2 ddq1 ddq2 'real'

for i=1:N
    %getting the derivative of each matrix
    %Qm(i)
    
    coeffM=jacobian(Qm(i),[q1 q2 dq1 dq2 ddq1 ddq2]);
    ML(i,1)=jacobian(Qm(i),ddq1);
    ML(i,2)=jacobian(Qm(i),ddq2);
    
    BL(i,1)=jacobian(Qm(i),dq1);
    BL(i,2)=jacobian(Qm(i),dq2);
    
    DL(i,1)=jacobian(Qm(i),q1);
    DL(i,2)=jacobian(Qm(i),q2);

    %give the x0 values
    q1=q01;
    q2=q02;

    dq1=dq01;
    dq2=dq02;

    ddq1=ddq01;
    ddq2=ddq02;
    
    ML(i,1)=eval(ML(i,1));
    ML(i,2)=eval(ML(i,2));
    
    BL(i,1)=eval(BL(i,1));
    BL(i,2)=eval(BL(i,2));
    
    DL(i,1)=eval(DL(i,1));
    DL(i,2)=eval(DL(i,2));

    clear q1 q2 dq1 dq2 ddq1 ddq2
    syms q1 q2 dq1 dq2 ddq1 ddq2 'real'

end

GL = GL + ML*[ddq01 ddq02]' + BL*[dq01 dq02]' + DL*[q01 q02]'; 
linearized_model.M=ML;
linearized_model.B=BL;
linearized_model.D=DL;
linearized_model.G=GL;

end

