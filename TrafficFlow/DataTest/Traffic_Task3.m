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
end_time = 288*31;
past_time = 6;
want_predict_time = 3;
update_time = 1;
dt = 5;

sensor1 = reshape(LSTM(1,:,:),8928, want_predict_time);
% u_SARIMA = SARIMA(start_time:end_time,:)';
u_LSTM = reshape(LSTM(:,:,end), 38, 8928);
u_LSTM = u_LSTM(:,start_time:end_time);

initial = [density09(length(density09)-(past_time+want_predict_time-1):end,:); density10]';
left = initial(1,:);
right = initial(end,:);

u_real_EX = zeros(size(u_LSTM));
tic
for i = start_time:end_time
    history = initial(:,i+past_time:i+past_time+want_predict_time);
    left_real = left(i:i+past_time+want_predict_time);
    [u_grid, u_pre] = Traffic_EX(history(:, 1), left_real, past_time, want_predict_time, dt);
    u_real_EX(:,i-start_time+1) = u_pre(:,end);
    u_real_EX = real(u_real_EX);
end
toc

u_real_KF = zeros(size(u_LSTM));
tic
for i = start_time:end_time
    history = initial(:,i:i+past_time+want_predict_time);
    left_real = left(i:i+past_time+want_predict_time);
    [u_grid, u_pre] = Traffic_KF(history, left_real, past_time, want_predict_time, update_time, dt);
    u_real_KF(:,i-start_time+1) = u_pre(:,end);
    u_real_KF = real(u_real_KF);
end
toc

u_LSTM_EX = zeros(size(u_LSTM));
tic
for i = start_time:end_time
    history = [initial(:,i+past_time), reshape(LSTM(:,i,:), 38, want_predict_time)];
    left_LSTM = [left(i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid, u_pre] = Traffic_EX(history(:, 1), left_LSTM, past_time, want_predict_time, dt);
    u_LSTM_EX(:,i-start_time+1) = u_pre(:,end);
    u_LSTM_EX = real(u_LSTM_EX);
end
toc

u_LSTM_KF = zeros(size(u_LSTM));
tic
for i = start_time:end_time
    history = [initial(:,i:i+past_time), reshape(LSTM(:,i,:), 38, want_predict_time)];
    left_LSTM = [left(i:i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid, u_pre] = Traffic_KF(history, left_LSTM, past_time, want_predict_time, update_time, dt);  
    u_LSTM_KF(:,i-start_time+1) = u_pre(:,end);
    u_LSTM_KF = real(u_LSTM_KF);
end
toc

u_LSTMKF = zeros(size(u_LSTM));
tic
for i = start_time:end_time
    history = [initial(:,i+past_time), reshape(LSTM(:,i,:),38,want_predict_time)];
    left_LSTM = [left(i:i+past_time), sensor1(i,1:want_predict_time)];
    [u_grid, u_pre] = Traffic_LSTMKF(history, left_LSTM, past_time, want_predict_time, update_time, dt);
    u_LSTMKF(:,i-start_time+1) = u_pre(:,end);
    u_LSTMKF = real(u_LSTMKF);
end
toc

u_density = initial(:, past_time+start_time+want_predict_time:past_time+end_time+want_predict_time);
u_speed = speed(start_time:end_time,:);
Result_real_EX = CalcPerf(u_density(2:end, :), u_real_EX(2:end, :));
Result_real_KF = CalcPerf(u_density(2:end, :), u_real_KF(2:end, :));
Result_LSTM_EX = CalcPerf(u_density(2:end, :), u_LSTM_EX(2:end, :));
Result_LSTM_KF = CalcPerf(u_density(2:end, :), u_LSTM_KF(2:end, :));
Result_LSTMKF = CalcPerf(u_density(2:end, :), u_LSTMKF(2:end, :));
% Result_SARIMA = CalcPerf(u_density(2:end, :), u_SARIMA(2:end, :));
Result_LSTM = CalcPerf(u_density(2:end, :), u_LSTM(2:end, :));

fprintf('---------------------------------------------------------- \n')
fprintf(' The rmse of density with real boundary is %5.2f. \n', Result_real_EX.RMSE);
fprintf(' The maape of density with real boundary is %5.2f. \n', Result_real_EX.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with real boundary by KF is %5.2f. \n', Result_real_KF.RMSE);
fprintf(' The maape of density with real boundary by KF is %5.2f. \n', Result_real_KF.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM_EX.RMSE);
fprintf(' The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM_EX.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with LSTM boundary by KF is %5.2f. \n', Result_LSTM_KF.RMSE);
fprintf(' The maape of density with LSTM boundary by KF is %5.2f. \n', Result_LSTM_KF.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with LSTMKF is %5.2f. \n', Result_LSTMKF.RMSE);
fprintf(' The maape of density with LSTMKF is %5.2f. \n', Result_LSTMKF.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
% fprintf(' The rmse of density with SARIMA is %5.2f. \n', Result_SARIMA.RMSE);
% fprintf(' The maape of density with SARIMA is %5.2f. \n', Result_SARIMA.Maape);
% fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  \n')
fprintf(' The rmse of density with LSTM attention is %5.2f. \n', Result_LSTM.RMSE);
fprintf(' The maape of density with LSTM attention is %5.2f. \n', Result_LSTM.Maape);
fprintf('---------------------------------------------------------- \n')

% % plot result
% tstart = datenum('2015-10-01 00:00:00');% 開始時間
% tend = datenum('2015-10-02 00:00:00');% 結束時間
% x = 1:38; % 38個間隔
% y = linspace(tstart, tend, 288+1);
% [xx, yy] = meshgrid(x, y);
% 
% figure(1);
% subplot(2,2,1);
% contourf(xx, yy, u_density', 4, 'Linewidth', 0.1);
% set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y(1:12*6:end), 'FontSize', 16);
% datetick('y','HH:MM', 'keepticks');
% xlabel('Sensor number', 'fontsize', 24) ;
% ylabel('Time', 'fontsize', 24);
% title('Ground truth', 'FontSize', 24);
% caxis([0 60]) 
% colorbar;
% colormap(mycolor);
% 
% subplot(2,2,2);
% contourf(xx, yy, u_real_EX', 3, 'Linewidth', 0.1);
% set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y(1:12*6:end), 'FontSize', 16);
% datetick('y','HH:MM', 'keepticks');
% xlabel('Sensor number', 'fontsize', 24) ;
% ylabel('Time', 'fontsize', 24);
% title('EX', 'FontSize', 24);
% caxis([0 60]) 
% colorbar;
% colormap(mycolor);
% 
% subplot(2,2,3);
% contourf(xx, yy, u_LSTMKF', 5, 'Linewidth', 0.1);
% set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y(1:12*6:end), 'FontSize', 16);
% datetick('y','HH:MM', 'keepticks');
% xlabel('Sensor number', 'fontsize', 24) ;
% ylabel('Time', 'fontsize', 24);
% title('LSTMKF', 'FontSize', 24);
% caxis([0 60]) 
% colorbar;
% colormap(mycolor);
% 
% subplot(2,2,4);
% contourf(xx, yy, u_LSTM', 5, 'Linewidth', 0.1);
% set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y(1:12*6:end), 'FontSize', 16);
% datetick('y','HH:MM', 'keepticks');
% xlabel('Sensor number', 'fontsize', 24) ;
% ylabel('Time', 'fontsize', 24);
% title('LSTM', 'FontSize', 24);
% caxis([0 60]) 
% colorbar;
% colormap(mycolor);