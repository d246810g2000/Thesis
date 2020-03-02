clear;

% Load data
density09 = csvread('D:/Thesis/data/201509_density.csv', 1, 1);
density10 = csvread('D:/Thesis/data/201510_density.csv', 1, 1);

start_time = 288*0+1;
end_time = 4;
past_time = 6;
want_predict_time = 3;
update_time = 1;
dt = 5;

initial = [density09(length(density09)-(past_time+want_predict_time-1):end,:); density10]';
left = initial(1,:);
right = initial(end,:);

u_density = initial(:, past_time+start_time+want_predict_time:past_time+end_time+want_predict_time);

% plot result
tstart = datenum('2015-10-01 00:00:00');% 開始時間
tend = datenum('2015-10-01 00:15:00');% 結束時間
x = 1:38; % 38個間隔
y = linspace(tstart, tend, 4);
[xx, yy] = meshgrid(x, y);

figure(1)
mesh(xx, yy, u_density');
set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y, 'FontSize', 24);
datetick('y','HH:MM', 'keepticks');
xlabel('Space', 'fontsize', 36) ;
ylabel('Time', 'fontsize', 36);
caxis([0 150]) 

figure(2)
% plot([y(1) y(2)], [3 2], 'b-', 'LineWidth', 3); hold on;
plot([y(2) y(2)], [2 6], 'b--', 'LineWidth', 3);hold on;
% plot([y(2) y(3)], [6 7], 'b-', 'LineWidth', 3);
plot([y(3) y(3)], [7 4], 'b--', 'LineWidth', 3);
% plot([y(3) y(4)], [4 8], 'b-', 'LineWidth', 3);
f1 = plot(y, [3 5 3 7], 'ko', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
f2 = plot(y, [3 9 2 5], 'ro', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r'); 
f3 = plot(y, [3 2 7 8], 'bo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'b');
f4 = plot(y(2:3), [6 4], 'mo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'm');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24);
datetick('x','HH:MM', 'keepticks');
axis([-inf inf 1 10])
legend([f1 f2 f3 f4], 'ground truth', 'psudo observed value', 'predicted value', 'corrected value', 'Location', 'northwest')
xlabel('Time', 'fontsize', 36);
ylabel('Density (pcu/km)', 'fontsize', 36);