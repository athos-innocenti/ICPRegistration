function [initialErrors, errors, times] = outliers_icp(originalModel, transformedModel, triesPerIter, maxRotation, maxTranslation, maxIterationsVector, numOutliers)
    initialErrors = zeros(triesPerIter, length(maxIterationsVector));
    errors = zeros(triesPerIter, length(maxIterationsVector));
    times = zeros(triesPerIter, length(maxIterationsVector));
    for t = 1:triesPerIter
        % Define a random 3D rotation from the uniform distribution between 
        % 0 and maxRotation
        rotX = randi([0 maxRotation], 1, 1);
        rotY = randi([0 maxRotation], 1, 1);
        rotZ = randi([0 maxRotation], 1, 1);
        
        % Define a random 3D translation vector where each component is
        % uniformly distributed in the interval [0, maxTranslation]
        trsX = random_value(0, maxTranslation);
        trsY = random_value(0, maxTranslation);
        trsZ = random_value(0, maxTranslation);
        
        % Define numOutliers points as point cloud outliers
        noise = zeros(numOutliers, 3);
        movingCloud = pcread(transformedModel);
        xLimits = movingCloud.XLimits;
        yLimits = movingCloud.YLimits;
        zLimits = movingCloud.ZLimits;
        for p = 1:numOutliers
            noise(p, 1) = random_value(xLimits(1), xLimits(2));
            noise(p, 2) = random_value(yLimits(1), yLimits(2));
            noise(p, 3) = random_value(zLimits(1), zLimits(2));
        end
        
        columnIndex = 1;
        for maxIter = maxIterationsVector
            fprintf('Try:%d MaxIteration:%d \n', t, maxIter);
            fprintf('TRANSLATION x:%f y:%f z:%f \n', trsX, trsY, trsZ);
            fprintf('ROTATION x:%d° y:%d° z:%d° \n', rotX, rotY, rotZ);
            
            originalCloud = pcread(originalModel);
            movingCloud = pcread(transformedModel);
            
            noisedCloud = pointCloud([movingCloud.Location; noise]);
            
            initialRotoTranslation = transformation_matrix(deg2rad(rotX), deg2rad(rotY), deg2rad(rotZ), trsX, trsY, trsZ);
            transformedCloud = pctransform(noisedCloud, initialRotoTranslation);
            
            % Lines 46-47 define the initial rmse between originalCloud and
            % transformedCloud before ICP is applied
            [~, pointDistances] = knnsearch(originalCloud.Location, transformedCloud.Location);
            initialRmse = sqrt(sum(pointDistances) / numel(pointDistances));
            initialErrors(t, columnIndex) = initialRmse;
            
            % Remove outliers from transformed cloud
            denoisedCloud = pcdenoise(transformedCloud, 'NumNeighbors', 5, 'Threshold', 0.5);
            
            % For plotting resulting ICP cloud and original cloud uncomment
            % lines 60-62 and change [~, ~, rmse] with [~, movingReg, rmse]
            tic;
            [~, movingReg, rmse] = pcregistericp(denoisedCloud, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIter, 'Tolerance', [0.001, 0.001]);
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
    
    function [randomValue] = random_value(min, max)
        randomValue = min + (max - min)*rand(1, 1);
    end
    
end
