%modular script for a 2DOF robot arm
%Date: 2017.08.02
%Zoltan Nagy
%clear
%clc
%%
time = [];                       % time vector init
data = [0;0];                    % data vector init
N = 270;                         % number of iterations
Ts = 0.045;                      % sampling time               
utstart('5');                    % set the COM port
%%
time(1) = 0;
disp('Session started');
tic % start time counter
for k = 1:N,
    data(:,k) = utread; % read input
    u(:,k) = [0;0];     % the control algorithm goes here
    utwrite(u(:,k));    % send control command 
    %synchronize, wait for next sample time
    time(k+1) = toc;
    while(time(k+1)<(time(k)+Ts))
        time(k+1) = toc;
    end  
end
% send 0 torque, to make sure no torque will be applied, after closing the
% sequence
utwrite([0;0]);

%%
utstop;

%% plotting the results
plot_res