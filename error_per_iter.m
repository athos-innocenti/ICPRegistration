function [initialErrors, errors, times] = error_per_iter(originalModel, transformedModel, triesPerIter, maxTranslation, maxRotation, maxIterationsVector)
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
        trsX = 0 + (maxTranslation - 0)*rand(1, 1);
        trsY = 0 + (maxTranslation - 0)*rand(1, 1);
        trsZ = 0 + (maxTranslation - 0)*rand(1, 1);
        
        columnIndex = 1;
        for maxIter = maxIterationsVector
            fprintf('Try:%d MaxIteration:%d \n', t, maxIter);
            fprintf('ROTATION x:%d° y:%d° z:%d° \n', rotX, rotY, rotZ);
            fprintf('TRANSLATION x:%3f y:%3f z:%3f \n', trsX, trsY, trsZ);
            
            originalCloud = pcread(originalModel);
            movingCloud = pcread(transformedModel);
            
            initialTransformation = transformation_matrix(deg2rad(rotX), deg2rad(rotY), deg2rad(rotZ), trsX, trsY, trsZ);
            transformedCloud = pctransform(movingCloud, initialTransformation);
            
            % Lines 32-33 define the initial rmse between originalCloud and
            % ptCloudTransformed  before ICP is applied
            [~, pointDistances] = knnsearch(originalCloud.Location, transformedCloud.Location);
            initialRmse = sqrt(sum(pointDistances) / numel(pointDistances));
            initialErrors(t, columnIndex) = initialRmse;
            
            % For plotting resulting ICP cloud and original cloud uncomment
            % lines 43-45 and change [~, ~, rmse] with [~, movingReg, rmse]
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
