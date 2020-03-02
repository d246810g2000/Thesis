clear;

% Load data
load mycolor;
density09 = csvread('D:/Thesis/data/201509_density.csv', 1, 1);
density10 = csvread('D:/Thesis/data/201510_density.csv', 1, 1);
flow = csvread('D:/Thesis/data/201510_flow.csv', 1, 1);
speed = csvread('D:/Thesis/data/201510_speed.csv', 1, 1);
SARIMA = csvread('D:/Thesis/data/prediction/Seasonal_ARIMA/SARIMA.csv', 1, 1);
LSTM = load('D:/Thesis/data/prediction/LSTM/LSTM_15min.mat');
LSTM = LSTM.out;

start_time = 288*0+1;
end_time = 12;
past_time = 6;
want_predict_time = 3;
update_time = 1;
dt = 5;

sensor1 = reshape(LSTM(1,:,:),8928, want_predict_time);
u_SARIMA = SARIMA(start_time:end_time,:)';
u_SARIMA(u_SARIMA<0) = 0;
u_LSTM = reshape(LSTM(:,:,end), 38, 8928);
u_LSTM = u_LSTM(:,start_time:end_time);

initial = [density09(length(density09)-(past_time+want_predict_time-1):end,:); density10]';
left = initial(1,:);
right = initial(end,:);

tic

for i = start_time:end_time
    history = initial(:,i+past_time:i+past_time+want_predict_time);
    left_real = left(i:i+past_time+want_predict_time);
    right_real = right(i:i+past_time+want_predict_time);
    left_LSTM = [left(i:i+past_time), sensor1(i,1:want_predict_time)];
    right_LSTM = [right(i:i+past_time), sensor19(i,1:want_predict_time)];
    [u_grid_real, u_pre_real] = Traffic_EX(history(:, 1), left_real, right_real, past_time, dt);
    [u_grid_real_KF, u_pre_real_KF] = Traffic_EX_KF(history, left_real, right_real, past_time, update_time, dt);
    [u_grid_LSTM, u_pre_LSTM] = Traffic_EX(history(:, 1), left_LSTM, right_LSTM, past_time, dt);
    [u_grid_LSTM_KF, u_pre_LSTM_KF] = Traffic_EX_KF(history, left_LSTM, right_LSTM, past_time, update_time, dt);
end

toc

u_density = initial(:, past_time+start_time:past_time+start_time+want_predict_time);
Result_real = CalcPerf(u_density(2:end-1, 2:end), u_pre_real(2:end-1, 2:end));
Result_real_KF = CalcPerf(u_density(2:end-1, 2:end), u_pre_real_KF(2:end-1, 2:end));
Result_LSTM = CalcPerf(u_density(2:end-1, 2:end), u_pre_LSTM(2:end-1, 2:end));
Result_LSTM_KF = CalcPerf(u_density(2:end-1, 2:end), u_pre_LSTM_KF(2:end-1, 2:end));

fprintf('---------------------------------------------------------- \n')
fprintf(' The rmse of density with real boundary is %5.2f. \n', Result_real.RMSE);
fprintf(' The maape of density with real boundary is %5.2f. \n', Result_real.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with real boundary by using KF is %5.2f. \n', Result_real_KF.RMSE);
fprintf(' The maape of density with real boundary by using KF is %5.2f. \n', Result_real_KF.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM.RMSE);
fprintf(' The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM.Maape);
fprintf('---------------------------------------------------------- \n')
fprintf(' The rmse of density with LSTM boundary by using KF is %5.2f. \n', Result_LSTM_KF.RMSE);
fprintf(' The maape of density with LSTM boundary by using KF is %5.2f. \n', Result_LSTM_KF.Maape);
fprintf('---------------------------------------------------------- \n')

% plot result
sensor = 10;
N = (length(u_grid_real)-1)/want_predict_time;
tstart = datenum('2018-11-01 07:55:00');% 開始時間
tend = datenum('2018-11-01 08:55:00');% 結束時間
x1 = linspace(tstart, tend, want_predict_time+1);
x2 = linspace(tstart, tend, length(u_grid_real));

figure(1)
hold on; grid on;
set(gca, 'xtick', x1, 'box', 'off', 'FontSize', 24);
axis([tstart-0.001, tend+0.001, 0, 30]);
datetick('x','HH:MM', 'keepticks');
f1 = plot(x1, u_density(sensor, :), 'blacko','LineWidth', 3, 'Markersize', 20);
f2__ = plot(x2, u_grid_real(sensor, :), 'r-.', 'LineWidth', 6);
f2_o = plot(x1, u_pre_real(sensor, :), 'ro', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r');
f3__ = plot(x2, u_grid_LSTM(sensor, :), 'b-.', 'LineWidth', 6);
f3_o = plot(x1, u_pre_LSTM(sensor, :), 'bo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'b');
legend([f1, f2_o, f3_o], 'true', 'real boundary', 'LSTM boundary');
xlabel('Time (HH:MM)', 'fontsize', 32);
ylabel('Density (veh/km)', 'fontsize', 32);

% Using KF with real boundary
figure(2)
hold on; grid on;
set(gca, 'xtick', x1(1:2:end), 'box', 'off', 'FontSize', 24);
axis([tstart-0.001, tend+0.001, 0, 30]);
datetick('x','HH:MM', 'keepticks');
f1 = plot(x1, u_density(sensor, :), 'blacko','LineWidth', 3, 'Markersize', 20);
f2__ = plot(x2, u_grid_real(sensor, :), 'r-.', 'LineWidth', 6);
f2_o = plot(x1, u_pre_real(sensor, :), 'ro', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r');
for i = 1:want_predict_time
    f4__ = plot(x2((i-1)*N+2:i*N+1), u_grid_real_KF(sensor, (i-1)*N+2:i*N+1), 'g-.', 'LineWidth', 6);
end
f4_o = plot(x1, u_pre_real_KF(sensor, :), 'go', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'g');
legend([f1, f2_o, f4_o], 'true', 'real boundary', 'KF with real boundary', 'Location', 'northwest');
xlabel('Time (HH:MM)', 'fontsize', 32);
ylabel('Density (veh/km)', 'fontsize', 32);

% Using KF with LSTM boundary
figure(3)
hold on; grid on;
set(gca, 'xtick', x1(1:2:end), 'box', 'off', 'FontSize', 24);
axis([tstart-0.001, tend+0.001, 0, 30]);
datetick('x','HH:MM', 'keepticks');
f1 = plot(x1, u_density(sensor, :), 'blacko','LineWidth', 3, 'Markersize', 20);
f3__ = plot(x2, u_grid_LSTM(sensor, :), 'b-.', 'LineWidth', 6);
f3_o = plot(x1, u_pre_LSTM(sensor, :), 'bo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'b');
for i = 1:want_predict_time
    f5__ = plot(x2((i-1)*N+2:i*N+1), u_grid_LSTM_KF(sensor, (i-1)*N+2:i*N+1), 'm-.', 'LineWidth', 6);
end
f5_o = plot(x1, u_pre_LSTM_KF(sensor, :), 'mo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'm');
legend([f1, f3_o, f5_o], 'true', 'LSTM boundary', 'KF with LSTM boundary', 'Location', 'northwest');
xlabel('Time (HH:MM)', 'fontsize', 32);
ylabel('Density (veh/km)', 'fontsize', 32);
hold off;
