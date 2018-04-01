function posNew = positionUpdate(posOld, u, par)

% update position
posNew = posOld + par.dt*u;

end
