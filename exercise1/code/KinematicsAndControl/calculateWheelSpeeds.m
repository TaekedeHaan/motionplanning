function [ LeftWheelVelocity, RightWheelVelocity ] = calculateWheelSpeeds( vu, omega, parameters )
%CALCULATEWHEELSPEEDS This function computes the motor velocities for a differential driven robot

wheelRadius = parameters.wheelRadius;
halfWheelbase = parameters.interWheelDistance/2;

r = 0.5; %[m]
LeftWheelVelocity = 2 * pi; %[rad/s]
RightWheelVelocity = (r + halfWheelbase)/(r - halfWheelbase) * LeftWheelVelocity;
end
