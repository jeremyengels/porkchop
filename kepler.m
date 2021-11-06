function E_out = kepler(e,Me,tol)
    % solves Kelper's equation E - esinE = Me via Newton's Method
    
    E_out = zeros(size(Me));
    
    for i = 1:length(Me)
        
        E = 0;
        E_new = 1;
        
        ind = 0;
        while abs(E - E_new) > tol

            E = E_new;
            f = E - e*sin(E) - Me(i);
            df = 1 - e*cos(E);

            E_new = E - f/df;
            ind = ind + 1;
            if ind > 100
%                 warning(['kepler timeout, i = ',num2str(i)]);
                break;
            end
        end
        
        E_out(i) = E;
    end
end