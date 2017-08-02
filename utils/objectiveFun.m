function err = objectiveFun(params)
params=abs(params);
%params(3:4)= 0.15;

% params(1:2)=10;
% model data initialization
cfg.Ts = 0.045;
cfg.x = [0 0 0 0]';
cfg.ref = [ones(1,270)*1
        ones(1,270)*(-0.5)];
cfg.u= [0;0];
cfg.N = 270;
cfg.e = cfg.ref(:,1)-cfg.x(1:2);
%% PID controller initial parameters
cfg.PID.Kp1 = params(1);
cfg.PID.Kp2 = params(2);
cfg.PID.Ki1 = params(3);
cfg.PID.Ki2 = params(4);
%% simulation process
for i =1:cfg.N
    cfg.e(:,i+1) = cfg.ref(:,i)-cfg.x(1:2,i);
    cfg.u(:,i) = calcPID(cfg.e,cfg.PID.Kp1,cfg.PID.Kp2,cfg.PID.Ki1,cfg.PID.Ki2);
    cfg.x(:,i+1)= MyModel(cfg.x(:,i),cfg.u(:,i));
end
err = sum((sum((cfg.e.^2)')))
end