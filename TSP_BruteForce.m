function [ tour, tourLength ] = TSP_BruteForce( matrix )
%{
BruteForce - exact solution 

parameters:
- matrix: cost matrix of a graph with n nodes (with aa zero if there is no
edge between to nodes)

returns:
- tour: the best solution for the given matrix 
- tourLength: length of the tour
%}

nodes=(2:size(matrix,1));
permutations = perms(nodes);
numOfPermutations = size(permutations, 1);

optPermutation= permutations(1,:);
smallestDistance = 10e+06;

% check all permutations
for (i = 1:numOfPermutations)
    % step 1: check if permutation is allowed    
    % step 2: calculate distance for this tour
    from = 1;
    isAllowed = true;
    currentDistance = 0;
    currentPermutation = permutations(i,:);
    
    for(j = 1:length(nodes))
        to = currentPermutation(j);
        distFromTo = matrix(from, to);
        if(distFromTo ~= 0)
            currentDistance = currentDistance + distFromTo;
        else
            %disp('Not allowed');
            isAllowed = false;
            break;
        end
        from = to;
    end
    
    
    % step 3: compare the tour distance with the currently smallest tour
    % distance
    if(isAllowed)
        %back to Start
        to = 1;
        distFromTo = matrix(from, to);
        if(distFromTo ~= 0)
            currentDistance = currentDistance + distFromTo;
            %check ifit is the shortest distance
            if(currentDistance < smallestDistance)
                smallestDistance = currentDistance;
                optPermutation = currentPermutation;
            end
        else
          %disp('Not allowed');
        end      
    end
end

tour = [1 optPermutation 1]
tourLength = smallestDistance
end