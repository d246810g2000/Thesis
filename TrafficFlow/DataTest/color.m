
x1 = [65 105 225]; 
x2 = [6 239 136]; 
x3 = [249 251 20]; 
x4 = [255 69 0];
x5 = [176 23 31];
x6 = [0 0 0];

mycolorpoint=[x1; x2; x3; x4; x5; x6];
mycolorposition=[1 12 15 40 50 64];
mycolormap_r=interp1(mycolorposition,mycolorpoint(:,1),1:64,'linear','extrap');
mycolormap_g=interp1(mycolorposition,mycolorpoint(:,2),1:64,'linear','extrap');
mycolormap_b=interp1(mycolorposition,mycolorpoint(:,3),1:64,'linear','extrap');
mycolor=[mycolormap_r',mycolormap_g',mycolormap_b']/256;
mycolor=round(mycolor*10^4)/10^4;%保留4位小數

contourf(xx, yy, u_density');
set(gca, 'XTick', [1, 4, 7, x(10:4:38)], 'YTick', y(1:12*6:end), 'FontSize', 16);
datetick('y','HH:MM', 'keepticks');
xlabel('Sensor', 'fontsize', 24) ;
ylabel('Time', 'fontsize', 24);
title('Ground truth', 'FontSize', 24);
caxis([0 150]) 
colorbar;
colormap(mycolor);