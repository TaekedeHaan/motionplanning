function intersec = LineIntersect(line1, line2)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Mac Schwager, MIT, 2006
% Andreas Breitenmoser, MIT, 2009
%
% Finds the intersection point of two lines given by
% vectors line1 and line2 which contain [normal; const]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n1 = line1(1:2);
a1 = line1(3);
n2 = line2(1:2);
a2 = line2(3);
% intersec = -inv([n1'; n2'])*[a1; a2];

% Check for parallel lines
if (abs(dot(n1, n2)/(norm(n1)*norm(n2))) ~= 1)
	intersec = -inv([n1'; n2'])*[a1; a2];
else
	intersec = -[Inf; Inf];
end
