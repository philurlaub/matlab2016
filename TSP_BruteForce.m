%% TSP_Brute-Force
%% exact solution

nodes = [1,2,3,4,5,6,7,8,9];

startNode = 1;
nodes(find(nodes == startNode))=[];
distances = [ 0  7  6  0  0  0  6  4  0; % A 1
           7  0  4  7  0  0  0  0  0; % B 2
           6  4  0  3  5  0  0  0 10; % C 3
           0  7  3  0  5 10  0  0  0; % D 4
           0  0  5  5  0  5  8  0  7; % E 5
           0  0  0 10  5  0  4  0  0; % F 6
           6  0  0  0  8  4  0  3  2; % G 7
           4  0  0  0  0  0  3  0  0; % H 8 
           0  0 10  0  7  0  2  0  0  % I 9
         ];

permutations = perms(nodes);
numOfPermutations = size(permutations, 1);

optPermutation= permutations(1,:);
smallestDistance = 999999999999;

% check all permutations
for (i = 1:numOfPermutations)
    % step 1: check if permutation is allowed    
    % step 2: calculate distance for this tour
    currentPermutation = permutations(i,:);
    currentDistance = 0;
    from = startNode;
    isAllowed = true;
    
    for(j = 1:length(nodes))
        to = currentPermutation(j);
        distFromTo = distances(from, to);
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
        to = startNode;
        distFromTo = distances(from, to);
        if(distFromTo ~= 0)
            currentDistance = currentDistance + distFromTo;
        else
            %disp('Not allowed');
            isAllowed = false;
        end
    
        % check if it is the shortest distance
  
        if(currentDistance < smallestDistance)
            smallestDistance = currentDistance;
            optPermutation = currentPermutation;
        end
    end
end

smallestDistance
optPermutation