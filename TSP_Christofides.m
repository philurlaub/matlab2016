function [ tour ] = TSP_( matrix )
%{
christofides - heuristic (start method)

parameters:
- matrix: cost matrix of a graph with n nodes (this matrix has to apply the
triangle inequality)

returns:
- tour: one solution of the Christofides-Algorithm for the given matrix 
with n nodes
%}

nodes = [1,2,3,4,5,6,7,8,9];

helpDist = distances;

%step 1: Minimum spanning tree (Prim Algorithm)
MSTedges=[];
MSTnodes = 1;
helpDist(:, 1) = 0;
while(size(matrix,1) ~= length(MSTnodes))
    minEdge=[];
    minEdgeValue = 999999999;
    
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

%output
MSTnodes
MSTedges


%step 2: Creating a complete Graph of all nodes with an odd node level 
%        --> find minimum costs matching by connecting always two nodes

% get nodes with an add node level
nodeLevel = zeros(size(matrix,1))
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

% complete Graph of oddNodeLevel
oddNodePerms = perms(oddNodeLevel);
minSum = 9999999999;
minPermutation = -1;
for(r=1:size(oddNodePerms, 1))
	sum = 0;
	for(c = 1 : 2 : size(oddNodePerms, 2))
		sum = sum + distances(oddNodePerms(r,c), oddNodePerms(r,c+1));
	end	
	
	if(sum < minSum)
		minSum = sum;
		minPermutation = r;
	end
end



%step 3: add minimum cost matching to MST -> any circle of this Graph
minCostMatch = oddNodePerms(minPermutation,:);
for(a = 1: 2 : length(minCostMatch))
	MSTedges = [MSTedges; [minCostMatch(a) minCostMatch(a+1)]];
end

% any circle (Euler Tour) -> starting with startNode;
% add only nodes which aren't visited yet

edges = MSTedges;
tour = 1;
element = 1;
while(length(tour) ~= size(matrix,1))
    for(i=1:size(edges,1))
        if(edges(i,1)==element)
            element = edges(i,2);
            if(isempty(find(tour == element,1)))
                tour = [tour element];
            end
            edges(i,:) = 0;
            break;
        elseif (edges(i,2)==element)
            element = edges(i,1);
            if(isempty(find(tour == element,1)))
                tour = [tour element];
            end
            edges(i,:) = 0;
            break;
        end
    end
end
tour = [tour 1];

% calculate length of the tour
tourLength = 0;
for(j=1:length(tour)-1)
    tourLength = tourLength + distances(tour(j), tour(j+1))
end

%output
tour
tourLength

end










