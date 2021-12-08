function [initialErrors, errors, times] = centroid_icp(originalModel, transformedModel, triesPerIter, maxRotation, maxIterationsVector)
    initialErrors = zeros(triesPerIter, length(maxIterationsVector));
    errors = zeros(triesPerIter, length(maxIterationsVector));
    times = zeros(triesPerIter, length(maxIterationsVector));
    for t = 1:triesPerIter
        % Define a random 3D rotation matrix using the uniform distribution
        % between 0 and maxRotation
        rotX = randi([0 maxRotation], 1, 1);
        rotY = randi([0 maxRotation], 1, 1);
        rotZ = randi([0 maxRotation], 1, 1);
        initialRotation = transformation_matrix(deg2rad(rotX), deg2rad(rotY), deg2rad(rotZ), 0, 0, 0);
        
        columnIndex = 1;
        for maxIter = maxIterationsVector
            fprintf('Try:%d MaxIteration:%d \n', t, maxIter);
            fprintf('ROTATION x:%d° y:%d° z:%d° \n', rotX, rotY, rotZ);
            
            originalCloud = pcread(originalModel);
            movingCloud = pcread(transformedModel);
            
            rotatedCloud = pctransform(movingCloud, initialRotation);
            
            % Calculate point clouds centroid
            ocCentroid = mean(originalCloud.Location);
            tcCentroid = mean(rotatedCloud.Location);
            % Define and apply a 3D translation which overlaps the centroids
            initialTranslation = tcCentroid - ocCentroid;
            centeringTranslation = transformation_matrix(deg2rad(0), deg2rad(0), deg2rad(0), -initialTranslation(1), -initialTranslation(2), -initialTranslation(3));
            transformedCloud = pctransform(rotatedCloud, centeringTranslation);
            
            % Lines 33-34 define the initial rmse between originalCloud and
            % transformedCloud before ICP is applied
            [~, pointDistances] = knnsearch(originalCloud.Location, transformedCloud.Location);
            initialRmse = sqrt(sum(pointDistances) / numel(pointDistances));
            initialErrors(t, columnIndex) = initialRmse;
            
            % For plotting resulting ICP cloud and original cloud uncomment
            % lines 44-46 and change [~, ~, rmse] with [~, movingReg, rmse]
            tic;
            [~, ~, rmse] = pcregistericp(transformedCloud, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIter, 'Tolerance', [0.001, 0.001]);
            elapsedTime = toc;
            % tic + toc return elapsed time in seconds
            elapsedTime = elapsedTime * 1000;
            % pcshowpair(originalCloud, movingReg);
            % plt = gca;
            % exportgraphics(plt, ['./performance/plots/', num2str(maxIter), '_', num2str(t), '.png'], 'Resolution', 600);
            
            fprintf('InitialRmse: %f Error: %f Time[ms]: %f \n\n', initialRmse, rmse, elapsedTime);
            errors(t, columnIndex) = rmse;
            times(t, columnIndex) = elapsedTime;
            columnIndex = columnIndex + 1;
        end
    end
end