function Result = CalcPerf(True, Test)
% INPUT 
% True M x N
% Test M x N

% Output
% Result-struct
% 1. MSE (Mean Squared Error)
% 2. PSNR (Peak signal-to-noise ratio)
% 3. R Value
% 4. RMSE (Root-mean-square deviation)
% 5. NRMSE (Normalized Root-mean-square deviation)
% 6. MAPE (Mean Absolute Percentage Error)
% 7. MAAPE (Mean Arctangent Absolute Percentage Error)
%% geting size and condition checking
[True_row, True_col, True_dim] = size(True);
[Test_row, Test_col, Test_dim] = size(Test);
if True_row~=Test_row || True_col~=Test_col || True_dim~=Test_dim
    error('Input must have same dimentions')
end
%% Common function for matrix
% Mean for Matrix
meanmat = @(a)(mean(mean(a)));
% Sum for Matrix
summat = @(a)(sum(sum(a)));
% Min  for Matrix
minmat = @(a)(min(min(a)));
% Max  for Matix
maxmat = @(a)(max(max(a)));
%% MSE Mean Squared Error
Result.MSE = meanmat((True-Test).^2);
%% PSNR Peak signal-to-noise ratio
range = [1, 255];
if max(True(:))>1
    maxI = range(2);
else
    maxI = range(1);
end
Result.PSNR = 10*log10(maxI^2/Result.MSE);
%% R Value
Result.Rvalue = 1-abs(summat((Test-True).^2)/summat(True.^2));
%% RMSE Root-mean-square deviation
Result.RMSE = abs(sqrt(meanmat((Test-True).^2)));
%% Normalized RMSE Normalized Root-mean-square deviation
Result.NRMSE = Result.RMSE/(maxmat(True)-minmat(True));
%% MAPE Mean Absolute Percentage Error
Result.Mape = meanmat(abs(Test-True)./True)*100;
%% MAPPE Mean Absolute Percentage Error
Result.Maape = meanmat(atan(abs((Test-True)./True)))*100;