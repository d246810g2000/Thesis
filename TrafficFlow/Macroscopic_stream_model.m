clear;

x = linspace(0.1, 150, 100);
% plot Greenshield's linear model
figure(1)
vf = 85; kj = 50;
f1 = @(k) vf.*(1-k./kj);
hold on; 
plot(x, f1(x), 'red-', 'LineWidth', 5);
set(gca, 'xtick', [], 'ytick', [], 'box', 'off');
axis([1, 60, 0, 120]);
xlabel('density (pcu/km)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [20 -1.8 0]);
ylabel('velocity (km/hr)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [-1 42 0]);
annotation('arrow', [0.53 0.75], [0.048 0.048], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
annotation('arrow', [0.088 0.088], [0.68 0.88], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
text(-1.4, 86, '$v_f$','FontSize', 40, 'Interpreter', 'latex');
text(49, -5, '$\rho_{jam}$','FontSize', 40, 'Interpreter', 'latex');

% %plot Greenberg's logarithmic model
% figure(2)
% vf = 85; kj = 50;
% f1 = @(k) vf.*(1-k./kj);
% hold on; 
% plot(x, f1(x), 'black--', 'LineWidth', 5);
% 
% vo = 50; kj = 55;
% f2 = @(k) vo.*log(kj./k);
% p2 = plot(x, f2(x), 'red-', 'LineWidth', 5);
% set(gca, 'xtick', [], 'ytick', [], 'box', 'off');
% axis([1, 60, 0, 200]);
% xlabel('density (pcu/km)', 'FontName', 'Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [20 -3 0]);
% ylabel('velocity (km/hr)', 'FontName', 'Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [0 70 0]);
% annotation('arrow', [0.51 0.75], [0.055 0.055], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
% annotation('arrow', [0.103 0.103], [0.65 0.85], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
% 
% % plot Underwood's exponential model
% figure(3)
% vf = 85; kj = 50;
% f1 = @(k) vf.*(1-k./kj);
% hold on; 
% plot(x, f1(x), 'black--', 'LineWidth', 5);
% 
% vf = 95; ko = 28;
% f3 = @(k) vf.*exp(-k./ko);
% p3 = plot(x, f3(x), 'red-', 'LineWidth', 5);
% set(gca, 'xtick', [], 'ytick', [], 'box', 'off');
% axis([1, 60, 0, 120]);
% xlabel('density (pcu/km)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [20 -1.8 0]);
% ylabel('velocity (km/hr)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [0 42 0]);
% annotation('arrow', [0.51 0.75], [0.055 0.055], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
% annotation('arrow', [0.103 0.103], [0.65 0.85], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
% 
% % plot The MacNicholas model
% figure(4)
% vf = 85; kj = 50;
% f1 = @(k) vf.*(1-k./kj);
% hold on; 
% plot(x, f1(x), 'black--', 'LineWidth', 5);
% 
% vf = 82; kj = 70; n = 2; m = 6.83;
% f4 = @(k) vf.*((kj.^n-k.^n)./(kj.^n+m.*k.^n));
% p4 = plot(x, f4(x), 'red-', 'LineWidth', 5);
% set(gca, 'xtick', [], 'ytick', [], 'box', 'off');
% axis([1, 60, 0, 120]);
% xlabel('density (pcu/km)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [20 -1.8 0]);
% ylabel('velocity (km/hr)', 'FontName','Times New Roman', 'FontSize', 45, 'FontWeight', 'bold', 'Position', [0 42 0]);
% annotation('arrow', [0.51 0.75], [0.055 0.055], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);
% annotation('arrow', [0.103 0.103], [0.65 0.85], 'LineStyle', '-', 'LineWidth', 8, 'HeadLength', 50, 'HeadWidth', 50);