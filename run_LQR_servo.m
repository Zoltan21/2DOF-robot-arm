
%PID control for a 2DOF robot arm
%Date: 2017.07.28
%Zoltan Nagy

%% model data initialization
cfg.Ts = 0.045;
cfg.x = [0 0 0 0]';
% cfg.ref = [ones(1,90)*1, ones(1,90)*(-1),ones(1,90)*0.5
%         ones(1,70)*(-0.5), ones(1,70)*(0.7),ones(1,70)*(-0.3),ones(1,60)*(-1)];
q_ref_track = [ones(1,90)*0.3, ones(1,90)*(-0.3),ones(1,90)*0.3
        ones(1,70)*(-0.3), ones(1,70)*(0.3),ones(1,70)*(-0.3),ones(1,60)*(-1)];

% cfg.ref = [ones(1,270)*1
%         ones(1,270)*(-0.5)];
cfg.u= [0;0];
cfg.N = 270;
cfg.e = cfg.ref(:,1)-cfg.x(1:2);
%% PID controller initial parameters
res=abs(res);
cfg.PID.Kp1 = res(1);
cfg.PID.Kp2 = res(2);
cfg.PID.Ki1 = res(3);
cfg.PID.Ki2 = res(4);
%% simulation process
for i =1:cfg.N
    cfg.e(:,i+1) = cfg.ref(:,i)-cfg.x(1:2,i);
    cfg.u(:,i) = calcPID(cfg.e,cfg.PID.Kp1,cfg.PID.Kp2,cfg.PID.Ki1,cfg.PID.Ki2);
    cfg.x(:,i+1)= MyModel(cfg.x(:,i),cfg.u(:,i));
end

t= 0:cfg.Ts:(cfg.Ts*(cfg.N-1));
%% plot angle 1
plot(t,cfg.ref(1,:), 'r--',t,cfg.x(1,1:end-1), 'b','LineWidth',1.7);
grid;
h_legend=legend('$q_{1ref}$','$q_{1sim}$' ,3);
set(h_legend,'FontSize',20,'Interpreter','latex');
set(gca,'FontSize',20);
xlabel('Time [s]');
ylabel('Angles [rad]')
xlim([0 12.20]);

%% plot angle 2
figure
plot(t,cfg.ref(2,:), 'r--',t,cfg.x(2,1:end-1), 'b','LineWidth',1.7);
grid;
h_legend=legend('$q_{2ref}$','$q_{2sim}$' ,2);
set(h_legend,'FontSize',20,'Interpreter','latex');
set(gca,'FontSize',20);
xlabel('Time [s]');
ylabel('Angles [rad]')
xlim([0 12.20]);

