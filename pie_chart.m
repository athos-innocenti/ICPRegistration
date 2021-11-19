function [] = pie_chart(errors, times, numPies)
    pieSectionsE = zeros(1, numPies);
    labelsE = zeros(1, numPies);
    maxError = max(errors);
    for i = 1:numPies
        trsError = (maxError / numPies) * i;
        valuesIndexes = errors <= trsError;
        pieSectionsE(1, i) = length(errors(valuesIndexes));
    end
    pie(pieSectionsE);
    title('Error');

    pieSectionsT = zeros(1, numPies);
    labelsT = zeros(1, numPies);
    maxTime = max(times);
    for i = 1:numPies
        trsTime = (maxTime / numPies) * i;
        valuesIndexes = times <= trsTime;
        pieSectionsE(1, i) = length(times(valuesIndexes));
    end
    pie(pieSectionsT);
    title('Time');
end