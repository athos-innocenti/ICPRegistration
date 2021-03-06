fileName_100Iterations_rmse = 'oc_rmse3D_100i.csv';
fileName_200Iterations_rmse = 'oc_rmse3D_200i.csv';
fileName_100Iterations_time = 'oc_time3D_100i.csv';
fileName_200Iterations_time = 'oc_time3D_200i.csv';
plotFileName = 'oc_3D.png';
legendTitle = 'Office Chair - 3D Rotation';
labels = {'100 Iterations', '200 Iterations'};
t = tiledlayout(20, 1);

x = 0:30:360;
values100Iterations_rmse = transpose(readmatrix(fileName_100Iterations_rmse));
values200Iterations_rmse = transpose(readmatrix(fileName_200Iterations_rmse));
values100Iterations_time = transpose(readmatrix(fileName_100Iterations_time));
values200Iterations_time = transpose(readmatrix(fileName_200Iterations_time));

ax1 = nexttile([10 1]);
p = plot(ax1, x, values100Iterations_rmse, x, values200Iterations_rmse);
xlim([0 360]);
p(1).Color = 'red';
p(1).Marker = '.';
p(1).MarkerSize = 10;
p(2).Color = 'blue';
p(2).Marker = '*';
xlabel(ax1, 'Angle');
ylabel(ax1, 'Rmse');

ax2 = nexttile([10 1]);
p = plot(ax2, x, values100Iterations_time, x, values200Iterations_time);
xlim([0 360]);
p(1).Color = 'red';
p(1).Marker = '.';
p(1).MarkerSize = 10;
p(2).Color = 'blue';
p(2).Marker = '*';
xlabel(ax2, 'Angle');
ylabel(ax2, 'Time');

lgd = legend(labels);
title(lgd, legendTitle);
lgd.Layout.Tile = 'east';

exportgraphics(t, plotFileName, 'Resolution', 600);