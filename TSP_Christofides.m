function [ MSTedges, oddNodeLevelEdges, tour, tourLength, processingTime ] = TSP_Christofides( matrix )
%{
Christofides - Heuristic (start method)

parameters:
- matrix: cost matrix of a graph with n nodes 
         (this matrix has to apply the triangle inequality -> graph must be complete)

returns:
- MSTedges: edges of the minimum spanning tree (MST)
- oddNodeLevelEdges: edges, which will be added to connect the nodes 
                     of the MST with odd node level
- tour: the best solution for the given matrix 
- tourLength: length of the tour
- processingTime: time for the calculation of the tour

%}

% start measuring the processing time
tic

helpDist = matrix;

%check triangle inequality
for(r = 1:size(matrix,1))
    for (c = r+1:size(matrix,2))
        for(k = 1:size(matrix,1))
            if(k~=r && k~=c)
                if(matrix(r,c) > matrix(r,k) + matrix(k,c))
                    disp('Matrix does not satisfy the triangle inequality!');
                    MSTedges = []; 
                    oddNodeLevelEdges = []; 
                    tour=[]; 
                    tourLength = -1; 
                    processingTime = toc;
                    return;
                end
            end
        end
    end
end

%step 1: Minimum spanning tree (Prim Algorithm)
MSTedges=[];
MSTnodes = 1;
helpDist(:, 1) = 0;
while(size(matrix,1) ~= length(MSTnodes))
    minEdge=[];
    minEdgeValue = 10e+06;
    
    % find next smallest Edge
    for(i=1:length(MSTnodes))
        minValue = min(nonzeros(helpDist(MSTnodes(i),:)));
        if(~isempty(minValue))
            nextNode = find(helpDist(MSTnodes(i),:) == minValue,1,'last');

            if((minValue < minEdgeValue) && isempty(find(MSTnodes == nextNode, 1)))
                minEdgeValue = minValue;
                minEdge = [MSTnodes(i) nextNode];
            end
        end
    end
    MSTnodes = [MSTnodes minEdge(2)];
    MSTedges = [MSTedges; (minEdge)];
    helpDist(:, minEdge(2)) = 0;
end


%step 2: Creating a complete Graph of all nodes with an odd node level 
%        --> find minimum costs matching by connecting always two nodes

% getting nodes with an odd node level
nodeLevel = zeros(size(matrix,1));
for(l=1:size(MSTedges, 1))
	nodeLevel(MSTedges(l, 1), MSTedges(l, 2)) = 1;
    nodeLevel(MSTedges(l, 2), MSTedges(l, 1)) = 1;
end


for(k=1:size(nodeLevel, 1))
    oneNodeLevel = sum(nodeLevel(k,:));
	if(mod(oneNodeLevel,2) ~= 0)
		if(k==1)
            oddNodeLevel = k;
        else
            oddNodeLevel = [oddNodeLevel k];
        end
	end	
end

% complete graph of nodes of the MST with odd node level
minSum = 10e+06;
minPermutation = -1;
oddNodePerms = perms(oddNodeLevel);

for(r = 1:size(oddNodePerms, 1))
	sumOddNode = 0;
	for(c = 1 : 2 : size(oddNodePerms, 2))
		sumOddNode = sumOddNode + matrix(oddNodePerms(r,c), oddNodePerms(r,c+1));
	end	
	
	if(sumOddNode < minSum)
		minSum = sumOddNode;
		minPermutation = r;
	end
end

%step 3: add minimum cost matching to MST -> any circle of this Graph
edges = MSTedges;
oddNodeLevelEdges = [];
minCostMatch = oddNodePerms(minPermutation,:);
oddNodeLevelEdges = [];

for(a = 1: 2 : length(minCostMatch))
    oddNodeLevelEdges = [oddNodeLevelEdges; [minCostMatch(a) minCostMatch(a+1)]];
	edges = [edges; [minCostMatch(a) minCostMatch(a+1)]];
end

% any circle (Euler Tour) -> starting with startNode;
tour = 1;
currentNode = 1;
while(length(tour) ~= size(matrix,1))
    % finding next node of the tour
    for(i=1:size(edges,1))
        
        if(edges(i,1) == currentNode)
            nextNode = edges(i,2);
            % add only nodes which aren't visited yet
            if(isempty(find(tour == nextNode,1)))
                tour = [tour nextNode];
            end
            % mark edge, so it won't be taken again
            edges(i,:) = 0;
            currentNode = nextNode;
            break;
            
        elseif (edges(i,2) == currentNode)
            nextNode = edges(i,1);
            % add only nodes which aren't visited yet
            if(isempty(find(tour == nextNode,1)))
                tour = [tour nextNode];
            end
            % mark edge, so it won't be taken again
            edges(i,:) = 0;
            currentNode = nextNode;
            break;
        end
    end
end
tour = [tour 1];

% calculating length of the tour
tourLength = 0;
for(j = 1:length(tour)-1)
    tourLength = tourLength + matrix(tour(j), tour(j+1));
end

% stop measuring the processing time
processingTime = toc;

end










