function [initialErrors, errors, times] = deformation_icp(originalModel, transformedModel, triesPerIter, maxRotation, maxTranslation, maxIterationsVector)
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
        
        % Define a random transformation matrix
        scalingFactorX = random_value(0, 2);
        scalingFactorY = random_value(0, 2);
        scalingFactorZ = random_value(0, 2);
        shearingX = [random_value(0, 1), random_value(0, 1)];
        shearingY = [random_value(0, 1), random_value(0, 1)];
        shearingZ = [random_value(0, 1), random_value(0, 1)];
        deformationMatrix = [scalingFactorX  shearinY(1)     shearingZ(1)    0; ...
                             shearingX(1)    scalingFactorY  shearingZ(2)    0; ...
                             shearingX(2)    shearingY(2)    scalingFactorZ  0; ...
                             0               0               0               1];
        
        columnIndex = 1;
        for maxIter = maxIterationsVector
            fprintf('Try:%d MaxIteration:%d \n', t, maxIter);
            disp(deformationMatrix.T);
            fprintf('TRANSLATION x:%f y:%f z:%f \n', trsX, trsY, trsZ);
            fprintf('ROTATION x:%d° y:%d° z:%d° \n', rotX, rotY, rotZ);
            
            originalCloud = pcread(originalModel);
            movingCloud = pcread(transformedModel);
            
            deformedCloud = pctransform(movingCloud, affine3d(deformationMatrix));
            
            initialRotoTranslation = transformation_matrix(deg2rad(rotX), deg2rad(rotY), deg2rad(rotZ), trsX, trsY, trsZ);
            transformedCloud = pctransform(deformedCloud, initialRotoTranslation);
            
            % Lines 45-46 define the initial rmse between originalCloud and
            % transformedCloud before ICP is applied
            [~, pointDistances] = knnsearch(originalCloud.Location, transformedCloud.Location);
            initialRmse = sqrt(sum(pointDistances) / numel(pointDistances));
            initialErrors(t, columnIndex) = initialRmse;
            
            % For plotting resulting ICP cloud and original cloud uncomment
            % lines 56-58 and change [~, ~, rmse] with [~, movingReg, rmse]
            tic;
            [~, ~, rmse] = pcregistericp(transformedCloud, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIter, 'Tolerance', [0.001, 0.001]);
            elapsedTime = toc;
            % tic + toc return elapsed time in seconds
            elapsedTime = elapsedTime * 1000;
            % pcshowpair(originalCloud, movingReg);
            % plt = gca;
            % exportgraphics(plt, ['./performance/plots/', num2str(maxIter), '_', num2str(t), '_d.png'], 'Resolution', 600);
            
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