clear; 

LSTM_15 = load('D:/Thesis/data/prediction/LSTM/LSTM_15min.mat');
LSTM_15 = LSTM_15.out;
u_LSTM_15 = reshape(LSTM_15(:,:,end), 38, 288*31);
LSTM_30 = load('D:/Thesis/data/prediction/LSTM/LSTM_30min.mat');
LSTM_30 = LSTM_30.out;
u_LSTM_30 = reshape(LSTM_30(:,:,end), 38, 288*31);
density10 = csvread('D:/Thesis/data/201510_density.csv', 1, 1);
u_density = density10';

figure(1)
subplot(2,1,1)
tstart = datenum('2015-10-01 00:00:00');% 開始時間
tend = datenum('2015-10-02 00:00:00');% 結束時間
x = linspace(tstart, tend, 288+1);
plot(x, u_density(1,1:288+1), 'LineWidth', 2); hold on;
plot(x, u_LSTM_15(1,1:288+1), 'LineWidth', 2);
set(gca, 'XTick', x(1:12*3:end), 'FontSize', 16);
datetick('x','HH:MM', 'keepticks');
legend('True denstiy', 'Prediction')
axis([-inf, inf, 0, 50]);
title('Using LSTM Attention to predict density after 15 minutes', 'fontsize', 24)
xlabel('Time (HH:MM)', 'fontsize', 24);
ylabel('density (pcu/km)', 'fontsize', 24) ;

subplot(2,1,2)
tstart = datenum('2015-10-01 00:00:00');% 開始時間
tend = datenum('2015-10-02 00:00:00');% 結束時間
x = linspace(tstart, tend, 288+1);
plot(x, u_density(1,1:288+1), 'LineWidth', 2); hold on;
plot(x, u_LSTM_30(1,1:288+1), 'LineWidth', 2);
set(gca, 'XTick', x(1:12*3:end), 'FontSize', 16);
datetick('x','HH:MM', 'keepticks');
legend('True denstiy', 'Prediction')
axis([-inf, inf, 0, 50]);
title('Using LSTM Attention to predict density after 30 minutes', 'fontsize', 24)
xlabel('Time (HH:MM)', 'fontsize', 24);
ylabel('density (pcu/km)', 'fontsize', 24) ;

Result_LSTM_15 = CalcPerf(u_density(2:end,1:288+1), u_LSTM_15(2:end,1:288+1));
Result_LSTM_30 = CalcPerf(u_density(2:end,1:288+1), u_LSTM_30(2:end,1:288+1));

fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')
fprintf('The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM_15.RMSE);
fprintf('The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM_15.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')
fprintf('The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM_30.RMSE);
fprintf('The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM_30.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')

figure(2)
subplot(2,1,1)
tstart = datenum('2015-10-06 00:00:00');% 開始時間
tend = datenum('2015-10-07 00:00:00');% 結束時間
x = linspace(tstart, tend, 288+1);
plot(x, u_density(1,288*5:288*6), 'LineWidth', 2); hold on;
plot(x, u_LSTM_15(1,288*5:288*6), 'LineWidth', 2);
set(gca, 'XTick', x(1:12*3:end), 'FontSize', 16);
datetick('x','HH:MM', 'keepticks');
legend('True denstiy', 'Prediction')
axis([-inf, inf, 0, 150]);
title('Using LSTM Attention to predict left boundary after 15 minutes', 'fontsize', 24)
xlabel('Time (HH:MM)', 'fontsize', 24);
ylabel('density (pcu/km)', 'fontsize', 24) ;

subplot(2,1,2)
tstart = datenum('2015-10-06 00:00:00');% 開始時間
tend = datenum('2015-10-07 00:00:00');% 結束時間
x = linspace(tstart, tend, 288+1);
plot(x, u_density(1,288*5:288*6), 'LineWidth', 2); hold on;
plot(x, u_LSTM_30(1,288*5:288*6), 'LineWidth', 2);
set(gca, 'XTick', x(1:12*3:end), 'FontSize', 16);
datetick('x','HH:MM', 'keepticks');
legend('True denstiy', 'Prediction')
axis([-inf, inf, 0, 150]);
title('Using LSTM Attention to predict left boundary after 30 minutes', 'fontsize', 24)
xlabel('Time (HH:MM)', 'fontsize', 24);
ylabel('density (pcu/km)', 'fontsize', 24) ;

Result_LSTM2_15 = CalcPerf(u_density(2:end,288*5:288*6), u_LSTM_15(2:end,288*5:288*6));
Result_LSTM2_30 = CalcPerf(u_density(2:end,288*5:288*6), u_LSTM_30(2:end,288*5:288*6));

fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')
fprintf('The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM2_15.RMSE);
fprintf('The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM2_15.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')
fprintf('The rmse of density with LSTM boundary is %5.2f. \n', Result_LSTM2_30.RMSE);
fprintf('The maape of density with LSTM boundary is %5.2f. \n', Result_LSTM2_30.Maape);
fprintf('- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   \n')