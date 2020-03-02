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
set(gcf,'unit','normalized','position',[0.2,0.1,0.6,0.7])
f1 = plot(y(1), 3, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k'); hold on;
f2 = plot(y(2), 9, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white'); 
f3 = plot(y(2), 2, 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24, 'box', 'off');
datetick('x','HH:MM', 'keepticks');
axis([y(1) y(end) 1 10])
xlabel('Time', 'fontsize', 28);
ylabel('Density (pcu/km)', 'fontsize', 28);

figure(2)
set(gcf,'unit','normalized','position',[0.2,0.1,0.6,0.7])
plot(y(1), 3, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k'); hold on;
plot(y(2), 9, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white'); 
plot(y(2), 2, 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
plot(y(2), 6, 'k^', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24, 'box', 'off');
datetick('x','HH:MM', 'keepticks');
axis([y(1) y(end) 1 10])
xlabel('Time', 'fontsize', 28);
ylabel('Density (pcu/km)', 'fontsize', 28);

figure(3)
set(gcf,'unit','normalized','position',[0.2,0.1,0.6,0.7])
plot(y(1), 3, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k'); hold on;
plot(y(2:3), [9, 2], 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white'); 
plot(y(2:3), [2, 7], 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
plot(y(2), 6, 'k^', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24, 'box', 'off');
datetick('x','HH:MM', 'keepticks');
axis([y(1) y(end) 1 10])
xlabel('Time', 'fontsize', 28);
ylabel('Density (pcu/km)', 'fontsize', 28);

figure(4)
set(gcf,'unit','normalized','position',[0.2,0.1,0.6,0.7])
plot(y(1), 3, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k'); hold on;
plot(y(2:3), [9, 2], 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white'); 
plot(y(2:3), [2, 7], 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
plot(y(2:3), [6, 4], 'k^', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24, 'box', 'off');
datetick('x','HH:MM', 'keepticks');
axis([y(1) y(end) 1 10])
xlabel('Time', 'fontsize', 28);
ylabel('Density (pcu/km)', 'fontsize', 28);

figure(5)
set(gcf,'unit','normalized','position',[0.2,0.1,0.6,0.7])
plot(y(1), 3, 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k'); hold on;
plot(y(2:3), [9, 2], 'ko', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white'); 
plot(y(2:3), [2, 7], 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'white');
plot(y(4), [8], 'ks', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','r', 'MarkerFaceColor', 'white');
plot(y(2:3), [6, 4], 'k^', 'LineWidth', 2, 'MarkerSize', 15, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'k');
set(gca, 'XTick', y, 'YTick', [], 'FontSize', 24, 'box', 'off');
datetick('x','HH:MM', 'keepticks');
axis([y(1) y(end) 1 10])
xlabel('Time', 'fontsize', 28);
ylabel('Density (pcu/km)', 'fontsize', 28);