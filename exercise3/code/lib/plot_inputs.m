function f3 = plot_inputs(lb, ub, N, dim)

f3 = figure(3); clf;
set(f3,'Position', dim); 
subplot(2,1,1); 
grid on; 
title('acceleration force'); 
hold on; 
plot([1 N], [ub(1) ub(1)]', 'r:');
plot([1 N], [lb(1) lb(1)]', 'r:');
ylabel('F [N]')
xlabel('step [-]')

subplot(2,1,2); 
grid on; 
title('delta steering'); 
hold on; 
plot([1 N], [ub(2) ub(2)]', 'r:');
plot([1 N], [lb(2) lb(2)]', 'r:');
ylabel('s [?]')
xlabel('step [-]')