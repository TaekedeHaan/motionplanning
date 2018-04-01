function animate(t, y, par, opts, mZero)

% Shows animation of robot swarm y over time t
%
% Linda van der Spaa, TU Delft, 2018
% Javier Alonso Mora, ETHZ, 2010
% Andreas Breitenmoser, MIT, 2009
% Mac Schwager, MIT, 2006

n  = par.N;
dt = par.dt;

fs = opts.fs;   % font size
lw = opts.lw;   % line width
ms = opts.ms;   % marker size

% initialise figure
figure;
title(strcat('time = ', num2str(t(1),'%.1f'), 's'), 'FontSize', fs);
set(gca, 'FontSize', fs, 'LineWidth', lw, 'FontWeight', 'bold');
h = plot(y(1:n,1), y(n+1:2*n,1), 'ks');
set(h, 'MarkerSize', ms, 'LineWidth', lw);
axis equal;
axis([0 1 0 1]);

% In case a second argument is provided, extract the time stamps and the
% indices to retrieve the corresponding positions for later.
[jZero,tZero,tEnd] = deal([]);
if exist('mZero','var')
    for j = 1:length(mZero)
        if length(mZero{j}) > 2
            jZero = [jZero j];
            tZero = [tZero mZero{j}(1)];
        end
    end
end

% loop over the time vector
for i = 1:length(t)
    title(strcat('time = ', num2str(t(i),'%.1f'), 's'));
    set(h,'XData', y(1:n,i), 'YData', y(n+1:2*n,i));
    drawnow;
    
    % if there are robots in zero mass regions at the current time step 
    [mem,idx] = ismember(t(i),tZero);
    if mem
        yZero = mZero{jZero(idx)}(3:end);
        pZero = reshape(yZero,[length(yZero)/2 2]);
        hold on
        hZero = plot(pZero(:,1), pZero(:,2), 'rs');
        hold off
        tEnd = mZero{jZero(idx)}(2);
    end
    if t(i) == tEnd+dt, clear(hZero); end
    
    pause(dt);
end