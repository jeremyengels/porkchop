function [v1,v2,xfer_time_tild] = lambert_universal_variables(r1,r2,xfer_time,tm,mu)
    
    solved = false;
    psi_0 = 0;
    psi_u = 100;
    psi_l = -100;
    max_steps = 10;
    tol = 1e-6;
    
    r1_norm = norm(r1);
    r2_norm = norm(r2);
    
    gamma = (r1 * r2')/(r1_norm * r2_norm);
%     beta = tm * sqrt(1 - gamma^2);
    A = tm * sqrt(r1_norm * r2_norm * (1 + gamma));
    
    if A == 0
        disp('A = 0');
        return;
    end
    
    for i = 1:max_steps
        
        psi = psi_0;
        C2 = C2_stumpff(psi);
        C3 = C3_stumpff(psi);
        B = r1_norm + r2_norm + A * (psi * C2 - 1)/sqrt(C2);
        
        while A > 0 && B < 0
            psi_l = psi_l + pi;
            psi_0 = 0.5 * (psi_l + psi_u);
            psi = psi_0;
            C2 = C2_stumpff(psi);
            C3 = C3_stumpff(psi);
            B = r1_norm + r2_norm + A * (psi * C2 - 1)/sqrt(C2);
            disp('sign flipped')
        end
        disp(B);
        
        chi = sqrt(B/C2);
        xfer_time_tild = (chi^3 * C3 + A * sqrt(B))/sqrt(mu);
        
        % stopping condiiton
        if abs(xfer_time_tild - xfer_time) < tol
            solved = true;
            break;
        end
        
        % update psi values
        if xfer_time_tild <= xfer_time
            psi_l = psi;
        else
            psi_u = psi;
        end
        psi_0 = 0.5 * (psi_l + psi_u);
    end
    
    if solved == true
        F = 1 - B/r1;
        G = A * sqrt(B/mu);
        G_dot = 1 - B/r2;
    
        v1 = (r2 - r1*F)/G;
        v2 = (G_dot*r2 - r1)/G;
        disp('UV successfully solved')
    else
        v1 = zeros(3,1);
        v2 = zeros(3,1);
        disp('UV did not solve');
        disp(xfer_time);
        disp(xfer_time_tild);
    end
end


function C2 = C2_stumpff(psi)
    if psi > 0
        C2 = (1 - cos(sqrt(psi)))/psi;
    elseif psi < 0
        C2 = -(cosh(sqrt(-psi)) - 1)/psi;
    else
        C2 = 1/2;
    end
end

function C3 = C3_stumpff(psi)
    if psi > 0
        C3 = (sqrt(psi) - sin(sqrt(psi)))/sqrt(psi^3);
    elseif psi < 0
        C3 = (sinh(sqrt(-psi)) - sqrt(-psi))/(sqrt(-psi))^3;
    else
        C3 = 1/6;
    end
end