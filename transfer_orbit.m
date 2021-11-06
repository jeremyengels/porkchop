function [pos,vel] = transfer_orbit(time_input,initial_pos,initial_vel,mu)
%     % () is the 2-norm of ()_vec
% 
%     r_vec = initial_pos';
%     r = norm(r_vec);
%     v_vec = initial_vel';
%     v = norm(v_vec);
% 
%     % calculate orbital elements given state vector
%     h_vec = cross(r_vec,v_vec);
%     h = norm(h_vec);
%     
%     % end way to get e
%     e_vec = cross(v_vec,h_vec)/mu - r_vec/r;
%     e = norm(e_vec);
%     
%     theta = acos((h^2/(mu*r) - 1)/e);
%     i = acos(h_vec(3)/h);
%     N_vec = cross([0 0 1]',h_vec);
%     N = norm(N_vec);
%     Omega = acos(N_vec(3)/N);
%     omega = acos(e_vec'*N_vec/(e * N));
%     a = h^2/mu * 1/(1 - e^2);

    [h,e,Omega,i,omega,theta,a] = coe_from_sv(initial_pos,initial_vel,mu);
    T = 2*pi*sqrt(a^3/mu);
    
    % backwards kepler to get time-since-perigee
    E = 2*atan(sqrt((1 - e)/(1 + e)) * tan(theta/2));
    Me = E - e*sin(E);
    time_since_perigee = Me*T/(2*pi);
    t = time_input - time_input(1) + time_since_perigee;
    
    Me = 2*pi/T * t;
    E = kepler(e,Me,1e-6);
    theta = 2*atan(tan(E/2) * sqrt((1 + e)/(1 - e)));   % rad
    
    
    % position and velocity in perifocal coord. frame
    r_PF = h^2./(mu*(1 + e*cos(theta))) ...
        .* [cos(theta); sin(theta); zeros(size(theta))];
    v_PF = mu/h * [-sin(theta); e + cos(theta); zeros(size(theta))];
    
    % transform perifocal to heliocentric equatorial system
    R1 = EulerRotation('z',-omega);
    R2 = EulerRotation('x',-i);
    R3 = EulerRotation('z',-Omega);
    
    r_HEC = R3*R2*R1*r_PF;
    v_HEC = R3*R2*R1*v_PF;
    
    pos = r_HEC';
    vel = v_HEC';
    
end