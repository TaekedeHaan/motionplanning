%% V-REP Simulation Exercise 3: Kinematic Control
% Tests the implemented control algorithm within a V-Rep simulation.

% In order to run the simulation:
%   - Start V-Rep
%   - Load the scene matlab/common/vrep/mooc_exercise.ttt
%   - Hit the run button
%   - Start this script

%% Reset (breaks everything...)
close all
%clear all
clc

%% Parameters setup
% plots
lineWidth = 3; %line width, used for graphs
fontSize = 14; %font size, used for graphs
colorBlue = [0, 0.4470, 0.7410]; % blue, used for plotting
colorGrey = 0.7*[1, 1, 1]; % grey, used for plotting
dim = [200,200,1.2*500,500];

testName = input('Ola, how would you llike to name this test? ');
testPID = input('Ola, would you like to test the PID controller (1) or test the constRev controller(2), or go full YOLO (3)? ');

constantSpeed = repmat(0.3, 1, 4); %[m/s] The speed used when constant speed option is on 

% controller parameters
if testPID == 1
    Krho = [0.5, 1, 0.5, 0.50];
    Kalpha = [1.5, 1.5, 3, 1.5];
    Kbeta = [-0.6, -0.6, -0.6, -1.2];

    backwardAllowed = [0 0 0 0]; %This boolean variable should switch the between the two controllers
    useConstantSpeed = [0 0 0 0]; %Turn on constant speed option
end

if testPID == 2
    Krho = [0.5, 0.5, 0.5, 0.5];
    Kalpha = [3, 3, 3, 3];
    Kbeta = [-0.6, -0.6, -0.6, -0.6];

    backwardAllowed = [0 1 0 1]; %This boolean variable should switch the between the two controllers
    useConstantSpeed = [0 0 1 1]; %Turn on constant speed option
end

if testPID == 3
    Krho = [0.5, 0.5, 0.5, 0.5];
    Kalpha = [3, 3, 3, 6];
    Kbeta = [-0.6, -0.6, -0.6, -0.6];

    backwardAllowed = [1 1 1 1]; %This boolean variable should switch the between the two controllers
    useConstantSpeed = [1 1 1 1]; %Turn on constant speed option

    constantSpeed = [0.3, 0.4, 0.2, 0.4]; %[m/s] The speed used when constant speed option is on 
end

% Set of goal poses
ngPoses = 8; %[-]
rgPoses = 1.5; %[m]

% Define parameters for Dijkstra and Dynamic Window Approach
parameters.dist_threshold= 0.25; %0.25 [m] threshold distance to goal
parameters.angle_threshold = 0.1; %0.1 [rad] threshold orientation to goal

disp(Kalpha + 5/3 * Kbeta - 2/pi * Krho);

%% Initialize connection with V-Rep
startup;
connection = simulation_setup();
connection = simulation_openConnection(connection, 0);
simulation_start(connection);

%% Get static data from V-Rep
bob_init(connection);

parameters.wheelDiameter = bob_getWheelDiameter(connection);
parameters.wheelRadius = parameters.wheelDiameter/2.0;
parameters.interWheelDistance = bob_getInterWheelDistance(connection);
parameters.scannerPoseWrtBob = bob_getScannerPose(connection);

% set ghost
bob_setTargetGhostPose(connection, -1, 0, 0);
bob_setTargetGhostVisible(connection, 1);

%% Goal poses
% generate goal poses
gposes = determine_poses(ngPoses, rgPoses);

% Plot goal poses
figure('Position',dim)
c = 0.5;
x = [gposes(:,1) + c * cos(gposes(:,3)), gposes(:,1) - c * cos(gposes(:,3))];
y = [gposes(:,2) + c * sin(gposes(:,3)), gposes(:,2) - c * sin(gposes(:,3))];
for i = 1:size(x,1)
    quiver(gposes(i,1),gposes(i,2),x(i,1)-x(i,2),y(i,1)-y(i,2),0.5, 'LineWidth',2*lineWidth, 'MarkerSize',50,'Color',colorGrey)
    hold on
end
plot(gposes(:,1), gposes(:,2),'o', 'LineWidth',lineWidth, 'MarkerSize',10,'Color', colorBlue);
grid minor;
axis([-1.2 * rgPoses, 1.2 * rgPoses, -1.2 * rgPoses, 1.2 * rgPoses])
title('Goal')
xlabel('x [m]')
ylabel('y [m]')
set(gca,'fontsize', fontSize + 3);
saveas(gcf, 'goal', 'jpg');
saveas(gcf, 'goal.eps', 'epsc');

%% Start simulation
nSimulations = size(Krho,2);
for simulation = 1:nSimulations
   
    disp('New controller')
    parameters.backwardAllowed = backwardAllowed(simulation);
    parameters.useConstantSpeed = useConstantSpeed(simulation);
    
    parameters.Krho = Krho(simulation);
    parameters.Kalpha = Kalpha(simulation);
    parameters.Kbeta = Kbeta(simulation);
    
    parameters.constantSpeed = constantSpeed(simulation); 
    
    %% init/reset data logging struct
    result.x = nan(50000,ngPoses);
    result.y = nan(50000,ngPoses);
    result.theta = nan(50000,ngPoses);
    result.omega = nan(50000,ngPoses);
    result.vu = nan(50000,ngPoses);
    
    for gpose = 1:size(gposes,1)
        %% Control loop
        EndCond = 0;
        count = 0;

        %% New goal pose
        disp('new pose')
        disp(gposes(gpose,:))
        %bob_setGhostPose(connection,gposes(gpose,1), gposes(gpose,2), gposes(gpose,3));
        bob_setTargetGhostPose(connection,gposes(gpose,1), gposes(gpose,2), gposes(gpose,3))
        pause(1);
        timerVal = tic; % start times
        while (~EndCond)
            %% CONTROL STEP.
            count = count + 1;

            % Get pose and goalPose from vrep
            [x, y, theta] = bob_getPose(connection);

            %due to delays we want to keep away form loading the 
            [xg, yg, thetag] = bob_getTargetGhostPose(connection);

            % run control step
            [ vu, omega ] = calculateControlOutput([x, y, theta], [xg, yg, thetag], parameters);

            % Calculate wheel speeds
            [LeftWheelVelocity, RightWheelVelocity ] = calculateWheelSpeeds(vu, omega, parameters);

            % End condition
            dtheta = abs(normalizeAngle(theta-thetag));

            rho = sqrt((xg-x)^2+(yg-y)^2);  % pythagoras theorem, sqrt(dx^2 + dy^2)
            EndCond = (rho < parameters.dist_threshold && dtheta < parameters.angle_threshold) || rho > 5;    

            % SET ROBOT WHEEL SPEEDS.
            bob_setWheelSpeeds(connection, LeftWheelVelocity, RightWheelVelocity);
            
            %% log results
            result.x(count,gpose) = x;
            result.y(count,gpose) = y;
            result.theta(count,gpose) = theta;
            
            result.omega(count,gpose) = omega;
            result.vu(count,gpose) = vu;
            %bob_setGhostPose(connection, 0,0,0)
        end
        result.t(gpose) = toc(timerVal);
        %% Reset
        % Break connection
        disp('reset')
        bob_setWheelSpeeds(connection, 0.0, 0.0);
        simulation_stop(connection);
        simulation_closeConnection(connection);

        % Initialize connection with V-Rep
        connection = simulation_setup();
        connection = simulation_openConnection(connection, 0);
        simulation_start(connection);

        % Initialize new simulation
        bob_init(connection);
        bob_setTargetGhostPose(connection, -1, 0, 0);
        bob_setTargetGhostVisible(connection, 1);
    end
    pathDefault = ['data',  filesep];
    fileID = ['result', '_',testName, num2str(simulation)];
    save([pathDefault fileID],'result');
 
    showTitle = false;
    showAxis = false;
    logResults(fileID, showTitle, showAxis, rgPoses,lineWidth,fontSize,dim)
    
end

%% Bring Bob to standstill
bob_setWheelSpeeds(connection, 0.0, 0.0);

simulation_stop(connection);
simulation_closeConnection(connection);

% msgbox('Simulation ended');
