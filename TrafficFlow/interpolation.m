function ynew = interpolation(y, number)
n = length(y);
x = linspace(0, 1, n);
xnew = linspace(0, 1, number); 
ynew = interp1(x, y, xnew, 'spline');
end