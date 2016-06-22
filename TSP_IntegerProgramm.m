function [ tour, tourlenght, processtime, message ] = tspOptLin(matrix, guiOutput)
%{ 
Integer Programm - nearly exakt

parameters:
- matrix: cost matrix of a graph with n nodes

returns:
- tour: a valid tour
- tourLength: length of the tour
- processingTime: time for the calculation of the tour
- message: stuts message 

%}

    if nargin == 2
        % gui output enabled
        temp = get(guiOutput, 'String');
    else 
        % no output 
        temp = '';
    end
       

    % start timer
    tic;

    % global defines 
    NO_EDGE_MARKER =  0;
    DEBUG_OUTPUT = false;

    % all edges e.g. [from, to]
    % returns the binomial coefficient, defined as n!/((n?k)! k!). 
    %This is the number of combinations of n items taken k at a time.
    all_edges = nchoosek(1:length(matrix),2);

    edges = [];
    distances = [];

    % only edges that are valid - i.e. not zero
    for i=1:length(all_edges)
        if matrix(all_edges(i, 1), all_edges(i,2)) ~= NO_EDGE_MARKER
            edges = [edges;all_edges(i,:)];
            distances = [distances; matrix(all_edges(i, 1), all_edges(i,2))];
        end
        if DEBUG_OUTPUT
            fprintf('Edge from: %i to: %i with length: %i \n', all_edges(i, 1), all_edges(i,2), matrix(all_edges(i, 1), all_edges(i,2))); 
        end
    end

    % debug output: check is edges are correct 
    if DEBUG_OUTPUT
        fprintf('\n\n');
        for i=1:length(edges)
            fprintf('Edge from: %i to: %i with length: %i \n', edges(i, 1), edges(i,2), distances(i));
        end
    end

    tour_length = length(matrix);
    distances_length = length(distances);

    % entrys for the first constraint 
    Aeq = ones(1, length(edges)); %spones(1:length(edges))

    % search for ever node all edges that start or end in node i
    for i = 1:tour_length
        edges_to_i = zeros(length(edges), 1);
        for j = 1:length(edges)
            if edges(j,1) == i || edges(j,2) == i
                edges_to_i(j) = 1;
            end
        end
        % add constraint to constraint matrix
        Aeq(i+1,:) = edges_to_i'; 
    end


    % righthand side of equations
    beq(1) = tour_length;
    beq(:,(2:tour_length+1)) = 2;
    beq = beq';

    % Vector of integer constraints, specified as a vector of positive integers. 
    % The values in intcon indicate the components of the decision variable x that are integer-valued. 
    intcon = 1:distances_length;

    % lb represents the lower bounds elementwise in lb ? x ? ub.
    % since we have only binary decition variables the lower bounds are for all 0
    % i.e. edge is not in tour
    lb = zeros(distances_length,1);

    % and the upper bounds are for alle 1 i.e. edge is is tour
    ub = ones(distances_length,1);

    % additional options - see matlab doc for intlinprog for more
    opts = optimoptions('intlinprog','Display','off');

    % run linear programm
    [result,unsed,exitflag,output] = intlinprog(distances,intcon,[],[],Aeq,beq,lb,ub,opts);

    % If exitflag is 1 optimization converged to the solution in result: go on!
    % Else stop programm and return error message
    if exitflag == 1

        % search for subtours
        subtours = TSP_IntegerProgramm_findSubtours(result,edges,tour_length);
        subtour_length = length(subtours);
        
        fprintf('Remaining subtours: %d\n',subtour_length);

        A = [];
        b = [];
        
        % add a new constraint for every subtour
        while subtour_length > 1 

            % make new lines for new inequality constraints
            b = [b;zeros(subtour_length,1)]; 
            A = [A;zeros(subtour_length,distances_length)];
            
            for i = 1:subtour_length
                constraint_number = size(A,1)+1;
                subtour = subtours{i}; 
                enumberation = nchoosek(1:length(subtour),2);
                for j = 1:length(enumberation)
                    whichVar = (sum(edges==subtour(enumberation(j,1)),2)) & ...
                               (sum(edges==subtour(enumberation(j,2)),2));
                    A(constraint_number,whichVar) = 1;
                end
                
                b(constraint_number) = length(subtour)-1; 
            end

            % run optimization again 
            [result,unused,exitflag,output] = intlinprog(distances,intcon,A,b,Aeq,beq,lb,ub,opts);

            % recheck
            subtours = TSP_IntegerProgramm_findSubtours(result,edges,tour_length);
            subtour_length = length(subtours); 
            
            fprintf('Remaining subtours: %d\n',subtour_length);
            
        end

        tour =  edges(find(result),:);

        % % return the tour in output matrix tour
        % tour = []; %spalloc(size(matrix, 1), 2, 2*size(matrix, 1));
        % row = 1;
        % for i = 1:size(result, 1)
        %     if result(i) == 1
        %         tour(row,:) = [edges(i, 1), edges(i, 2)];
        %         row = row+1;
        %         %fprintf(' %i -> %i \n', edges(i, 1), edges(i,2));
        %     end
        % end

        fprintf('\Solution quality: \n');
        if (output.absolutegap == 0)
            fprintf('\t Solution is optimal. Exitflag: %i \n', exitflag);
        else 
            fprintf('\t Solution is not optimal. Exitflag: %i \n', exitflag);
        end
        
        tourlenght = distances'*result;
        message = output.absolutegap;
        processtime = toc; 

    else
        % return valid data even if somethong goes wrong 
        tour = [];
        tourlenght = 0;
        solutiongab = 0;
        processtime = 0;
        message = 'An Error occured!';
    end

end
