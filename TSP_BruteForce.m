function [ tour, tourLength,  processingTime] = TSP_BruteForce( matrix )
%{
BruteForce - exact solution 

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

% nodes without startNode
nodes=(2:size(matrix,1));
% all permutations of the nodes (without startNode)
permutations = perms(nodes); 
numOfPermutations = size(permutations, 1);

optPermutation = permutations(1,:);
smallestDistance = 10e+06;

% check all permutations
for (i = 1:numOfPermutations)
    
    from = 1;
    isValid = true;
    currentDistance = 0;
    currentPermutation = permutations(i,:);
    
    % step 1: check if permutation is valid    
    % step 2: calculate distance for this tour
    
    for(j = 1:length(nodes))
        to = currentPermutation(j);
        distFromTo = matrix(from, to);
        if(distFromTo ~= 0)
            currentDistance = currentDistance + distFromTo;
        else
            %disp('This tour is not valid!');
            isValid = false;
            break;
        end
        from = to;
    end
    
    
    % step 3: compare the tour distance with the currently smallest tour
    %         distance
    if(isValid)
        % distance from last node back to the startNode
        to = 1;
        distFromTo = matrix(from, to);
        if(distFromTo ~= 0)
            currentDistance = currentDistance + distFromTo;
           
            % check if it is the shortest distance
            if(currentDistance < smallestDistance)
                smallestDistance = currentDistance;
                optPermutation = currentPermutation;
            end
        else
          %disp('This tour is not valid!');
        end      
    end
end

if(smallestDistance == 10e+06)
    disp('No valid tour found!');
    tour= [];
    tourLength = -1;
else
    tour = [1 optPermutation 1];
    tourLength = smallestDistance;
end

% stopp measuring the processing time
processingTime = toc;

end