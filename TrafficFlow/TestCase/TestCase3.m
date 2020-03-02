clear;

vmax = 100; kmax = 50;
v = @(k) vmax.*(1-k/kmax); 
q = @(k) k*vmax.*(1-k/kmax);
Q = @(k) vmax-(2*vmax/kmax)*k; % q'
G = @(k) (vmax-k)*(kmax/(2*vmax));
update_time = 1;

dx = 100; dt = 2.5;
XX = 40; TT = 30;

% 邊界條件
kl = 30; kr = 50;

% exact solution
u_exact = zeros(XX*1000/dx, TT*60/dt+1);
N = length(u_exact(1,:));
J = length(u_exact(:,1));
u_exact(1:J/2,1) = kl; u_exact(J/2+1:end,1) = kr;
u_exact(1,:) = kl;
x = linspace(-20,20,J); x(x==0)=[];
t = linspace(0,TT/60,N);
for n = 1:N-1
    for i = 2:J
        sigma = (q(kr)-q(kl))/(kr-kl);
        if x(i)/t(n+1)<sigma
            u_exact(i,n+1) = kl;
        else
            u_exact(i,n+1) = kr;
        end
    end
end

u_real = 0.5*randn(size(u_exact)) + u_exact;

left = u_real(1,:); right = u_real(end,:);
history = u_real(:,1:(N-1)/6:(N+1)/2);

tic
u_EX = TestCase_EX(history(:,end), left((N+1)/2:end), right((N+1)/2:end), dx, dt, XX, TT);
toc

tic
u_KF = TestCase_KF(history, left, right, dx, dt, XX, TT, update_time);
toc

Result_EX = CalcPerf(u_exact(2:end,end), u_EX(2:end));
Result_KF = CalcPerf(u_exact(2:end,end), u_KF(2:end));
error_EX = abs(u_exact(:,end)-u_EX);
error_KF = abs(u_exact(:,end)-u_KF);

fprintf('RMSE is %5.2f, Maape is %5.2f\n',Result_EX.RMSE, Result_EX.Maape);
fprintf('RMSE is %5.2f, Maape is %5.2f\n',Result_KF.RMSE, Result_KF.Maape);

% plot result
[xx,tt] = meshgrid(x,t*60);
figure(1)
subplot(1,2,1);
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
mesh(xx, tt, u_exact');
colormap; colorbar;
xlabel('x (km)', 'FontSize', 24);
ylabel('t (min)', 'FontSize', 24);
zlabel('density (pcu/km)', 'FontSize', 24);
title('Ground truth (Density)') 
set(gca,'XTickMode','manual', 'FontSize', 24);
set(gca, 'YTick', [0, 15, 30], 'YTickMode', 'manual', 'FontSize', 24);
view([0,90]);  

subplot(1,2,2);
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
mesh(xx, tt, v(u_exact)');
colormap; colorbar;
xlabel('x (km)', 'FontSize', 24);
ylabel('t (min)', 'FontSize', 24);
zlabel('velocity (km/hr)', 'FontSize', 24);
title('Ground truth (Velocity)') 
set(gca,'XTickMode','manual', 'FontSize', 24);
set(gca, 'YTick', [0, 15, 30], 'YTickMode', 'manual', 'FontSize', 24);
view([0,90]);  

figure(2)
subplot(1,2,1);
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
plot(x, u_exact(:,end), 'Color', [0.9290 0.6940 0.1250], 'LineWidth', 2); hold on;
plot(x, u_EX, 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2);
plot(x, u_KF, 'Color', [0 0.4470 0.7410], 'LineWidth', 2);
legend('Ground truth', 'Explicit method', 'Kalman Filter', 'location', 'southeast');
xlabel('x (km)');
ylabel('density (pcu/km)');
title('Prediction at 30 min')
set(gca, 'XTick', [-20:10:20], 'XTickMode','manual', 'FontSize', 24);
set(gca, 'YTick', [30, 40, 50], 'YTickMode','manual', 'FontSize', 24);
axis([-20, 20, 30, 52]);

subplot(1,2,2);
set(gcf,'unit','normalized','position',[0,0.2,1,0.6])
plot(x(3:end-2), error_EX(3:end-2), 'Color', [0.8500 0.3250 0.0980], 'LineWidth', 2); hold on;
plot(x(3:end-2), error_KF(3:end-2), 'Color', [0 0.4470 0.7410], 'LineWidth', 2);
legend('Explicit method', 'Kalman Filter', 'location', 'northwest');
xlabel('x (km)');
ylabel('density (pcu/km)');
title('Prediction error at 30 min')
set(gca, 'XTick', [-20:10:20], 'XTickMode','manual', 'FontSize', 24);
set(gca, 'YTick', [0, 0.2, 0.4], 'YTickMode','manual', 'FontSize', 24);
axis([-20, 20, 0, 0.4]);