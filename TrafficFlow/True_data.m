clear; 

density10 = csvread('D:/Thesis/data/201510_density.csv', 1, 1);

figure(1) % find uncongested
u_density = density10';
u_opt = 56.70*ones(size(u_density));
u_error = u_density-u_opt;
u_error(u_error<0) = 0;

tstart = datenum('2015-10-01 00:00:00'); % 開始時間
tend = datenum('2015-10-31 00:00:00'); % 結束時間
x = 1:38; % 19個間隔
y = linspace(tstart, tend, 288*31+1);
[xx, yy] = meshgrid(x, y);

surf(xx(1:end-1,:), yy(1:end-1,:), u_error'); hold on;
set(gca, 'XTick', x, 'YTick', y(1:288*2:end), 'YTickLabel', [], 'FontSize', 16);
set(gcf, 'unit', 'normalized', 'position', [0,0.2,1,0.6])
xposi = (-0.7)*ones(1,16);
yposi = y(1:288*2:end);
zposi = (-3)*ones(1,16);
text(xposi, yposi, zposi, {'10/1','10/3','10/5','10/7','10/9','10/11','10/13','10/15', ...
                           '10/17','10/19','10/21','10/23','10/25','10/27','10/29','10/31'}, ...
     'HorizontalAlignment', 'right', 'rotation', 10, 'fontsize', 12);
axis([0.5, 19.5, -inf, inf, 0, 100]);
xlabel('sensor (km)', 'fontsize', 24) ;
ylabel('Time (mm/dd)', 'fontsize', 24) ;
zlabel('density (pcu/km)', 'fontsize', 24) ;

% figure(2) % Task 1: uncongested
% u_density = density09(1:288*2,:)';
% u_opt = 56.85*ones(size(u_density));
% tstart = datenum('2018-11-01 00:00:00'); % 開始時間
% tend = datenum('2018-11-03 00:00:00'); % 結束時間
% x = 1:19; % 19個間隔
% y = linspace(tstart, tend, length(u_density));
% [xx, yy] = meshgrid(x, y);
% colormap; colorbar;
% grid on;
% mesh(xx, yy, u_density'); hold on;
% mesh(xx, yy, u_opt');
% set(gca, 'YTick', y(1:288:end), 'YTickLabel', [], 'FontSize', 16);
% datetick('y', 'HH:MM','keepticks') % 使用datetick函數直接生成時間座標
% ylabel('Time (HH:MM)', 'fontsize', 32) ;
% xlabel('Sensor', 'fontsize', 32) ;
% axis([-inf, inf, -inf, inf, 0, 60])
% 
% figure(3) % Task 2: congested
% u_density = density09(288*15:288*17,:)';
% u_opt = 56.85*ones(size(u_density));
% tstart = datenum('2018-11-16 00:00:00'); % 開始時間
% tend = datenum('2018-11-18 00:00:00'); % 結束時間
% x = 1:19; % 19個間隔
% y = linspace(tstart, tend, length(u_density));
% [xx, yy] = meshgrid(x, y);
% colormap; colorbar;
% grid on;
% mesh(xx, yy, u_density'); hold on;
% mesh(xx, yy, u_opt');
% set(gca, 'YTick', y(1:288:end), 'YTickLabel', [], 'FontSize', 16);
% datetick('y', 'HH:MM','keepticks') % 使用datetick函數直接生成時間座標
% ylabel('Time (HH:MM)', 'fontsize', 32) ;
% xlabel('Sensor', 'fontsize', 32) ;
% axis([-inf, inf, -inf, inf, 0, 110])