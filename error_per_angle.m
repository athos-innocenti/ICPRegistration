function [avgError, avgTime] = error_per_angle(originalModel, transformedModel, triesPerAngle, angleStep, maxTraslation, maxIterations)
    avgError = zeros(360/angleStep + 1);
    avgTime = zeros(360/angleStep + 1);
    vectorIndex = 1;
    for angleIter = 0:angleStep:360
        errors = zeros(triesPerAngle);
        times = zeros(triesPerAngle);
        for t = 1:triesPerAngle
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
            
            errors(t) = rmse;
            times(t) = elapsedTime;
        end
        avgError(vectorIndex) = mean(errors);
        avgTime(vectorIndex) = mean(times);
        vectorIndex = vectorIndex + 1;
    end
end