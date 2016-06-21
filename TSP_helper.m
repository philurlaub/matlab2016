%{

Helper class with useful funtions that can be used in any TSP algorithms
- examples
- printing 
- plotting
- validation check

%}
function message = helper
    message='Import helper functions';
    assignin('caller', 'printMatrixAsGraph', @printMatrixAsGraph);
    assignin('caller', 'checkMatrix', @checkMatrix);
    assignin('caller', 'makeMatrixSymmetric', @makeMatrixSymmetric);
    assignin('caller', 'drawTsp', @drawTsp);
    assignin('caller', 'matrixFromMetricCoordinates', @matrixFromMetricCoordinates);
end

%{

Check if given matrix is an valid input that means:
- matrix is symmetric
- only zeros on diagonale
- no negativ values

parameters:
- matrix: matrix to check

returns:
- isValid: true if matrix is valid
- message: error message text

%}
function [isValid, message]=checkMatrix(matrix)
isValid = true;
    for i = 1:size(matrix, 1)
        for j = 1:size(matrix, 2)
            if i==j && matrix(i,j) ~= 0
                isValid = false;
                message = 'Only zeors are allowed on matrix diagonale.'
            elseif matrix(i,j )~= matrix(j,i)
                isValid = false;
                message = 'Matrix is not symmetric.'
            elseif matrix(i,j)<0
                isValid = false;
                message = 'Negative values are not allowed.'
            else
                message = 'Matrix is valid.'
            end
        end
    end

end

%{

Make matrix symmetric 

parameters:
- inMatrix: matrix to mirrow
- part: 'top' or 'bottom' - which side to mirrow

returns:
- outMatrix: symmetrix matrix

%}
function outMatrix=makeMatrixSymmetric(inMatrix, part)
    outMatrix=inMatrix;
    for i = 1:size(outMatrix, 1)
        for j = 1:size(outMatrix, 2)
            if i==j
                outMatrix(i,j) = 0;
            elseif strcmp(part,'bottom') && i<j
                outMatrix(i,j) = outMatrix(j,i);
            elseif strcmp(part,'top') && i>j
                outMatrix(i,j) = outMatrix(j,i);
            end
        end
    end
end

%{

Daws a tour with given coordinates

parameters:
- tour: list of edges e.g. 1 2; 2 3; 3 1
- coordinates: list of coordinates 
               e.g. first row (x, y) coordinates of node 1

%}
function drawTsp(tour, coordinates)
    hold on;
    scatter(coordinates(:,1), coordinates(:,2), '*');
    labels = num2str((1:size(coordinates,1))','%d');    %'
    text(coordinates(:,1), coordinates(:,2), labels, 'horizontal','left', 'vertical','bottom')
    
    for i=1:size(tour,1)
        line([coordinates(tour(i, 1), 1), coordinates(tour(i, 2),1)],[coordinates(tour(i, 1), 2), coordinates(tour(i, 2),2)]);
    end
end


%{

Calculate a distance matrix from coordinate list

parameters:
- coordinates: list of coordinates 
               e.g. first row (x, y) coordinates of node 1

returns: 
- matrix: a symmetric NxN matrix with N = number of rows in coordinate list

%}
function matrix=matrixFromMetricCoordinates(coordinates)
    matrix = zeros(size(coordinates, 1));
    
    for i=1:size(coordinates, 1)
        for j=1:size(coordinates, 1)
            matrix(i,j) = sqrt( (coordinates(i,1)-coordinates(j,1))^2 + (coordinates(i,2)-coordinates(j,2))^2);
        end
    end 
end 

