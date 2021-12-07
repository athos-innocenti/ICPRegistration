function [avgError, avgTime] = error_per_angle(originalModel, transformedModel, triesPerAngle, angles, maxTranslation, maxIterations, rotType)
    avgError = zeros(1, length(angles));
    avgTime = zeros(1, length(angles));
    vectorIndex = 1;
    for angleIter = angles
        errors = zeros(1, triesPerAngle);
        times = zeros(1, triesPerAngle);
        for t = 1:triesPerAngle
            % Define a random 3D translation vector where each component is
            % uniformly distributed in the interval [0, maxTranslation]
            trsX = 0 + (maxTranslation - 0)*rand(1, 1);
            trsY = 0 + (maxTranslation - 0)*rand(1, 1);
            trsZ = 0 + (maxTranslation - 0)*rand(1, 1);
            fprintf('ROTATION type:%s angle:%d° try:%d \n', rotType, angleIter, t);
            fprintf('TRANSLATION x:%3f y:%3f z:%3f \n', trsX, trsY, trsZ);
            
            originalCloud = pcread(originalModel);
            movingCloud = pcread(transformedModel);
            
            radAngle = deg2rad(angleIter);
            if rotType == 'X'
                % Rotation w.r.t X axis
                initialTransformation = transformation_matrix(radAngle, 0, 0, trsX, trsY, trsZ);
            elseif rotType == 'Y'
                % Rotation w.r.t Y axis
                initialTransformation = transformation_matrix(0, radAngle, 0, trsX, trsY, trsZ);
            elseif rotType == 'Z'
                % Rotation w.r.t Z axis
                initialTransformation = transformation_matrix(0, 0, radAngle, trsX, trsY, trsZ);
            else
                % 3D rotation
                initialTransformation = transformation_matrix(radAngle, radAngle, radAngle, trsX, trsY, trsZ);
            end
            transformedCloud = pctransform(movingCloud, initialTransformation);
            
            % For plotting resulting ICP cloud and original cloud uncomment
            % line 43 and change [~, ~, rmse] with [~, movingReg, rmse]
            tic;
            [~, ~, rmse] = pcregistericp(transformedCloud, originalCloud, 'Metric', 'pointToPoint', 'MaxIterations', maxIterations, 'Tolerance', [0.001, 0.001]);
            elapsedTime = toc;
            % tic + toc return elapsed time in seconds
            elapsedTime = elapsedTime * 1000;
            % pcshowpair(originalCloud, movingReg);
            
            fprintf('Error:%f Time[ms]:%f \n\n', rmse, elapsedTime);
            errors(1, t) = rmse;
            times(1, t) = elapsedTime;
        end
        avgError(1, vectorIndex) = mean(errors);
        avgTime(1, vectorIndex) = mean(times);
        vectorIndex = vectorIndex + 1;
    end
end
