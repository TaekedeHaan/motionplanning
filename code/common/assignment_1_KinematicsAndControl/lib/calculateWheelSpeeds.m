function [ LeftWheelVelocity, RightWheelVelocity ] = calculateWheelSpeeds( vu, omega, parameters )
%CALCULATEWHEELSPEEDS This function computes the motor velocities for a differential driven robot

wheelRadius = parameters.wheelRadius;
halfWheelbase = parameters.interWheelDistance/2;

LeftWheelVelocity = 1/wheelRadius * (vu - halfWheelbase * omega);
RightWheelVelocity = 1/wheelRadius * (vu + halfWheelbase * omega);

%(r + halfWheelbase)/(r - halfWheelbase) * LeftWheelVelocity;
end
