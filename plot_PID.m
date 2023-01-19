function [] = plot_PID(t,r,y)
%PLOT_PID Plot PID result
%   t - time axis
%   r - input
%   y - output

    f4 = figure(4);
    f4.Position = [400 100 700 500]; 
    
    subplot(3,1,1)
    plot(t/60,y(:,1));
    hold on;
    plot(t/60,r(1,:),'--');
    hold off;
    xlim([0 max(t/60)]);
    legend('\theta_y','r_1')
    set(gca,'FontSize',13)
    
    subplot(3,1,2)
    plot(t/60,y(:,2));
    hold on;
    plot(t/60,r(2,:),'--');
    hold off;
    xlim([0 max(t/60)]);
    legend('\theta_p','r_2')
    set(gca,'FontSize',13)
    
    subplot(3,1,3)
    plot(t/60,y(:,3));
    hold on;
    plot(t/60,r(3,:),'--');
    hold off;
    xlim([0 max(t/60)]);
    legend('\theta_r','r_3')
    set(gca,'FontSize',13)
    
    han=axes(f4,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,'Amplitude (rad)');
    xlabel(han,'Time (min)');
    han.FontSize = 15;
end

