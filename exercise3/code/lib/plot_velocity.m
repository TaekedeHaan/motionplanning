function f2 = plot_velocity(lb, ub, N, dim)


% plot heading angle and velocity variables
f2 = figure(2);
set(f2,'Position', dim); 
subplot(2,1,1); 

grid on; 
title('velocity'); 
hold on; 
plot([1 N], [lb(5) lb(5)]', 'r:');
plot([1 N], [ub(5) ub(5)]', 'r:');

subplot(2,1,2); 
grid on; 
title('heading angle'); 
ylim([0, 180]); 
hold on; 
plot([1 N], rad2deg([lb(6) lb(6)])', 'r:');
plot([1 N], rad2deg([ub(6) ub(6)])', 'r:');