% closed loop dataflux for robot arm control
% Zoltan Nagy
% 20/12/2016
%% User Defined Parameters
delay = .045;                   % make sure sample faster than resolution
Ts = delay;                     % this is the actual sampling time
PWM_offset = 1000;              % the offset for the PWM, this means 0 voltage
N = 270;                         % nr of iterations
offsetang1 = 785;               % offset for the first joint angle
offsetang2 = 500;               % offset for the second joint
resang = 0.00577;               % one tic is equal to this in radian
%% Serial Communication
if exist('s')
    fclose(s)
    delete(s)
    clear s
end
%if you are using Windows, than you have to change this line
s = serial ('COM5');
%s = serial ('/dev/ttyUSB0');
%the baudrate for serial communication
set(s,'BaudRate',1000000);
fopen(s);
%% INIT communication protocol
SerialStart
% INIT read command
CycleRead = uint8(0);
CycleRead(1:6) = CycleRead;
CycleRead(1:6) = [ 170 3 255 254 7 245];
% INIT write command
writePWM = uint8(0);
writePWM(1:14) = writePWM;
writePWM(1:13) = [170 11 255 254 131 16 2 1 0 0 2 0 0];
%% Define Function Variables
time = 0;
data = [0;0];
u = [0;0];
count = 0;
STATES = [0 0 0 0]';
tau = [0 0]';
%% CONTROLLER PARAMETERS
q_ref = [0; 0];
% q_ref_track = [ones(1,90)*0.3, ones(1,90)*(-0.3),ones(1,90)*0
%         ones(1,70)*(-0.3), ones(1,70)*(0.3),ones(1,70)*(-0.3),ones(1,60)*(0)];
q_ref_track = qref_filtered;
the_P = 1;
%the_I = 0.4;
% the_I = 2;
the_I = 1;
%the_D = 0.3;
the_D = 0;
err = [0;0];
%% PID
cfg.PID.Kp1 = 2.7071;
cfg.PID.Kp2 = 1.4502;
cfg.PID.Ki1 = 0.0441;
cfg.PID.Ki2 = 0.0414;
%% Start loop
%start timer
tic
 while count<N
    q_ref = q_ref_track(:,count+1);
     %Read Data
    fwrite(s,CycleRead);
    data1 = fread(s,7);
    data2 = fread(s,7);
    %convert angles into radian format
    if(~isempty(data1)) %Make sure Data Type is Correct      
        count = count + 1;    
        data(:,count) = [(data1(5)*256 + data1(6)-offsetang1)*resang;(data2(5)*256 + data2(6)-offsetang2)*resang] ; %Extract 1st Data Element    
    end
    %the current angles
    q = data(:,count);
    %compute the angular velocities
    if(count == 1)
        dq = [0 0]';
    else
        dq = (data(:,count)-data(:,count-1))/Ts;
    end
    %get all the states in a vector
    state_x = [q; dq];
    %save states 
    STATES(:,count) = state_x;
    %compute control gain based on lqr
    %tau(:,count) = lqr_gain_discrete*state_x;
    err(:,count) = q_ref-data(:,count);
    tau(:,count)=calcPID(err,cfg.PID.Kp1,cfg.PID.Kp2,cfg.PID.Ki1,cfg.PID.Ki2);
    tau1 = tau(1,count);
    tau2 = tau(2,count);
    %convert torque into PWM
    PWM(1) = PWM_offset + Torque2PWM(tau1);
    PWM(2) = PWM_offset + Torque2PWM(tau2);
    %saturate the PWM, the range is in abs(PWM-PWM_offset) is between [50 600]
    if (abs(PWM(1)-PWM_offset))<50
        PWM(1) = 1000;
    else if (abs(PWM(1)-PWM_offset))>600
            if (PWM(1)>1000)
                PWM(1) = 1600;
            else
                PWM(1) = 400;
            end
        end
    end
    if abs((PWM(2)-PWM_offset))<50
        PWM(2) = 1000;
        else 
        if (abs(PWM(2)-PWM_offset))>600
            if (PWM(2)>1000)
                PWM(2) = 1600;
            else
                PWM(2) = 400;
            end
        end
    end
    % write PWM in the command
    writePWM(9:10) = GetCMD(PWM(1));
    writePWM(12:13) = GetCMD(PWM(2));
    crcM = mod(sum(bitcmp(writePWM(2:13))),256);
    writePWM(14) = crcM;
    %send command to the robot arm
    fwrite(s,writePWM); 
    %synchronizing
    time(count) = toc;
    u(:,count) = PWM;
    %real time synchronization
    if(count == 1)
        pause(delay);
    else
        while(time(count)<(time(count-1)+delay))
            time(count) = toc;
        end
    end 
end
%% stop the motors
writePWM(9:10) = GetCMD(1000);
writePWM(12:13) = GetCMD(1000);
crcM = mod(sum(bitcmp(writePWM(2:13))),256);
writePWM(14) = crcM;
fwrite(s,writePWM);
%Close Serial COM Port and Delete useless Variables
fclose(s);
clear count dat max min  s serialPort ;
disp('Session Terminated...');

%% Analyse the results
t = 0:Ts:Ts*(length(data)-1);
plot(t,data(1,:),'r',t,data(2,:),'b--','LineWidth',2);
xlabel('time (s)');
ylabel('angle (rad)');
legend('first joint q1','second joint q2');
grid
%% Tracking
if (length(q_ref_track)>2)
    figure
    plot(t,data(1,:),'r',t,q_ref_track(1,:),'g--','LineWidth',2);
    xlabel('time (s)');
    ylabel('angle (rad)');
    legend('first joint q1','reference for q1');
    grid
    figure
    plot(t,data(2,:),'r',t,q_ref_track(2,:),'g--','LineWidth',2);
    xlabel('time (s)');
    ylabel('angle (rad)');
    legend('second joint q2','reference for q2');
    grid
end
