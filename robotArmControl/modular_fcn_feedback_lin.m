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
% cfg.PID.Kp1 = 2.7071;
% cfg.PID.Kp2 = 1.4502;
% cfg.PID.Ki1 = 1.2022;
% cfg.PID.Ki2 = 1.1422;
% cfg.PID.Kd1 = 0.1022;
% cfg.PID.Kd2 = 0.1022;

%%
%the refeence
t = 0:Ts:((N-1)*Ts);
ref = [0.6*sin(t)
       0.5*sin(t)];
dref = [0.6*cos(t)
        0.5*cos(t)];
ddref = -ref;
time(1) = 0;
%feedback linearization
Kx = [36 0 13 0
      0 36 0 13];
Kz = [0.6 0.6];
data=[0;0];
zk = [-data(1)+ref(1,1); -data(2)+ref(2,1)]*Ts;
disp('Session started');
tic % start time counter
for k = 1:N,
    % time(k)
    data(:,k) = utread;
    %error comparing to the reference
    err(:,k) = q_ref(:,k)-data(:,k);
    %get the angular velocity
    if(k == 1)
        dq = [0 0]';
    else
        dq = (data(:,k)-data(:,k-1))/Ts;
    end
    %associate all the states to one variables
    DATA(:,k) = [data(:,k);dq];
    %get the integral of the error
    zk(:,k+1) = zk(:,k) + Ts*[ref(1,k)-DATA(1,k); ref(2,k)-DATA(2,k)];
    %the state feedback control
    u(:,k) = -Kx*(-DATA(:,k)+[ref(:,k);dref(:,k)]) + Kz*zk(:,k);
    tau(:,k) = calcFeedCom(DATA(:,k),ddref(:,k),u(:,k));
    utwrite(tau(:,k));
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
q_ref= ref
plot_res