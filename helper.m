%{

Helper class with useful funtions that can be used in any TSP algorithm
- examples
- printing 
- plotting
- validation check

%}
function message = helper
    message='Import helper functions';
    assignin('base', 'getExampleMatrix1', @getExampleMatrix1);
    assignin('base', 'printMatrixAsGraph', @printMatrixAsGraph);
    assignin('base', 'checkMatrix', @checkMatrix);
end

%{

Example 1 from course presentation.

returns:
- matrix: the example matrix

%}
function matrix=getExampleMatrix1

%          A  B  C  D  E  F  G  H  I
%          1  2  3  4  5  6  7  8  9
matrix = [ 0  7  6  0  0  0  6  4  0; % A 1
           7  0  4  7  0  0  0  0  0; % B 2
           6  4  0  3  5  0  0  0 10; % C 3
           0  7  3  0  5 10  0  0  0; % D 4
           0  0  5  5  0  5  8  0  7; % E 5
           0  0  0 10  5  0  4  0  0; % F 6
           6  0  0  0  8  4  0  3  2; % G 7
           4  0  0  0  0  0  3  0  0; % H 8 
           0  0 10  0  7  0  2  0  0  % I 9
         ];
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

function printMatrixAsGraph(matrix)

    names = {size(matrix)};
    for i = 1:size(matrix)
       %sprintf('City %i', i)
       names(i) = cellstr(strcat('point_', num2str(i)));
    end
        
    plot(graph(matrix, names, 'upper', 'OmitSelfLoops'))

end



