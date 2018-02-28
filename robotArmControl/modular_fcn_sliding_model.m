%PID control for a 2DOF robot arm
%Date: 2017.08.02
%Zoltan Nagy
%clear
%clc
%%
time = [];                       % time vector init
data = [0;0];                       % data vector init
N = 270;                         % number of iterations
Ts = 0.045;
err = [0;0];
utstart('5');
%% PID
G =  @(q1,q2)[-1.7764e-20*sin(q1)*(1.0217e19*cos(q2)+7.4761e18)
                            -0.18149*cos(q1)*sin(q2)];
D = @(q1,q2)[ 0.003515*cos(q2)+0.000925*cos(q2)^2+0.026254,        0
                                                 0, 0.023625];
C = @(q1,q2,q1p,q2p)[ 0.24-0.0017575*q2p*sin(q2)-0.0004625*q2p*sin(2.0*q2),-0.0004625*q1p*sin(2.0*q2)-0.0017575*q1p*sin(q2)
        0.0004625*q1p*sin(2.0*q2)+0.0017575*q1p*sin(q2),                                             0.16];
Ks1 = 0.2;
Ks2 = 0.2;
Beta = 0.3;
Lambda1=10;% sliding surface dynamics
Lambda2=10;% sliding surface dynamics
Lambda=diag([Lambda1 Lambda2]);%
epsilon=0.01;
%positive feedback for vibration compensation
Kv = [0.25; 0.5];
MySign=@(s)s/(abs(s)+epsilon); 

t = 0:Ts:((N-1)*Ts);
ref = [0.6*sin(t)
       0.5*sin(t)];
dref = [0.6*cos(t)
        0.5*cos(t)];
ddref = -ref;
   q_ref=ref;
%q_ref = [q_ref(:,1:2:end) q_ref(:,end:-2:1)];
%%
time(1) = 0;
disp('Session started');
tic % start time counter
for k = 1:N,
    % time(k)
    data(:,k) = utread;
    if k==1
        qprim(:,k)=[0;0];
        qprim_f(:,k)=[0;0];
    else
        qprim(:,k) = (data(:,k)-data(:,k-1))/Ts;
        qprim_f(:,k) = qprim(:,k-1)*Ts/0.2 - (-0.2+Ts)/0.2*qprim_f(:,k-1);
    end
   
    
    %error comparing to the reference
    %q_ref(:,k) = [0.7*sin(k*Ts*0.5);0.7*sin(k*Ts*0.5)];
    err(:,k) = -q_ref(:,k)+data(:,k);
    qrprim(:,k) = dref(:,k) - Lambda*err(:,k);
    qrsec(:,k) = ddref(:,k) - Lambda*(qprim_f(:,k)-dref(:,k));
    s = qprim_f(:,k)-qrprim(:,k);
    q1=data(1,k);
    q2=data(2,k);
    q1p = qprim_f(1,k);
    q2p = qprim_f(2,k);
    Tau(:,k) = D(q1,q2)*qrsec(:,k)+ C(q1,q2,q1p,q2p)*qrprim(:,k)+G(q1,q2);
    
    u(:,k) = Tau(:,k)-[Ks1*MySign(s(1));Ks2*MySign(s(2))]-Beta*s;
    u(:,k) = u(:,k)+Kv.*[q1p;q2p];
    utwrite(u(:,k));
    %synchronize, wait for next sample time
    time(k+1) = toc;
    while(time(k+1)<(time(k)+Ts))
        time(k+1) = toc;
    end  
end
utwrite([0;0]);

%%
utstop;

%% plotting the results
plot_res