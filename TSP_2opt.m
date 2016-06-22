function [ tour, tourLength, processingTime ] = twoOpt( tour, matrix )
%{ 
2 opt - heuristic (improving method)

parameters:
- tour: any tour of the n nodes
- matrix: cost matrix of a complete graph with n nodes

returns:
- tour: a 2-opt tour
- tourLength: length of the 2-opt tour
- processingTime: time for the calculation of the tour

%}

% start measuring the processing time
tic

M = 10e+06;
% Relaxation - if there is no edge between two nodes, this edge get
% expensiv costs, so if will not be taken
for(r = 1: size(matrix,1))
    for(c = 1: size(matrix,2))
        if(r~=c && matrix(r,c)==0)
            matrix(r,c) = M;
        end
    end
end


%number of nodes
n = size(matrix,1);

% check if start solution has enough entries
if(length(tour)-1 ~= n)
    %disp('Start solution includes to less or to much nodes!');
    tour = [];
    tourLength = -1;
    % stop measuring the processing time
    processingTime = toc;
    return;
end

newIteration = true;
while(newIteration)
    newIteration = false;
    
    for(i=1:size(matrix,1)-2)
        for(j=i+2:size(matrix,1))
            if((matrix(tour(i), tour(i+1)) + matrix(tour(j), tour(j+1))) > (matrix(tour(i),tour(j))+matrix(tour(i+1), tour(j+1))))
                % nodes 1 to i will be added in the same order to the new tour
                % nodes i+1 to j will be added in reverse order to the new tour
                % nodes j+1 to end will be added in the same order to the new
                % tour
                tour = [tour(1:i) tour(j:-1:i+1) tour(j+1:end)];
                
                % newTour -> starting the iteration again
                newIteration = true;
                break;
            end
        end
        if(newIteration)
            break;
        end
    end
end

tourLength = 0;
for(j=1:length(tour)-1)
    tourLength = tourLength + matrix(tour(j), tour(j+1))
end

% stop measuring the processing time
processingTime = toc;

end

