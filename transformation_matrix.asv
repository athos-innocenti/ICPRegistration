function [transformationMatrix] = transformation_matrix(rotX, rotY, rotZ, trsX, trsY, trsZ)
    rotationMatrix = [cos(rotZ)*cos(rotY)   (cos(rotZ)*sin(rotY)*sin(rotX))-(sin(rotZ)*cos(rotX))   (sin(rotZ)*sin(rotX))+(cos(rotZ)*sin(rotY)*cos(rotX)); ...
                      sin(rotZ)*cos(rotY)   (cos(rotZ)*cos(rotX))+(sin(rotZ)*sin(rotY)*sin(rotX))   (sin(rotZ)*sin(rotY)*cos(rotX))-(cos(rotZ)*sin(rotX)); ...
                      -sin(rotY)            cos(rotY)*sin(rotX)                                     cos(rotY)*cos(rotX)];

    translationVector = [trsX, trsY, trsZ];
    
    transformationMatrix = rigid3d(rotationMatrix, translationVector);
end