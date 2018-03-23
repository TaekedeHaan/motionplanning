function plotEnviroment(hl, hu, xinit, fontSize, dim)

pathFig = [pwd, filesep, 'fig' filesep];

% define colors
colorBlue = [0, 0.4470, 0.7410]; % blue, used for plotting
colorGrey = 0.8*[1, 1, 1]; % grey, used for plotting
colorWhite = [1, 1, 1];
% plot trajectory
figure(1); clf;
rectangle('Position', [-4, -1, 5, 5], 'FaceColor',colorGrey);
rectangle('Position',[-sqrt(hu(1)) -sqrt(hu(1)) 2*sqrt(hu(1)) 2*sqrt(hu(1))],'Curvature',[1 1],'EdgeColor',colorGrey,'FaceColor',colorWhite,'LineWidth',1);
rectangle('Position',[-sqrt(hl(1)) -sqrt(hl(1)) 2*sqrt(hl(1)) 2*sqrt(hl(1))],'Curvature',[1 1],'EdgeColor',colorGrey,'FaceColor',colorGrey,'LineWidth',1); hold on

rectangle('Position',[-2-sqrt(hl(2)) 2.5-sqrt(hl(2)) 2*sqrt(hl(2)) 2*sqrt(hl(2))],'Curvature',[1 1],'EdgeColor',colorGrey,'FaceColor',colorGrey,'LineWidth',1);
plot(xinit(1),xinit(2),'bx','LineWidth',3);  hold on; 

title('position'); xlim([-3 0]); ylim([0 3]); xlabel('x position'); ylabel('y position');
grid on
grid minor
ax = gca;
ax.Layer = 'top';
set(gca,'fontsize', fontSize);
end

