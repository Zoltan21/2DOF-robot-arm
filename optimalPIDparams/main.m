%main
%% initialization function
global erzsi
erzsi=0;
Kp1 = 2.7071;
Kp2 = 1.4502;
Ki1 = 1.2022;
Ki2 = 1.1422;
Kd1 = 0.1022;
Kd2 = 0.1022;
%% simulation data
res = fminsearch(@objectiveFun, [Kp1 Kp2 Ki1 Ki2 Kd1 Kd2]);

%plotting the results obtained with the optimal params
run_LQR_servo

