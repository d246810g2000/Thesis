clear;

x = linspace(0, 150, 100);
y = linspace(0, 1250, 1000);
vf = 100; kj = 50;
f1 = @(k) vf.*(1-k./kj);
f2 = @(q) (100+sqrt(100^2-8*q))/2;
f3 = @(q) (100-sqrt(100^2-8*q))/2;

figure(1)
set(gcf,'unit','normalized','position',[-0.1,0.2,1.2,0.5])
subplot(1,3,1)
plot(x, f1(x), 'red-', 'LineWidth', 5); hold on; 
set(gca, 'box', 'off', 'FontSize', 24);
set(gca, 'TickLabelInterpreter', 'tex')
set(gca, 'XTick', [0 25 50], 'XTicklabel', {'0', '{\rho_{o}}', '\rho_{j}'})
set(gca, 'YTick', [50 100], 'YTicklabel', {'v_{o}','v_{f}'})
set(gca, 'box', 'off', 'FontSize', 24);
plot([25, 25], [0, 50], 'black:', 'LineWidth', 4)
plot([0, 25], [50, 50], 'black:', 'LineWidth', 4)
axis([0, 55, 0, 110]);
xlabel('density (pcu/km)', 'FontName', 'Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
ylabel('velocity (km/hr)', 'FontName', 'Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
title('Density-Velocity', 'FontSize', 24);

subplot(1,3,2)
plot(x, x.*f1(x), 'red-', 'LineWidth', 5); hold on; 
set(gca, 'box', 'off', 'FontSize', 24);
set(gca, 'TickLabelInterpreter', 'tex')
set(gca, 'XTick', [0 25 50], 'XTicklabel', {'0', '\rho_o', '\rho_j'})
set(gca, 'YTick', [1250], 'YTicklabel', {'q_{max}'})
set(gca, 'box', 'off', 'FontSize', 24);
plot([25, 25], [0, 1250], 'black:', 'LineWidth', 4)
plot([0, 25], [1250, 1250], 'black:', 'LineWidth', 4)
axis([0, 55, 0, 1350]);
xlabel('density (pcu/km)', 'FontName','Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
ylabel('flow (pcu/hr)', 'FontName','Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
title('Density-Flow', 'FontSize', 24);

subplot(1,3,3)
plot(y, f2(y), 'red-', 'LineWidth', 5); hold on; 
plot(y, f3(y), 'red-', 'LineWidth', 5); 
set(gca, 'box', 'off', 'FontSize', 24);
set(gca, 'TickLabelInterpreter', 'tex')
set(gca, 'XTick', [0 1250], 'XTicklabel', {'0', 'q_{max}'})
set(gca, 'YTick', [50 100], 'YTicklabel', {'v_{o}','v_{f}'})
set(gca, 'box', 'off', 'FontSize', 24);
plot([1250, 1250], [0, 50], 'black:', 'LineWidth', 4)
plot([0, 1250], [50, 50], 'black:', 'LineWidth', 4)
axis([0, 1350, 0, 110]);
xlabel('flow (pcu/hr)', 'FontName','Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
ylabel('velocity (km/hr)', 'FontName','Times New Roman', 'FontSize', 24, 'FontWeight', 'bold');
title('Flow-Velocity', 'FontSize', 24);