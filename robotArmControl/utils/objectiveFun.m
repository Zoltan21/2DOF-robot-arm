function err = objectiveFun(params)
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
%% simulation process
for i =1:cfg.N
    cfg.e(:,i) = cfg.ref(:,i)-cfg.x(1:2,i);
    cfg.eprim(:,i) = i^(1/3)*(cfg.e(:,i).^2);
    cfg.u(:,i) = calcPID(cfg.e,cfg.Ts,cfg.PID);
    cfg.x(:,i+1)= MyModel(cfg.x(:,i),cfg.u(:,i));    
end
%adding noise
aa = wgn(2,cfg.N,-45);
cfg.e = cfg.e + aa;

% err1 = (sum((cfg.e(1,:).^2)'));
% err2 = (sum((cfg.e(2,:).^2)'));
global erzsi
if length(erzsi)==100
    disp('alma');
end
uu = 7*((sum((cfg.e(1,:).^2)'))) + (sum((cfg.e(2,:).^2)'));
%err1 = sum(sum(cfg.eprim'));
err1=max(cfg.e(1,:).^2);
err2 = max(cfg.e(2,:).^2);
err = 10*(err1+err2) +uu;
global iter
iter=iter+1;
alma = sprintf('data%d', iter);
save(alma)
global PID
params=[params(1) params(2) params(3) params(4) params(5) params(6)];
PID = [PID; params];
erzsi= [erzsi err];
end
