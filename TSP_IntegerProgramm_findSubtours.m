
%{

Check if given result contains any subtours:

parameters:
- result: a binary vector for all edges in graph.
            1: if a edge is part of a tour
            0: else

- edges: a suitable 2 column matrix to the result vector containing:
            colum1: the edge starts from this node number 
            colum2: the edge arrives to this node number

- nodes_lenth: number of nodes 

returns:
- detectedSubTours: cell array of all subtours
            e.g.: Tour1: [1, 2, 6], Tour1 [3, 4, 5]
            

%}
function detectedSubTours = TSP_IntegerProgramm_findSubtours(result,edges,nodes_length)

    detectedSubTours = {};
    subtour_counter = 1;
   
    
    % used_edges contains all edges that are used in result
    used_edges = edges(find(result),:);
    
    % make alle edges the same direction
    used_edges_switched(:,[1,2])=used_edges(:,[2,1]);
    
    used_edges = [used_edges; used_edges_switched];
   
    % remember which edges are already used in subtour (column3)
    used_edges(:,3) = zeros(2*nodes_length,1);
    
    % make a list of alle nodes
    nodes = {1:nodes_length};
   
    while length(nodes{1}) > 0
        
        % get next node
        current_node = nodes{1}(1);
        visited = current_node;
        
        % remove current_node from list to check
        nodes{1}(find(nodes{1}==current_node)) = [];
        
        firstrun = true;
        next_node_on_tour = 0;
        while current_node ~= next_node_on_tour

            % use this edge to get to next node
            if firstrun 
                edge_index = find(used_edges(:,1) == current_node & used_edges(:,3) == 0, 1);
                firstrun = false;
            else
                edge_index = find(used_edges(:,1) == next_node_on_tour & used_edges(:,3) == 0, 1);
            end
            
            % lock edge so that every edge can only be used once 
            used_edges(edge_index, 3) = 1;
            if edge_index <= nodes_length
                used_edges(edge_index+nodes_length, 3) = 1;
            else 
                used_edges(edge_index-nodes_length, 3) = 1;
            end

            % set next node and remove it from list to check
            next_node_on_tour = used_edges(edge_index, 2);
            nodes{1}(find(nodes{1}==next_node_on_tour)) = [];
            
            % add node to subtour if not already added 
            if ~ismember(visited, next_node_on_tour)
                visited = [visited,next_node_on_tour];
            end
        end
        
        % save subtour in return variable
        detectedSubTours{subtour_counter} = visited;
        subtour_counter = subtour_counter + 1;

    end
end


