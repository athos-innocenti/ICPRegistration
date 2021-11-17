function [avgError, avgTime] = error_per_angle(originalModel, transformedModel, triesPerAngle, angleStep, maxTraslation, maxIterations)
    avgError = zeros(1, 360/angleStep + 1);
    avgTime = zeros(1, 360/angleStep + 1);
    vectorIndex = 1;
    for angleIter = 0:angleStep:360
        errors = zeros(1, triesPerAngle);
        times = zeros(1, triesPerAngle);
        for t = 1:triesPerAngle
            fprintf('Angle: %d Iter: %d \n', angleIter, t);

            originalCloud = pcread(originalModel);
            transformedCloud = pcread(transformedModel);
            
            radAngle = deg2rad(angleIter);
            initialTransformation = transformation_matrix(radAngle, radAngle, radAngle, rand(1, maxTraslation), rand(1, maxTraslation), rand(1, maxTraslation));
            ptCloudTransformed = pctransform(transformedCloud, initialTransformation);
            
            tic;
            [~, ~, rmse] = pcregistericp(ptCloudTransformed, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIterations, 'Tolerance', [0.001, 0.005]);
            % [~, movingReg, rmse] = pcregistericp(ptCloudTransformed, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIterations);
            % pcshowpair(originalCloud, movingReg);
            elapsedTime = toc;
            elapsedTime = elapsedTime * 1000;
            
            fprintf('Error: %f Time[ms]: %f \n\n', rmse, elapsedTime);
            errors(1, t) = rmse;
            times(1, t) = elapsedTime;
        end
        avgError(1, vectorIndex) = mean(errors);
        avgTime(1, vectorIndex) = mean(times);
        vectorIndex = vectorIndex + 1;
    end
end
