function [vx,vy] = plotVoronoi(x,y,opts)
% plots the Voronoi diagram for the points X,Y. Cells that contain a point
% at infinity are unbounded and are not plotted.

%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 1.15.4.7 $  $Date: 2004/08/16 01:52:42 $

% Revised by Mac Schwager, MIT, 2006 to plot with bigger lines
% Revised by Linda van der Spaa, TU Delft, 2018, to minimum working version

ms = opts.ms;
lw = opts.lw;

tri = delaunay(x,y);

% re-orient the triangles so that they are all clockwise
xt = x(tri); yt=y(tri);
%Because of the way indexing works, the shape of xt is the same as the
%shpae of tri, EXCEPT when tri is a single row, in which case xt can be a
%column vector instead of a row vector.
if size(xt,2) == 1 
    xt = xt';
    yt = yt';
end
ot = xt(:,1).*(yt(:,2)-yt(:,3)) + ...
    xt(:,2).*(yt(:,3)-yt(:,1)) + ...
    xt(:,3).*(yt(:,1)-yt(:,2));
bt = find(ot<0);
tri(bt,[1 2]) = tri(bt,[2 1]);

n = numel(x);
ntri = size(tri,1);
t = (1:ntri)';
T = sparse(tri,tri(:,[3 1 2]),t(:,ones(1,3)),n,n); % Triangle edge if T(i,j) 
E = (T & T').*T; % Voronoi edge if E(i,j) 

[~,~,v] = find(triu(E));
[~,~,vv] = find(triu(E'));
c1 = circle(tri(v,:),x,y);
c2 = circle(tri(vv,:),x,y);

vx = [c1(:,1) c2(:,1)].';
vy = [c1(:,2) c2(:,2)].';

if opts.plot
    cax = gca;
    co = get(ancestor(cax,'figure'),'defaultaxescolororder');
    h = plot(vx,vy,'-',x,y,'s','MarkerSize', ms,'color',co(1,:),'parent',cax, 'LineWidth', lw);
    view(cax,2), axis(cax,[min(x(:)) max(x(:)) min(y(:)) max(y(:))])
    if nargout==1, vx = h; end
end

function c = circle(tri,x,y)
%CIRCLE Return center for circumcircles
%   C = CIRCLE(TRI,X,Y) returns a N-by-3 vector containing [xcenter(:)
%   ycenter(:)] for each triangle in TRI.

% Reference: Watson, p32.
x = x(:); y = y(:);

x1 = x(tri(:,1)); x2 = x(tri(:,2)); x3 = x(tri(:,3));
y1 = y(tri(:,1)); y2 = y(tri(:,2)); y3 = y(tri(:,3));

% Set equation for center of each circumcircle: 
%    [a11 a12;a21 a22]*[x;y] = [b1;b2] * 0.5;

a11 = x2-x1; a12 = y2-y1;
a21 = x3-x1; a22 = y3-y1;

b1 = a11 .* (x2+x1) + a12 .* (y2+y1);
b2 = a21 .* (x3+x1) + a22 .* (y3+y1);

% Solve the 2-by-2 equation explicitly
idet = a11.*a22 - a21.*a12;

% Add small random displacement to points that are either the same
% or on a line.
d = find(idet == 0);
if ~isempty(d) % Add small random displacement to points
    delta = sqrt(eps);
    x1(d) = x1(d) + delta*(rand(size(d))-0.5);
    x2(d) = x2(d) + delta*(rand(size(d))-0.5);
    x3(d) = x3(d) + delta*(rand(size(d))-0.5);
    y1(d) = y1(d) + delta*(rand(size(d))-0.5);
    y2(d) = y2(d) + delta*(rand(size(d))-0.5);
    y3(d) = y3(d) + delta*(rand(size(d))-0.5);
    a11 = x2-x1; a12 = y2-y1;
    a21 = x3-x1; a22 = y3-y1;
    b1 = a11 .* (x2+x1) + a12 .* (y2+y1);
    b2 = a21 .* (x3+x1) + a22 .* (y3+y1);
    idet = a11.*a22 - a21.*a12;
end

idet = 0.5 ./ idet;

xcenter = ( a22.*b1 - a12.*b2) .* idet;
ycenter = (-a21.*b1 + a11.*b2) .* idet;

c = [xcenter ycenter];
