clear all
close all
clc

dataFolder = {'data', filesep};
loadString = ["data_100_0,1_0,01", "data_100_0,001_0,0001", "data_100_10_1"]; %"data_100_10_0,01"
legendString = ["100, 0.1, 0.01", "100, 0.001, 0.0001", "100, 10, 1"];

pathFig = ['fig', filesep];

dim = [200, 200, 600, 500];
dim2 = [200, 200, 600, 700];
fontSize = 15;
lineWidth = 2;
% define colors
color = [0, 0.4470, 0.7410;
    0.9, 0.60, 0.4410; 
    0.2, 0.80, 0.4410];% blue, used for plotting
colorGrey = 0.8*[1, 1, 1]; % grey, used for plotting
colorWhite = [1, 1, 1];


for i = 1:length(loadString)
    loadData = [char(strjoin([dataFolder loadString(i)],'')), '.mat'];
    load(loadData);
    if i == 1
        f1 = plot_enviroment(hl, hu, xinit, dim);
        f2 = plot_velocity(lb, ub, N, dim2);
        f3 = plot_inputs(lb, ub, N, dim2);  
    end
    % plot enviroment
    figure(1);
    h1(i) = plot(X(1,:),X(2,:), 'LineWidth',lineWidth); %,'color',color(i,:) 
    
    % plot velocity
    figure(2);
    subplot(2,1,1); 
    h21(i) = plot(X(3,:), 'LineWidth', lineWidth); 
    
    subplot(2,1,2); 
    h22(i) = plot(rad2deg(X(4,:)), 'LineWidth', lineWidth); 
    
    % plot inputs
    figure(3)
    subplot(2,1,1);
    h31(i) = stairs(U(1,:),'LineWidth', lineWidth);
    
    subplot(2,1,2);
    h32(i) = stairs(U(2,:), 'LineWidth', lineWidth); 
end

% trajectory legend
figure(1);
legend(h1, legendString, 'Location','northwest');
set(gca,'fontsize', fontSize);

saveas(gcf, [pathFig, 'trajectory'], 'jpg');
saveas(gcf, [pathFig, 'trajectory','.eps'], 'epsc');

% Velosity legend
figure(2);
subplot(2,1,1); 
legend(h21, legendString, 'Location','northeast');
set(gca,'fontsize', fontSize);

subplot(2,1,2);
legend(h22, legendString, 'Location','northeast');
set(gca,'fontsize', fontSize);

saveas(gcf, [pathFig, 'velosity'], 'jpg');
saveas(gcf, [pathFig, 'velosity','.eps'], 'epsc');

% input legend
figure(3);
subplot(2,1,1); 
legend(h31, legendString, 'Location','northeast');
set(gca,'fontsize', fontSize);

subplot(2,1,2);
legend(h32, legendString, 'Location','northeast');
set(gca,'fontsize', fontSize);

saveas(gcf, [pathFig, 'input'], 'jpg');
saveas(gcf, [pathFig, 'input','.eps'], 'epsc');
