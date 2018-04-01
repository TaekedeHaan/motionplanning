function u = controlLaw(posRi, Mv, Lv)
k = 5;

% determine centroid
Cv = Lv / Mv; 

% compute setpoint
u = k * (Cv - posRi);

% check for nan
if any(isnan(u))
    disp('Nan in controlLaw...')
end

