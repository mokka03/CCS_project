function [] = plot_IO(t,u,y)
%PLOT_IO Plot the input and the output of the system
%   t - time axis
%   u - input
%   y - output

    %% Plot input
    f1 = figure(2);
    f1.Position = [0 100 700 500]; 
    subplot(4,1,1)
    plot(t,u(1,:))
    xlabel('Time (s)');
    ylabel('V_f (V)');
    set(gca,'FontSize',11);

    subplot(4,1,2)
    plot(t,u(2,:))
    xlabel('Time (s)');
    ylabel('V_b (V)');
    set(gca,'FontSize',11);

    subplot(4,1,3)
    plot(t,u(3,:))
    xlabel('Time (s)');
    ylabel('V_r (V)');
    set(gca,'FontSize',11);
    
    subplot(4,1,4)
    plot(t,u(4,:))
    xlabel('Time (s)');
    ylabel('V_l (V)');
    set(gca,'FontSize',11);

    %% Plot output
    f2 = figure(3);
    f2.Position = [580 100 700 500]; 
    subplot(3,1,1)
    plot(t,y(:,1))
    xlabel('Time (s)');
    ylabel('Yaw angle (rad)');
    set(gca,'FontSize',11);

    subplot(3,1,2)
    plot(t,y(:,2))
    xlabel('Time (s)');
    ylabel('Pitch angle (rad)');
    set(gca,'FontSize',11);

    subplot(3,1,3)
    plot(t,y(:,3))
    xlabel('Time (s)');
    ylabel('Roll angle (rad)');
    set(gca,'FontSize',11);
end

