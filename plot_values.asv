function [] = plot_values(x, y, title, modelId, rotType, numIters)
    plot(x, y, 'b--o');
    xlabel('Angle');
    ylabel(title);
    plt = gca;
    plotFileName = ['./performance/', modelId, '_', lower(title), rotType, '_', num2str(numIters), 'i.png'];
    exportgraphics(plt, plotFileName);
    dataFileName = ['./performance/', modelId, '_', lower(title), rotType, '_', num2str(numIters), 'i.csv'];
    writematrix(transpose(y), dataFileName);
end
