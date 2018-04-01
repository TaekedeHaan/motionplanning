function [ LeftWheelVelocity, RightWheelVelocity ] = positionUpdateDiff( vu, omega, parameters )
%CALCULATEWHEELSPEEDS This function computes the motor velocities for a differential driven robot

wheelRadius = 0.05; %[m]
halfWheelbase = 0.20/2; %[m]

LeftWheelVelocity = 1/wheelRadius * (vu - halfWheelbase * omega);
RightWheelVelocity = 1/wheelRadius * (vu + halfWheelbase * omega);

%(r + halfWheelbase)/(r - halfWheelbase) * LeftWheelVelocity;
end
