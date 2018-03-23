function [gposes] = determine_poses(n, r)
    %Generate n goal poses located at a circle with radius r
    %   Detailed explanation goes here
    gposes = nan(n,3);
    
    angleOffset = 0; % pi
    
    dAngle = 2*pi /n; %[rad]
    for i = 1: n
        angle = pi - (i - 1) * dAngle;
        gposes(i,:) = [r * cos(angle), r * sin(angle), angle + angleOffset];
    end
end

