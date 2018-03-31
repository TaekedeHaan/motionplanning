function posNew = positionUpdate(posOld, u, par)
dt = par.dt;
posNew = posOld + dt*u;


