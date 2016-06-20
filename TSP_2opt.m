function [ tour ] = twoOpt( tour, matrix )
%{ 
2 opt - heuristic (improving method)

parameters:
- tour: any tour of the n nodes
- matrix: cost matrix of a complete graph with n nodes

returns:
- tour: a 2-opt tour
%}   

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
end

