function uPID= calcPID(e,Ts,PID)
    Kp1 = PID.Kp1;
    Kp2 = PID.Kp2;
    Ki1 = PID.Ki1;
    Ki2 = PID.Ki2;
    Kd1 = PID.Kd1;
    Kd2 = PID.Kd2;
    uMAX = 1.18;
    uMIN = 0.042;
    if length(e(1,:))>1
        uPID = [Kp1; Kp2].*e(:,end) + Ts*[Ki1; Ki2].*(sum(e'))' + [Kd1; Kd2].*(e(:,end)-e(:,end-1))/Ts;
    else
        uPID = [Kp1; Kp2].*e(:,end) + Ts*[Ki1; Ki2].*(sum(e'))';
    end
    %check if the control input exceeds the maximum applicable input
    % on the real system
    if uPID(1)> uMAX
        uPID(1) = uMAX;
    elseif uPID(1)<-uMAX
        uPID(1)=-uMAX;
    end
    
    if uPID(2)> uMAX
        uPID(2) = uMAX;
    elseif uPID(2)<-uMAX
        uPID(2)=-uMAX;
    end
    if abs(uPID(1))<uMIN
        uPID(1) = 0;
    end
    if abs(uPID(2))<uMIN
        uPID(2) = 0;
    end
    
end