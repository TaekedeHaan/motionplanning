function logResults(fileID, showTitle, showAxis, rgPoses,lineWidth,fontSize,dim)

% define colors
colorBlue = [0, 0.4470, 0.7410]; % blue, used for plotting
colorGrey = 0.7*[1, 1, 1]; % grey, used for plotting

% load data
[parentdir,~,~]=fileparts(pwd);
%parts = strsplit(parentdir, filesep);
%DirPart = parts{end-1};
pathDefault = [parentdir, filesep, 'assignment_1_KinematicsAndControl', filesep];
pathData = [pathDefault, 'data' filesep,];
pathFig = [pathDefault, 'fig' filesep,];

load([pathData, fileID ,'.mat']);
n = size(result.x,2);

% generate goal poses
gposes = determine_poses(n, rgPoses);

% plot
figure('Position',dim)
plot(result.x, result.y,'Linewidth',lineWidth,'Color',colorBlue)
hold on
plot(gposes(:,1), gposes(:,2),'o', 'LineWidth',lineWidth, 'MarkerSize',10,'Color', colorGrey);
if showTitle
    title('Position');
end
if showAxis
    xlabel('x [m]');
    ylabel('y [m]');
end
grid minor;
set(gca,'fontsize', fontSize + 3);
axis([-1.2 * rgPoses, 1.2 * rgPoses, -1.2 * rgPoses, 1.2 * rgPoses])
saveas(gcf, [pathFig, fileID], 'jpg');
saveas(gcf, [pathFig, fileID,'.eps'], 'epsc');

trail = 2;

omega = result.omega(:,trail);
vu = result.vu(:,trail);

% plot
figure('Position',dim)
yyaxis left
plot(vu,'Linewidth',lineWidth,'Color',colorGrey)
hold on
yyaxis right
plot(omega,'Linewidth',lineWidth,'Color',colorBlue)
if showTitle
    title('Velosities');
end
yyaxis left
ylabel('vu [m/s]');
axis([1, sum(~isnan(omega)), 0.8 * min(vu) , 1.2 * max(vu)])

yyaxis right
ylabel('\omega [rad/s]');
axis([1, sum(~isnan(omega)), 1.2 * min(omega) , 1.2 * max(omega)])
xlabel('Sample [-]')

legend('vu','\omega [rad/s]')
grid minor;
set(gca,'fontsize', fontSize + 3);
%
saveas(gcf, [pathFig, fileID, 'velovity'], 'jpg');
saveas(gcf, [pathFig, fileID, 'velovity','.eps'], 'epsc');


% show mean time +- variance
disp(['Time: ', num2str(mean(result.t),4), ' +- ',num2str(var(result.t),4), '[s]']);
end

