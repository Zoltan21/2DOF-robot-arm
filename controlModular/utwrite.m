function utwrite(tau)
% tau = torque in [-1.18, 1.18] 
% Input u = PWM ratio in [0, 2000], 1000 zero PWM, <1000 counter clockwise,>1000 clockwise
% limits are intrduced u=PWM in [400, 1600]!!!!
global utip

tau1 = tau(1);
tau2 = tau(2);
%convert torque into PWM
PWM(1) = utip.PWM_offset + Torque2PWM(tau1);
PWM(2) = utip.PWM_offset + Torque2PWM(tau2);
%saturate the PWM, the range is in abs(PWM-PWM_offset) is between [50 600]
if (abs(PWM(1)-utip.PWM_offset))<50
   PWM(1) = 1000;
else if (abs(PWM(1)-utip.PWM_offset))>600
        if (PWM(1)>1000)
           PWM(1) = 1600;
        else
           PWM(1) = 400;
        end
    end
end
if abs((PWM(2)-utip.PWM_offset))<50
   PWM(2) = 1000;
else 
   if (abs(PWM(2)-utip.PWM_offset))>600
       if (PWM(2)>1000)
           PWM(2) = 1600;
       else
           PWM(2) = 400;
       end
   end
end
% write PWM in the command
utip.writePWM(9:10) = GetCMD(PWM(1));
utip.writePWM(12:13) = GetCMD(PWM(2));
crcM = mod(sum(bitcmp(utip.writePWM(2:13))),256);
utip.writePWM(14) = crcM;
%send command to the robot arm
fwrite(utip.s,utip.writePWM); 

