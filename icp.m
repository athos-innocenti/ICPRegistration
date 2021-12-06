clear all
clc
close all

% Initial rotation's angle from 0 to 2PI with angle's step of PI/6
MAX_ANGLE = 360;
ANGLE_STEP = 30;
ANGLES = 0:ANGLE_STEP:MAX_ANGLE;
% Number of tries for each initial combination: 1D/3D rotation + random 3D traslation
TRIES_ANGLE = 100;
% Number of tries for each initial combination: random 3D rotation + random 3D traslation
TRIES_ITER = 100;
% Maximum ICP iterations
MAX_ITERATIONS = 100;
% Random initial translation vector, different for each try, with max translation = 1.0
MAX_TRASLATION = 1.0;
% Random initial 3D rotation matrix, different for each try, with max rotation = 360°
MAX_ROTATION = 360;
% Original point cloud name (ends with 0)
ORIGINAL_MODEL = './model/office_chair_0.ply';
% Transformed point cloud name (ends with 1 - moving point cloud with fewer points)
TRANSFORMED_MODEL = './model/office_chair_1.ply';
% Model identifier for .png and .csv files creation
MODEL_ID = 'oc';

% Given an initial rotation's angle Theta from 0° to 360° with step of 30°,
% run ICP algorithm for TRIES_ANGLE times with different 3D random initial translation vector for each try.
% ICP max iterations is always the same.
% Initial rotations analysed (same angle for X-Y-Z axes in 3D rotation):
%   1. (Theta, 0, 0)            -> rotType = 'X'
%   2. (0, Theta, 0)            -> rotType = 'Y'
%   3. (0, 0, Theta)            -> rotType = 'Z'
%   4. (Theta, Theta, Theta)    -> rotType = '3D'
rotType = '3D';
[avgError, avgTime] = error_per_angle(ORIGINAL_MODEL, TRANSFORMED_MODEL, TRIES_ANGLE, ANGLES, MAX_TRASLATION, MAX_ITERATIONS, rotType);

% Plot average errors and times from error_per_angle function, save plots as .png files and save values in .csv files.
% Example for file name: oc_error3D_100i.png
plot_values(ANGLES, avgError, 'Rmse', MODEL_ID, rotType, MAX_ITERATIONS, MAX_ANGLE);
plot_values(ANGLES, avgTime, 'Time', MODEL_ID, rotType, MAX_ITERATIONS, MAX_ANGLE);

% For TRIES_ITER times, randomly define an initial 3D rotation + translation matrix
% and then apply ICP algorithm 3 times: the first time with 50 max iterations,
% the second with 100 max iterations and the last one with 200
[initialErrors, errors, times] = error_per_iter(ORIGINAL_MODEL, TRANSFORMED_MODEL, TRIES_ITER, MAX_TRASLATION, MAX_ROTATION, [50, 100, 200, 400]);

% Create pie chart for errors from error_per_iter function and save it as
% .png file. Plot errors and times, save plots as .png files
% and save errors and times values in .csv files
pie_chart(errors, times, [50, 100, 200, 400], 2);
