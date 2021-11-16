clear all
clc
close all

% Initial rotation's angle from 0 to 2PI with angle's step of PI/6
ANGLE_STEP = 30;
% Number of tries for each initial combination: 1D/3D rotation+ random 3D traslation
TRIES_ANGLE = 25;
% Number of tries for each initial combination: random 3D rotation + random 3D traslation
TRIES_ITER = 100;
% Maximum ICP iterations
MAX_ITERATIONS = 100;
% Random initial translation vector, different for each try, with max translation = 1.0
MAX_TRASLATION = 1.0;
% Random initial 3D rotation matrix, different for each try, with max rotation = 360°
MAX_ROTATION = 360;
% Original point cloud (ends with 0)
ORIGINAL_MODEL = '/model/office_chair_0.ply';
% Transformed point cloud (ends with 1 - moving point cloud with fewer points)
TRANSFORMED_MODEL = '/model/office_chair_1.ply';

% Given an initial rotation's angle Theta from 0° to 360° with step of 30°,
% run ICP algorithm for TRIES_ANGLE times with different 3D random initial translation vector for each try.
% ICP max iterations is always the same.
% Possible initial rotations analysed:
%   1. (ThetaX, 0, 0)
%   2. (0, ThetaY, 0)
%   3. (0, 0, ThetaZ)
%   4. (Theta, Theta, Theta) same rotation angle w.r.t X Y and Z axes
[avgError, avgTime] = error_per_angle(ORIGINAL_MODEL, TRANSFORMED_MODEL, TRIES_ANGLE, ANGLE_STEP, MAX_TRASLATION, MAX_ITERATIONS);

% For TRIES_ITER times, randomly define an initial 3D rotation + translation matrix
% and then apply ICP algorithm 3 times: the first time with 50 max iterations,
% the second with 100 max iterations and the last one with 200
[errors, times] = error_per_iter(ORIGINAL_MODEL, TRANSFORMED_MODEL, TRIES_ITER, MAX_TRASLATION, MAX_ROTATION, [50, 100, 200]);

angles = 0:30:360;
plot_values(angles, avgError, 'Error');
plot_values(angles, avgTime, 'Time');