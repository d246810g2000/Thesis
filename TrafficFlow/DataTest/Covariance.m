clear;
Task1 = load('Task1_Pf.mat');
Task2 = load('Task2_Pf.mat');
Task1_Pf = Task1.Pf;
Task2_Pf = Task2.Pf;

figure(1)
subplot(1,2,1)
set(gcf,'unit','normalized','position',[-0.2,0.2,1.2,0.6])
x = 1:37; % 38個間隔
[xx, yy] = meshgrid(x, x);
surf(xx, yy, Task1_Pf)
set(gca, 'XTick', [1:4:37], 'YTick', [1:4:37], 'FontSize', 24);
xlabel('Sensor number', 'fontsize', 24) ;
title('Task1', 'fontsize', 24)
axis([-inf,inf,-inf,inf,0,1.2]);

subplot(1,2,2)
set(gcf,'unit','normalized','position',[-0.2,0.2,1.2,0.6])
x = 1:37; % 38個間隔
[xx, yy] = meshgrid(x, x);
surf(xx, yy, Task2_Pf)
set(gca, 'XTick', [1:4:37], 'YTick', [1:4:37], 'FontSize', 24);
ylabel('Sensor number', 'fontsize', 24) ;
title('Task2', 'fontsize', 24)
axis([-inf,inf,-inf,inf,0,1.2]);