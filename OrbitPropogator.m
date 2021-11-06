function [pos,vel] = OrbitPropogator(time_JD,planet)

    % GM of sun
    mu = 1.327124e11;                           % [km^3 / s^2]
    
    % unit conversions
    AU2KM = 149597870.691;
    DEG2RAD = pi/180;
    ASEC2DEG = 0.000277778;
    ASEC2RAD = ASEC2DEG * DEG2RAD;
    
    switch planet
        case 'Earth'
            
            % J2000 orbital elements
            a = 1.00000011 * AU2KM;             % [km]
            e = 0.01671022;                     % [1]
            i = 0.00005 * DEG2RAD;              % [rad]
            Omega = -11.26064 * DEG2RAD;        % [rad]
            omega = 102.94719 * DEG2RAD;        % [rad]
            L = 100.46435 * DEG2RAD;            % [rad]
            T = 2*pi*sqrt(a^3 / mu);            % [s]
            
            % 1st order fit (via centennial rates)
            da = -0.00000005 * AU2KM;           % [km / JC]
            de = -0.00003804;                   % [1 / JC]
            di = -46.94 * ASEC2RAD;             % [rad / JC]
            dOmega = -18228.25 * ASEC2RAD;      % [rad / JC]
            domega = 1198.28 * ASEC2RAD;        % [rad / JC]
            dL = 129597740.63 * ASEC2RAD;       % [rad / JC]
            
        case 'Mars'
            
            a = 1.52366231 * AU2KM;
            e = 0.09341233;                     % eccentricity
            i = 1.85061 * DEG2RAD;               % inclination
            Omega = 49.57854 * DEG2RAD;          % RAAN
            omega = 336.04084 * DEG2RAD;         % argument of the perigee
            L = 355.45332 * DEG2RAD;             % mean longitude at J2000
            T = 2*pi*sqrt(a^3 / mu);

    end
    
    % mean anomaly at J2000
    M_J2000 = L - Omega - omega;
    
    time_J2000 = time_JD - 2451545.0;
    time_sec = time_J2000 * 86400;
     
    Me = M_J2000 + (2*pi/T) * time_sec;
    
    
    E = kepler(e,Me,1e-10);
    theta = 2*atan(tan(E/2) * sqrt((1 + e)/(1 - e)));   % rad
    
    % calculate specific angular momentum
    h = sqrt(a*mu*(1 - e^2));
    
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