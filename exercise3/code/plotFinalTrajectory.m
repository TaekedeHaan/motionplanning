clear all
close all
clc


loadString = "fileID.mat";


plotEnviroment(hl, hu, xinit, fontSize, dim)
hold on

for i = 1:lenth(loadString)
    plot(X(1,:),X(2,:),'color',colorBlue , 'LineWidth',lineWidth);
end


saveas(gcf, [pathFig, 'position'], 'jpg');
saveas(gcf, [pathFig, 'position','.eps'], 'epsc');