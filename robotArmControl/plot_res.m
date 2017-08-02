%plot the results
t = 0:Ts:Ts*(length(data)-1);
%% Tracking
if (length(q_ref)>2)
    figure
    plot(t,data(1,:),'r',t,q_ref(1,:),'g--','LineWidth',2);
    xlabel('time (s)');
    ylabel('angle (rad)');
    legend('first joint q1','reference for q1');
    grid
    figure
    plot(t,data(2,:),'r',t,q_ref(2,:),'g--','LineWidth',2);
    xlabel('time (s)');
    ylabel('angle (rad)');
    legend('second joint q2','reference for q2');
    grid
end