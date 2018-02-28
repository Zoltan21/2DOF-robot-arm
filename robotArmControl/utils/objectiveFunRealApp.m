function Err = objectiveFunRealApp(params)
params=abs(params);
%params(3:4)= 0.15;

% params(1:2)=10;
% model data initialization
cfg.Ts = 0.045;
load referenceTraj2
cfg.ref = q_ref;
cfg.x = [cfg.ref(1,1) cfg.ref(2,1) 0 0]';
% cfg.ref = [ones(1,270)*1
%         ones(1,270)*(-0.5)];
cfg.u= [0;0];
cfg.N = 270;
cfg.e = cfg.ref(:,1)-cfg.x(1:2);
cfg.eprim = cfg.e.^2;
%% PID controller initial parameters
cfg.PID.Kp1 = params(1);
cfg.PID.Kp2 = params(2);
cfg.PID.Ki1 = params(3);
cfg.PID.Ki2 = params(4);
cfg.PID.Kd1 = params(5);
cfg.PID.Kd2 = params(6);
%% real process
modular_fcn
cfg.e=err;
uu = 7*((sum((cfg.e(1,:).^2)'))) + (sum((cfg.e(2,:).^2)'));
%err1 = sum(sum(cfg.eprim'));
err1=max(cfg.e(1,:).^2);
err2 = max(cfg.e(2,:).^2);
Err = 10*(err1+err2) +uu;
global erzsi
global iter
iter=iter+1;
alma = sprintf('data%d', iter);
save(alma)
erzsi= [erzsi Err];
end
