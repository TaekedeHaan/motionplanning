%check mass distribution

N = 20;
mass_total = 1;
mass_blocks = zeros(N,1);
mass_blocks(:) = mass_total/N;

dx = 1/N;
x = dx/2:dx:1-dx/2;

mass= 0;
Cv = 0;
for i = 1:N
    mass = mass+ mass_blocks(i);
    Cv = 1/mass*( Cv*(mass-mass_blocks(i))+x(i)*mass_blocks(i))
end

mass
Cv