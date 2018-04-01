%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Main script
%
% Linda van der Spaa, TU Delft, 2018
% Original code by:
% Javier Alonso Mora, ETHZ, 2010
% Andreas Breitenmoser, MIT, 2009
% Mac Schwager, MIT, 2006
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preparation
% options
options = struct('animation',   1,...   % show animation
                 'plot',        1,...   % show plots
                 'lw',      2,...       % plot line width
                 'ms',      10,...      % plot marker size
                 'fs',      14);        % plot font size
lw = options.lw;
ms = options.ms;
fs = options.ms;

% parameters
par = struct('boudary', [0 0;0 1;1 1;1 0],...   % field boudary
             'N',       50,...          % numer of agents
             'res',     10,...          % centroid calulation resolution
             'dt',      0.1);           % time step [s]
N = par.N;

patternTime = 2; % duration per goal pattern

% derived constants
xlb = min(par.boudary(:,1));
xub = max(par.boudary(:,1));
ylb = min(par.boudary(:,2));
yub = max(par.boudary(:,2));

% initial conditions
rng('shuffle', 'twister');
y0 = rand(2*N,1);

%% Pattern control
zeroMass = cell(5,1);

disp('Computing pattern 1 ...')
pattern1 = simpleMassDistribution(1,   6.0e5, 0.05, 0.5, 1);
[t1,y1,dens1,zm1] = Lloyd(pattern1, y0, [0 patternTime], par);
zeroMass{1} = zm1;

disp('Computing pattern 2 ...')
pattern2 = simpleMassDistribution(3,   1.0e6, [0.1 0.1], [0.5 0.5], 0.1);
[t2,y2,dens2,zm2] = Lloyd(pattern2, y1(:,end), [t1(end) 2*patternTime], par);
zeroMass{2} = zm2;

disp('Computing pattern 3 ...')
pattern3 = simpleMassDistribution(2,   3.0e8, 0.1, [0.5 0.5], 1);
[t3,y3,dens3,zm3] = Lloyd(pattern3, y2(:,end), [t2(end) 3*patternTime], par);
zeroMass{3} = zm3;

disp('Computing pattern 4 ...')
pattern4 = simpleMassDistribution(0);
[t4,y4,dens4,zm4] = Lloyd(pattern4, y3(:,end), [t3(end) 4*patternTime], par);
zeroMass{4} = zm4;
%%
for i = 2
    
disp('Computing pattern 5 ...')
pattern5 = imageMassDensity('stars.mat',i);
[t5,y5,dens5,zm5] = Lloyd(pattern5, y4(:,end), [t4(end) 5*patternTime + 2.5], par);
zeroMass{5} = zm5;


% combine
t = [t1(1:end-1) t2(1:end-1) t3(1:end-1) t4(1:end-1) t5];
y = [y1(:,1:end-1) y2(:,1:end-1) y3(:,1:end-1) y4(:,1:end-1) y5];

%% Visualisation
%% animate robot trajectories
if options.animation
    disp('Preparing animation')
    animate(t,y,par,options, zeroMass);
end

%% plot Voronoi diagrams
if options.plot
    disp('Preparing Voronoi diagrams:')
    disp('    initial state')
    xinit = y(1:N,1);
    yinit = y(N+1:2*N,1);
    xinit = [xinit; -xinit; 2-xinit; xinit; xinit];
    yinit = [yinit; yinit; yinit; -yinit; 2-yinit];
    figure; plotVoronoi(xinit,yinit,options);
    axis equal;
    axis([xlb xub ylb yub]);
    
    disp('    final state')
    xfinal = y(1:N,end);
    yfinal = y(N+1:2*N,end);
    xfinal = [xfinal; -xfinal; 2-xfinal; xfinal; xfinal];
    yfinal = [yfinal; yfinal; yfinal; -yfinal; 2-yfinal];
    figure; plotVoronoi(xfinal,yfinal,options);
    
    % plot agent trajectories
    hold on;
    for i = 1:N
        plot(y(i,end), y(i+N,end), 'sk', 'LineWidth', lw, 'MarkerSize', ms);
        hold on;
        plot(y(i,:), y(i+N,:), '--k', 'LineWidth', lw, 'MarkerSize', ms);
    end
    axis equal;
    axis([xlb xub ylb yub]);
end

%% plot density function
pattern = pattern5; dens = dens5;

[xCoord, yCoord] = meshgrid(xlb:0.01:xub, ylb:0.01:yub);
densDistribution = zeros(size(xCoord));
for i = 1:size(xCoord,1)
    for j = 1:size(xCoord,2)
        densDistribution(i,j) = pattern(xCoord(i,j), yCoord(i,j));
    end
end
%%
rows = max(densDistribution);
figure;
plot(rows)
xlabel('Row number')
ylabel('Density')
%%
% normalize
maxMag = max(max(max(densDistribution)));
densDistributionNorm = 1/maxMag*densDistribution;
% plot surface
figure; surf(xCoord, yCoord, densDistributionNorm,'EdgeColor','none');
camlight left; lighting phong
% add robots' partitions at last time step
hold on
for k = 1:N
    stem3(dens(:,1,k,end), dens(:,2,k,end), 1/maxMag*dens(:,3,k,end), 'x');
end
axis equal;
axis([xlb xub ylb yub 0 1]);
end