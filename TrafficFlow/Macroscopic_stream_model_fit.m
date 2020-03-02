clear;
data = load('D:/Thesis/data/data_kNN.mat');
data = data.out;
k = data.density;
v = data.speed;
q = k.*v;

x = linspace(0.1, 150, 100);
plot(k, v, '.','LineWidth', 1, 'Markersize', 10); hold on; 
set(gca, 'box', 'off', 'FontSize', 24);
set(gcf, 'unit', 'normalized', 'position', [0.15,0.05,0.75,0.85])
axis([0, 150, 0, 110]);
xlabel('density (pcu/km)', 'fontsize', 36);
ylabel('velocity (km/hr)', 'fontsize', 36);

% plot Greenshield's linear model
vf1 = 93.61; kj1 = 116.15;
f1 = @(k) vf1.*(1-k./kj1);
plot(x, f1(x), 'LineWidth', 4);

% plot Greenberg's logarithmic model
vo2 = 29.21; kj2 = 200;
f2 = @(k) vo2.*log(kj2./k);
plot(x, f2(x), 'LineWidth', 4);

% plot Underwood's exponential model
vf3 = 96.55; ko3 = 85.81;
f3 = @(k) vf3.*exp(-k./ko3);
plot(x, f3(x), 'LineWidth', 4);

% plot MacNicholas model (2008)
vf4 = 89.16; kj4 = 191.99; n = 1.81; m = 6.83;
f4 = @(k) vf4.*((kj4.^n-k.^n)./(kj4^n+m*k.^n));
plot(x, f4(x), 'LineWidth', 4)
legend('Density data', 'Greenshields linear model', 'Greenbergs logarithmic model', 'Underwoods exponential model', 'MacNicholas model');
