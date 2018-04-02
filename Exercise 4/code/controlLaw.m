function u = controlLaw(posRi, Mv, Lv)
k = 5;


 

% determine centroid
if Mv == 0
    u =0; 
else
    Cv = Lv / Mv; 
    
    % compute setpoint
    u = k * (Cv - posRi);
end



% check for nan
if any(isnan(u))
    disp('Nan in controlLaw...')
end

