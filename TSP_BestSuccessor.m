function [ tour, tourLength, processingTime ] = TSP_BestSuccessor( matrix )
%{
Best Successor - Heuristic (start method)

parameters:
- matrix: cost matrix of a graph with n nodes 
         (if there is no edge between node i and j: c(i,j) = 0)

returns:
- tour: the best solution for the given matrix 
- tourLength: length of the tour
- processingTime: time for the calculation of the tour

%}

% start measuring the processing time
tic

graph = matrix;
graph(:, 1) = 0;
nodes = [2:size(matrix,1)];

nextNode = 1;
tour = nextNode;
tourLength = 0;

for(i = 1:length(nodes))
    %getNextNode
    minwert = min(nonzeros(graph(nextNode,:)));
    if(isempty(minwert))
        %disp('Unzulässige Lösung!')
        tourLength = -1;
        break;
    end
    tourLength = tourLength + minwert;
    nextNode = find(graph(nextNode,:) == minwert,1,'last');
    tour = [tour nextNode];
    nodes(find(nodes == nextNode))=[];
    graph(:, nextNode) = 0;
end

% checking if tour is valid
if(tourLength ~= -1)
    backToStart = matrix(nextNode, 1);
    if( backToStart == 0)
        %disp('Unzulässige Lösung!')
        tourLength = -1;
    else
        tour = [tour 1];
        tourLength = tourLength + backToStart;
    end
end 

% stopp measuring the processing time
processingTime = toc;

end

