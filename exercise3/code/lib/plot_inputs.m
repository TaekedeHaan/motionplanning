function plot_inputs

figure(3); clf;
subplot(2,1,1); stairs(U(1,:)); grid on; title('acceleration force'); hold on; 
plot([1 model.N], [model.ub(1) model.ub(1)]', 'r:');
plot([1 model.N], [model.lb(1) model.lb(1)]', 'r:');
subplot(2,1,2); stairs(U(2,:)); grid on; title('delta steering'); hold on; 
plot([1 model.N], [model.ub(2) model.ub(2)]', 'r:');
plot([1 model.N], [model.lb(2) model.lb(2)]', 'r:');
