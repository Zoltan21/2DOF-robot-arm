%main
%% initialization function
global erzsi
global PID
global iter
iter=0;
PID = [0 0 0 0 0 0];
erzsi=0;
Kp1 = 2.7071;
Kp2 = 1.4502;
Ki1 = 1.2022;
Ki2 = 1.1422;
Kd1 = 0.1022;
Kd2 = 0.1022;

% Kp1 = 2.7071;
% Kp2 = 1.4502;
% Ki1 = 1.2022;
% Ki2 = 1.1422;
% Kd1 = 0.1022;
% Kd2 = 0.1022;

% Kp1 = 5.07;
% Kp2 = 2.7;
% Ki1 = 8.5;
% Ki2 = 7.3;
% Kd1 = 0.17;
% Kd2 = 0.21;
%% simulation data
options = optimset('MaxFunEvals',10);
%res = fminsearch(@objectiveFunRealApp, [Kp1 Kp2 Ki1 Ki2 Kd1 Kd2],options);
%res = fminsearch(@objectiveFun, [Kp1 Kp2 Ki1 Ki2 Kd1 Kd2]);
theV = [Kp1 Kp2 Ki1 Ki2 Kd1 Kd2;
        Kp1-0.1 Kp2 Ki1 Ki2 Kd1 Kd2;
        Kp1 Kp2-0.1 Ki1 Ki2 Kd1 Kd2;
        Kp1 Kp2 Ki1-0.1 Ki2 Kd1 Kd2;
        Kp1 Kp2 Ki1 Ki2-0.1 Kd1 Kd2;
        Kp1 Kp2 Ki1 Ki2 Kd1-0.1 Kd2;
        Kp1 Kp2 Ki1 Ki2 Kd1 Kd2-0.1];
[res,fmin,fmins]= MyNelderMeadReal(@objectiveFun,0.004,theV');
%[res,fmin,fmins]= MyNelderMeadReal(@objectiveFunRealApp,0.04,theV');
%plotting the results obtained with the optimal params
run_LQR_servo

