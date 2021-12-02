function [] = pie_chart(errors, times, maxIterations, numPies)
    xLimit = size(errors, 1);
    labels = string(maxIterations);
    
    writematrix(times, './performance/times.csv');
    for i=1:size(times, 2)
        plot(1:xLimit, times(:, i), 'Marker', '.');
        ylabel('Time [ms]');
        ptt = gca;
        fileName = ['./performance/times_', num2str(maxIterations(1, i)), '.png'];
        exportgraphics(ptt, fileName, 'Resolution', 600);
    end
    pt = plot(1:xLimit, times(:, 1), 1:xLimit, times(:, 2), 1:xLimit, times(:, 3), 1:xLimit, times(:, 4));
    pt(1).Marker = '.';
    pt(2).Marker = '.';
    pt(3).Marker = '.';
    pt(4).Marker = '.';
    ylabel('Time [ms]');
    legend(labels, 'NumColumns', 4);
    plt1 = gca;
    exportgraphics(plt1, './performance/times.png', 'Resolution', 600);
    
    writematrix(errors, './performance/errors.csv');
    for i=1:size(errors, 2)
        plot(1:xLimit, errors(:, i), 'Marker', '.');
        ylabel('Rmse');
        pte = gca;
        fileName = ['./performance/errors_', num2str(maxIterations(1, i)), '.png'];
        exportgraphics(pte, fileName, 'Resolution', 600);
    end
    pe = plot(1:xLimit, errors(:, 1), 1:xLimit, errors(:, 2), 1:xLimit, errors(:, 3), 1:xLimit, errors(:, 4));
    pe(1).Marker = '.';
    pe(2).Marker = '.';
    pe(3).Marker = '.';
    pe(4).Marker = '.';
    ylabel('Rmse');
    legend(labels, 'NumColumns', 4);
    plt2 = gca;
    exportgraphics(plt2, './performance/errors.png', 'Resolution', 600);
    
    t = tiledlayout(2, 2, 'TileSpacing', 'compact');
    for maxIters = 1:size(errors, 2)
        maxError = max(max(errors));
        minError = 0;
        step = (maxError - minError)/numPies;
        percent = zeros(1, numPies);
        trshs = zeros(1, numPies);
        ers = errors(:,maxIters);
        for i = 1:numPies
            trsh_min = minError;
            trsh_max = minError + step;
            percent(1, i) = length(ers(ers > trsh_min & ers <= trsh_max));
            trshs(1, i) = trsh_max;
            minError = trsh_max;
        end
        ax = nexttile([1 1]);
        pie(ax, percent);
        title([num2str(maxIterations(1, maxIters)), ' Iterations']);
    end
    labels = {['(0, ',num2str(trshs(1, 1)),']'], ['(',num2str(trshs(1, 1)), ', ', num2str(trshs(1, 2)),']']};
    lgd = legend(labels);
    title(lgd, 'Rmse');
    lgd.Layout.Tile = 'east';
    exportgraphics(t, './performance/oc_piechart.png', 'Resolution', 600);
end
