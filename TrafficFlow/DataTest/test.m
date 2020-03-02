clear;

% Load data
density09 = csvread('D:/Thesis/data/201509_density.csv', 1, 1);
density10 = csvread('D:/Thesis/data/201510_density.csv', 1, 1);
SARIMA = csvread('D:/Thesis/data/prediction/Seasonal_ARIMA/SARIMA.csv', 1, 1);
LSTM = load('D:/Thesis/data/prediction/LSTM/LSTM_30min.mat');
LSTM = LSTM.out;

start_time = 288*5;
end_time = 12;
past_time = 6;
want_predict_time = 6;
update_time = 1;
dt = 5;

sensor1 = reshape(LSTM(1,:,:),8928, want_predict_time);
u_SARIMA = SARIMA(start_time:end_time,:)';
u_SARIMA(u_SARIMA<0) = 0;
u_LSTM = reshape(LSTM(:,:,end), 38, 8928);
u_LSTM = u_LSTM(:,start_time:start_time+want_predict_time);

initial = [density09(length(density09)-(past_time+want_predict_time-1):end,:); density10]';
left = initial(1,:);
right = initial(end,:);

for i = start_time:start_time
    history = initial(:,i+past_time:i+past_time+want_predict_time);
    left_real = left(i:i+past_time+want_predict_time);
    [u_grid_real_EX, u_pre_real_EX] = Traffic_EX(history(:, 1), left_real, past_time, want_predict_time, dt);
    u_pre_real_EX = real(u_pre_real_EX);
    u_grid_real_EX = real(u_grid_real_EX);
end

for i = start_time:start_time
    history = initial(:,i:i+past_time+want_predict_time);
    left_real = left(i:i+past_time+want_predict_time);
    [u_grid_real_KF, u_pre_real_KF] = Traffic_KF(history, left_real, past_time, want_predict_time, update_time, dt);
    u_pre_real_KF = real(u_pre_real_KF(:,past_time+1:end));
    u_grid_real_KF = real(u_grid_real_KF(:,past_time*60+1:end));
end

for i = start_time:start_time
    history = [initial(:,i+past_time), reshape(LSTM(:,i,:), 38, want_predict_time)];
    left_LSTM = [left(i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid_LSTM_EX, u_pre_LSTM_EX] = Traffic_EX(history(:, 1), left_LSTM, past_time, want_predict_time, dt);
    u_pre_LSTM_EX = real(u_pre_LSTM_EX);
    u_grid_LSTM_EX = real(u_grid_LSTM_EX);
end

for i = start_time:start_time
    history = [initial(:,i:i+past_time), reshape(LSTM(:,i,:), 38, want_predict_time)];
    left_LSTM = [left(i:i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid_LSTM_KF, u_pre_LSTM_KF] = Traffic_KF(history, left_LSTM, past_time, want_predict_time, update_time, dt);  
    u_pre_LSTM_KF = real(u_pre_LSTM_KF(:,past_time+1:end));
    u_grid_LSTM_KF = real(u_grid_LSTM_KF(:,past_time*60+1:end));
end

for i = start_time:start_time
    history = [initial(:,i+past_time), reshape(LSTM(:,i,:),38,want_predict_time)];
    left_LSTM = [left(i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid_LSTMKF, u_pre_LSTMKF] = Traffic_LSTMKF(history, left_LSTM, past_time, want_predict_time, update_time, dt);
    u_pre_LSTMKF = real(u_pre_LSTMKF);
    u_grid_LSTMKF = real(u_grid_LSTMKF);
end

u_density = initial(:, start_time+past_time:start_time+past_time+want_predict_time);

% plot result
tstart = datenum('2015-10-01 00:00:00');% 開始時間
tend = datenum('2015-10-01 00:30:00');% 結束時間
x1 = linspace(tstart, tend, want_predict_time+1);
x2 = linspace(tstart, tend, want_predict_time*60+1);

figure(1)
sensor = 20;
hold on; grid on;
set(gca, 'xtick', x1, 'box', 'off', 'FontSize', 24);
datetick('x','HH:MM', 'keepticks');
f1_o = plot(x1, u_density(sensor, :), 'blacko','LineWidth', 3, 'Markersize', 20);
f2_o = plot(x1, u_LSTM(sensor, :), 'ro', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'r');
f3__ = plot(x2, u_grid_LSTM_EX(sensor, :), 'b-.', 'LineWidth', 6);
f3_o = plot(x1, u_pre_LSTM_EX(sensor, :), 'bo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'b');
for i = 1:want_predict_time
    f4__ = plot(x2((i-1)*60+2:i*60+1), u_grid_LSTMKF(sensor, (i-1)*60+2:i*60+1), 'm-.', 'LineWidth', 6);
end
f4_o = plot(x1, u_pre_LSTMKF(sensor, :), 'mo', 'LineWidth', 3, 'MarkerSize', 20, 'MarkerEdgeColor','k', 'MarkerFaceColor', 'm');
legend([f1_o, f2_o, f3_o, f4_o], 'ground truth', 'Pseudo observed value (LSTM)','Predicted value (LSTMEX)', 'Corrected value (LSTMKF)', 'Location', 'northwest');
xlabel('Time (HH:MM)', 'fontsize', 32);
ylabel('Density (veh/km)', 'fontsize', 32);
axis([tstart-0.001, tend+0.001, 20, 60]);
hold off;