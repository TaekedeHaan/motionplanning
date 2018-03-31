function h = simpleMassDistribution(densType, alpha, beta, gamma, delta)

% Function creating a density function in one of a number of simple shapes
%
% Inputs:
%   densType    type of density function
%   alpha       strength
%   beta        standard deviation
%   gamma       center position
%   delta       constant offset
%
% Output:
%   h           function handle to compute the probability density at [x;y]
%
% Linda van der Spaa, TU Delft, 2018
% Based on code by:
% Javier Alonso-Mora, ETH Zürich, 2010
% Andreas Breitenmoser, MIT, 2009
% Mac Schwager, MIT, 2006

syms x y
switch densType
    case 0  % Uniform density5
        h = @(x,y) 1;
        return;
        
% Cases > 0: non-uniform density
    case 1  % Gaussians in 2D
        z = sqrt((x - gamma).^2) .* beta.^-1;
        g = beta.^-1/sqrt(2*pi) .* exp(-.5*z.^2);
        phi = alpha'*g + delta;

    case 2  % Gaussians in 3D   
        z = sqrt((x - gamma(:,1)).^2 + (y - gamma(:,2)).^2).*beta.^-1;
        g = beta.^-1/sqrt(2*pi).*exp(-.5*z.^2);
        phi = alpha'*g + sum(delta);
        
    case 3 % Ellipse in 3D
        phi = exp(-alpha*(beta(1)*(x - gamma(:,1)).^2 + beta(2)*(y - gamma(:,2)).^2 - delta^2).^2);

end
h = matlabFunction(phi,'vars',{x,y});