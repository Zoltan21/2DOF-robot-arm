%PID control for a 2DOF robot arm
%Date: 2017.08.02
%Zoltan Nagy
clear
clc
%%
time = [];                       % time vector init
data = [0;0];                       % data vector init
N = 270;                         % number of iterations
Ts = 0.045;
err = [0;0];
utstart('5');
%% PID
cfg.PID.Kp1 = 2.7071;
cfg.PID.Kp2 = 1.4502;
cfg.PID.Ki1 = 0.0441;
cfg.PID.Ki2 = 0.0414;
%reftraj
% q_ref = [ones(1,180)*0.3,ones(1,90)*0
%          ones(1,140)*(-0.3),ones(1,70)*(-0.3),ones(1,60)*(0)];
load referenceTraj
q_ref = [q_ref(:,1:2:end) q_ref(:,end:-2:1)];
%%
time(1) = 0;
disp('Session started');
tic % start time counter
for k = 1:N,
    % time(k)
    data(:,k) = utread;
    %error comparing to the reference
    err(:,k) = q_ref(:,k)-data(:,k);
    %simple constant input, here goes the control algorithm
    u(:,k) = calcPID(err,cfg.PID.Kp1,cfg.PID.Kp2,cfg.PID.Ki1,cfg.PID.Ki2);
    %u(:,k) = [0;0];
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