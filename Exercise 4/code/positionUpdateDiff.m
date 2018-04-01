function posNew = positionUpdateDiff(posOld, u, par )
%CALCULATEWHEELSPEEDS This function computes the motor velocities for a differential driven robot

vx = u(:,1) * cos(posOld(3));
vy = u(:,1) * sin(posOld(3));
omega = u(:,2);
velocity = [vx, vy, omega];

% wheelRadius = par.wheelRadius; %[m]
% halfWheelbase = par.interWheelDistance/2; %[m]

% LeftWheelVelocity = 1/wheelRadius * (vu - halfWheelbase * omega);
% RightWheelVelocity = 1/wheelRadius * (vu + halfWheelbase * omega);

posNew = posOld + par.dt * velocity;
end
