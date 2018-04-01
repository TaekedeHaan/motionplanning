function [Mv, Lv, phiFcn] = centroidNumerical(V, massFcn, par)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Mac Schwager, MIT, 2006
% Andreas Breitenmoser, MIT, 2009
%
% Calculate the centroid of a region V parameterized by K'*a. Uses
% numerical descritization of region to evaluate the centroid integrals.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res = par.res;

% Make rectangular domain to contain region
xmax = max(V(:,1));
xmin = min(V(:,1));
ymax = max(V(:,2));
ymin = min(V(:,2));

% Integration step
xstep = (xmax-xmin)/res;
ystep = (ymax-ymin)/res;

% Integration loop to calc M, intxphi, intyphi
phiFcn = zeros(res^2,3);
Mv = 0;
Lv = [0 0]';
i = 1;
for x = xmin+xstep/2:xstep:xmax-xstep/2
    for y = ymin+ystep/2:ystep:ymax-ystep/2
        q = [x; y];
        phiFcn(i, 1:2) = q';
        if inpolygon(q(1), q(2), V(:,1), V(:,2))
            phiq = massFcn(q(1),q(2));
            Mv = Mv + TODO; % mass
            Lv = Lv + TODO; % moment
            phiFcn(i, 3) = phiq;
        end
        i = i+1;
    end
end
