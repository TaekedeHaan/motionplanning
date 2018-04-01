function [t,y,densityField,zmPoints] = Lloyd(massFcn, y0, tspan, par)

% Lloyd's algorithm for robot swarm control
%
% Inputs:
%   massFcn       function handle of probability density function encoding
%                 the desired swarm shape
%   y0            initial positions of the robot swarm [x;y] of size 2N x 1
%   tspan         [tinit tend] initial and final time of the simulation
%   par           parameters, required for this function:
%       N           number of robot in the swarm
%       dt          simulation timestep
%       res         numerical resolution
%
% Outputs:
%   t             simulation time vector
%   y             robot positions
%   densityField  probability density per area closest to each robot
%
% Author: Linda van der Spaa, TU Delft, 2018

N = par.N;
dt = par.dt;
t = tspan(1):dt:tspan(2);

positions = reshape(y0,[N 2]);

y = zeros(2*N,length(t));
densityField = zeros(par.res^2,3,N,length(t));
posZeroM = [];
for ti = 1:length(t)
    y(:,ti) = positions(:);
    inputs = zeros(size(positions));
    
    for i = 1:N
        posRi = positions(i,:)';
        
        % calculate Voronoi
        V = Voronoi(positions, posRi, par);
        
        % calculate centeroids
        [Mv, Lv, phi] = centroidNumerical(V, massFcn, par);
        densityField(:,:,i,ti) = phi;
        
        % robot control
        inputs(i,:) = controlLaw(posRi, Mv, Lv);
        
        if ti == 1 && Mv == 0 % Calculated zero mass over Voronoi region
            posZeroM = [posZeroM; posRi'];
        end
    end
    
    % update robot positions
    positions = positionUpdate(positions, inputs, par);
end
zmPoints = [tspan(:); posZeroM(:)];