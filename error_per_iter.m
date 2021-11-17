function [errors, times] = error_per_iter(originalModel, transformedModel, triesPerIter, maxTraslation, maxRotation, maxIterationsVector)
    errors = zeros(triesPerIter, length(maxIterationsVector));
    times = zeros(triesPerIter, length(maxIterationsVector));
    for t = 1:triesPerIter
        rotX = deg2rad(round(rand(1, maxRotation), 0));
        rotY = deg2rad(round(rand(1, maxRotation), 0));
        rotZ = deg2rad(round(rand(1, maxRotation), 0));

        trsX = rand(1, maxTraslation);
        trsY = rand(1, maxTraslation);
        trsZ = rand(1, maxTraslation);

        columnIndex = 1;
        for maxIter = maxIterationsVector
            fprintf('Try: %d Max iteration: %d \n', t, maxIter);

            originalCloud = pcread(originalModel);
            transformedCloud = pcread(transformedModel);

            initialTransformation = transformation_matrix(rotX, rotY, rotZ, trsX, trsY, trsZ);
            ptCloudTransformed = pctransform(transformedCloud, initialTransformation);
            
            tic;
            [~, ~, rmse] = pcregistericp(ptCloudTransformed, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIter, 'Tolerance', [0.001, 0.005]);
            elapsedTime = toc;
            elapsedTime = elapsedTime * 1000;

            fprintf('Error: %f Time[ms]: %f \n\n', rmse, elapsedTime);
            errors(t, columnIndex) = rmse;
            times(t, columnIndex) = elapsedTime;
            columnIndex = columnIndex + 1;
        end
    end
end
