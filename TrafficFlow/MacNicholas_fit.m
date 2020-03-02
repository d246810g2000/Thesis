clear;
data = load('D:/Thesis/data/data_kNN.mat');
data = data.out;
k1 = data.density;
v1 = data.speed;
q1 = k1.*v1;

% plot The MacNicholas Model (2008)
x = linspace(0,150,150);
vf4 = 89.16; kj4 = 191.99; n = 1.81; m = 6.83;
f4 = @(k) vf4.*((kj4.^n-k.^n)./(kj4^n+m*k.^n));

figure(1)
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
subplot(1,2,1)
plot(k1, v1, '.', 'Markersize', 5); hold on ;
plot(x, f4(x), 'LineWidth', 4)
axis([0 150 0 100])
set(gca, 'box', 'off', 'FontSize', 24);
title('Density-Velocity', 'FontSize', 36) 
xlabel('density (pcu/km)', 'fontsize', 36);
ylabel('velocity (km/hr)', 'fontsize', 36);

subplot(1,2,2)
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
plot(k1, q1, '.', 'Markersize', 5); hold on ;
plot(x, x.*f4(x), 'LineWidth', 4)
axis([0 150 0 3000])
set(gca, 'box', 'off', 'FontSize', 24);
title('Density-Flow', 'FontSize', 36) 
xlabel('density (pcu/km)', 'fontsize', 36);
ylabel('flow (pcu/hr)', 'fontsize', 36);
