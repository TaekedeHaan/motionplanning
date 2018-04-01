function u = controlLaw(posRi, Mv, Lv)
k = 5;


 

% determine centroid
if Mv == 0
    Cv = [0 , 0]'; % ?
else
    Cv = Lv / Mv; 
end

% compute setpoint
u = k * (Cv - posRi);

% check for nan
if any(isnan(u))
    disp('Nan in controlLaw...')
end

