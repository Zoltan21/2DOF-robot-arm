function uPID= calcPID(e,Kp1,Kp2,Ki1,Ki2)
    
    uMAX = 1.18;
    uPID = [Kp1; Kp2].*e(:,end) + [Ki1; Ki2].*(sum(e'))';
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
    
end