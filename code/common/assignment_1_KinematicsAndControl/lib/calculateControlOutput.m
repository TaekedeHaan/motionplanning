function [ vu, omega ] = calculateControlOutput( robotPose, goalPose, parameters )
%CALCULATECONTROLOUTPUT This function computes the motor velocities for a differential driven robot

% current robot position and orientation
x = robotPose(1);
y = robotPose(2);
theta = robotPose(3);

% goal position and orientation
xg = goalPose(1);
yg = goalPose(2);
thetag = goalPose(3);

% compute control quantities
rho = sqrt((xg-x)^2+(yg-y)^2);  % pythagoras theorem, sqrt(dx^2 + dy^2)
lambda = atan2(yg-y, xg-x);     % angle of the vector pointing from the robot to the goal in the inertial frame

alpha = lambda - theta;         % angle of the vector pointing from the robot to the goal in the robot frame
alpha = normalizeAngle(alpha);

beta = lambda + thetag;
beta = normalizeAngle(beta);

% Task 3: backwards controller
direction = 1; %default direnction is forward
if parameters.backwardAllowed && (abs(alpha) > (1/2 * pi))
    alpha = normalizeAngle(alpha + pi);
    direction = -1;
end

% the following paramerters should be used:
% Task 2:
vu = direction * parameters.Krho * rho; % [m/s]
omega = parameters.Kalpha * alpha + parameters.Kbeta * beta; % [rad/s]

if parameters.useConstantSpeed
    vu1 = vu;
    vu = direction * parameters.constantSpeed;
    omega1 = omega;
    omega = omega1 * vu/(vu1);
end
end

