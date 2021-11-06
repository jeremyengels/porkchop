clc; clear; close all;
plotdefaults(20,10,3)


date1 = juliandate('30-Jul-2020','dd-mm-yyyy');
date2 = juliandate('18-Feb-2021','dd-mm-yyyy');
% date2 = juliandate('30-Jul-2021','dd-mm-yyyy');


planet1 = 'Earth';
planet2 = 'Mars';
tm = 1;
m = 0;


% function [DV_1,DV_2] = interplanetary_transfer(date1,date2,planet1,planet2,tm)
    
    mu = 1.327124e11;       % km^3/s^2 (sun)
    
    xfer_time = date2 - date1;
    time_array = linspace(date1,date2,10000);
    
    % calculate the planet state vectors at each timestep
    [p1_pos,p1_vel] = OrbitPropogator(time_array,planet1);
    [p2_pos,p2_vel] = OrbitPropogator(time_array,planet2);
    
    % calculate initial and final spacecraft states
    r1 = p1_pos(1,:); 
    r2 = p2_pos(end,:);
    
    % solve lambert's problem for velocities
    [v1,v2,~,flag] = lambert(r1,r2,xfer_time*tm,m,mu);
%     [v1,v2,~] = lambert_universal_variables(r1,r2,xfer_time,tm,mu);
    
    % calculate transfer orbit
    [x_pos,x_vel] = transfer_orbit(time_array * 86400,r1,v1,mu);
    
    
    if flag < 0
        v1 = 1e10*ones(3,1);
        v2 = 1e10*ones(3,1);
        disp('lambert flag triggered');
    end
    
    DV_1 = norm(p1_vel(1,:) - v1)
    DV_2 = norm(p2_vel(end,:) - v2)
    
    
%     figure(1)
%     X = [p1_pos(:,1) p2_pos(:,1) pos_xfer(:,1)];
%     Y = [p1_pos(:,2) p2_pos(:,2) pos_xfer(:,2)];
%     Z = [p1_pos(:,3) p2_pos(:,3) pos_xfer(:,3)];
%     plot3(X,Y,Z,'.')
%     hold on
%     plot3(0,0,0,'x')
%     plot3(X(1,:),Y(1,:),Z(1,:),'o')
%     xlim(1e8*[-4 4])
%     ylim(1e8*[-4 4])
%     zlim(1e8*[-4 4])
%     xlabel('x')
%     ylabel('y')
%     zlabel('z')
%     grid
    
    figure(2)
    plot(p1_pos(:,1),p1_pos(:,2))
    hold on
    plot(p2_pos(:,1),p2_pos(:,2))
    plot(x_pos(:,1),x_pos(:,2))
    
    plot(p1_pos(1,1),p1_pos(1,2),'kx')
    plot(p2_pos(end,1),p2_pos(end,2),'kx')
    plot(0,0,'ko')
    
    axis(1e8*[-4 4 -4 4])
    axis square
    legend('Earth','Mars','M2020')
    title('Mars 2020 Trajectory')
    xlabel('km')
    ylabel('km')
%     
% end

