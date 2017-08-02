%main
%% initialization function
Kp1 = 1;
Kp2 = 1;
Ki1 = 0.15;
Ki2 = 0.15;
%% simulation data
res = fminsearch(@objectiveFun, [Kp1 Kp2 Ki1 Ki2]);

%plotting the results obtained with the optimal params
run_LQR_servo

