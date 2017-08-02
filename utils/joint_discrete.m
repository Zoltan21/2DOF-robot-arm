%the purpose of this script is to make discrete time simulation of the 2
%joint robot arm model

N = 70;%nr of iterations
%the sampling time
Ts = 0.045;
%the equations for the system
MSS = dynamic_evaluated_model.M;
BSS = dynamic_evaluated_model.B;
CSS = dynamic_evaluated_model.C;
GSS = dynamic_evaluated_model.G;
FSS = dynamic_evaluated_model.F;

syms q1 q2 dq1 dq2 tau1 tau2 'real'
q=[q1 q2]';
dq=[dq1 dq2]';
tau=[tau1 tau2]';
%the continuous form
ddq= - inv(MSS)*CSS*dq.^2 - (MSS\BSS +MSS\FSS )*dq -MSS\GSS' + MSS\tau;
%state space form
dx = [dq1
      dq2
      ddq];
%discrete form
xknew = Ts*dx + [q1 q2 dq1 q2]';
dxFunct = matlabFunction(dx);
clear xknew X
%initial conditions
q1 = data(1,1);
%q1=0;
q2 = data(2,1);
%q2=0;
dq1 = 0;
dq2 = 0;
tau1 =0;
tau2 =0;
X(:,1) = [q1 q2 dq1 dq2]';
for count=1:N
    %get the new set
    tau = lqr_gain_discrete*X(:,count);
    tau1 = -tau(1);
    tau2 = -tau(2);
    %xknew = xknewFunct(dq1,dq2,q1,q2,tau1,tau2);
    
    xknew = Ts*eval(dx)+[q1 q2 dq1 dq2]';
    q1 = xknew(1);
    q2 = xknew(2);
    dq1 = xknew(3);
    dq2 = xknew(4);
    %save the data
    X(:,count+1) = xknew;
end
%% plotting the results
time = 0:Ts:Ts*(length(X)-1);

% plot(time,X(1,:));
% figure
% plot(time,X(2,:));
% figure

%% comparing the results

figure
plot(time(1:end-1),X(1,2:end),'b-.',time(1:end-1),data(1,1:N),'r','LineWidth',1.5);grid;
xlabel='time[s]';ylabel= 'angle[rad]';
figure
plot(time(1:end-1),X(2,2:end),'b-.',time(1:end-1),data(2,1:N),'r','LineWidth',1.5);grid;
