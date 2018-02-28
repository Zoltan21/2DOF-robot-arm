%plot the results
t = 0:Ts:Ts*(length(data)-1);
%% Tracking
if (length(q_ref)>2)
    figure
    plot(t,q_ref(1,:),'r--',t,data(1,:),'b','LineWidth',1.7);
    h_legend=legend('$q_{1ref}$','$q_{1real}$' ,2);
    set(h_legend,'FontSize',20,'Interpreter','latex');
    set(gca,'FontSize',20);
    xlabel('Time [s]');
    ylabel('Angles [rad]')
    xlim([0 t(end)]);
    grid
    figure
    plot(t,q_ref(2,:),'r--',t,data(2,:),'b','LineWidth',1.7);
    h_legend=legend('$q_{2ref}$','$q_{2real}$' ,2);
    set(h_legend,'FontSize',20,'Interpreter','latex');
    set(gca,'FontSize',20);
    xlabel('Time [s]');
    ylabel('Angles [rad]')
    xlim([0 t(end)]);
    grid
end