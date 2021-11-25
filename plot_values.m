function [] = plot_values(x, y, title, modelId, rotType, numIters, maxAngle)
    plot(x, y, 'b--o');
    xlabel('Angle');
    ylabel(title);
    xlim([0 maxAngle]);
    plt = gca;
    plotFileName = ['./performance/', modelId, '_', lower(title), rotType, '_', num2str(numIters), 'i.png'];
    exportgraphics(plt, plotFileName, 'Resolution', 300);
    dataFileName = ['./performance/', modelId, '_', lower(title), rotType, '_', num2str(numIters), 'i.csv'];
    writematrix(transpose(y), dataFileName);
end
