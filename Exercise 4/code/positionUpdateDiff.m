function posNew = positionUpdateDiff(posOld, u, par )
%CALCULATEWHEELSPEEDS This function computes the motor velocities for a differential driven robot

vx = u(:,1) .* cos(posOld(:,3));
vy = u(:,1) .* sin(posOld(:,3));
omega = u(:,2);
velocity = [vx, vy, omega];

% wheelRadius = par.wheelRadius; %[m]
% halfWheelbase = par.interWheelDistance/2; %[m]

% LeftWheelVelocity = 1/wheelRadius * (vu - halfWheelbase * omega);
% RightWheelVelocity = 1/wheelRadius * (vu + halfWheelbase * omega);

posNew = posOld + par.dt * velocity;

%check boundary conditions
xlb = min(par.boudary(:,1));
xub = max(par.boudary(:,1));
ylb = min(par.boudary(:,2));
yub = max(par.boudary(:,2));

for i =1:length(posNew)
    
    if posNew(i,1)< xlb
        posNew(i,1) = xlb;
    elseif posNew(i,1) > xub
        posNew(i,1) = xub;
    end
    
    if posNew(i,2)< ylb
        posNew(i,2) = ylb;
    elseif posNew(i,2) > yub
        posNew(i,2) = yub;
    end
        
end



end
