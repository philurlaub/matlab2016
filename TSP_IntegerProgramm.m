function [ tour, tourlenght processtime, solutiongab ] = tspOptLin(matrix)%(app)

tic;

% global defines 
NO_EDGE_MARKER =  0;
DEBUG_OUTPUT = false;

nStops = length(matrix);

% all edges e.g. [from, to]
idxs = nchoosek(1:length(matrix),2);

idxs_clean = [];
dist = [];

size(idxs)

% only edges that are valid - i.e. not zero
for i=1:length(idxs)
    if matrix(idxs(i, 1), idxs(i,2)) ~= NO_EDGE_MARKER
        idxs_clean = [idxs_clean;idxs(i,:)];
        dist = [dist; matrix(idxs(i, 1), idxs(i,2))];
    end
    if DEBUG_OUTPUT
        fprintf('Edge from: %i to: %i with length: %i \n', idxs(i, 1), idxs(i,2), matrix(idxs(i, 1), idxs(i,2))); 
    end
end

% debug output: check is edges are correct 
if DEBUG_OUTPUT
    fprintf('\n\n');
    for i=1:length(idxs_clean)
        fprintf('Edge from: %i to: %i with length: %i \n', idxs_clean(i, 1), idxs_clean(i,2), dist(i));
    end
end


lendist = length(dist);

Aeq = spones(1:length(idxs_clean)); % Adds up the number of trips
beq = nStops;

%Aeq = [Aeq;spalloc(nStops,length(idxs_clean),nStops*(nStops-1))]; % allocate a sparse matrix

for i = 1:nStops
    whichIdxs = (idxs_clean == i); % find the trips that include stop i
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(i+1,:) = whichIdxs'; % include in the constraint matrix
end
Aeq
beq = [beq; 2*ones(nStops,1)]

intcon = 1:lendist;
lb = zeros(lendist,1);
ub = ones(lendist,1);

opts = optimoptions('intlinprog','Display','off');
[x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,[],[],Aeq,beq,lb,ub,opts);

segments = find(x_tsp); % Get indices of lines on optimal path


fprintf('\n\n');
for i=1:length(idxs_clean)
    if x_tsp(i)
        fprintf('Kante von %i nach %i mit Länge: %i \n', idxs_clean(i, 1), idxs_clean(i,2), dist(i));
    end
end

tours = detectSubtours(x_tsp,idxs_clean);
numtours = length(tours); % number of subtours
fprintf('# of subtours: %d\n',numtours);


A = []; %spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
b = [];
while numtours > 1 % repeat until there is just one subtour
    % Add the subtour constraints
    b = [b;zeros(numtours,1)]; % allocate b
    A = [A;spalloc(numtours,lendist,nStops)]; % a guess at how many nonzeros to allocate
    for ii = 1:numtours
        rowIdx = size(A,1)+1; % Counter for indexing
        subTourIdx = tours{ii}; % Extract the current subtour
%         The next lines find all of the variables associated with the
%         particular subtour, then add an inequality constraint to prohibit
%         that subtour and all subtours that use those stops.
        variations = nchoosek(1:length(subTourIdx),2);
        for jj = 1:length(variations)
            whichVar = (sum(idxs==subTourIdx(variations(jj,1)),2)) & ...
                       (sum(idxs==subTourIdx(variations(jj,2)),2));
            A(rowIdx,whichVar) = 1;
        end
        b(rowIdx) = length(subTourIdx)-1; % One less trip than subtour stops
    end

    % Try to optimize again
    
    [x_tsp,costopt,exitflag,output] = intlinprog(dist,intcon,A,b,Aeq,beq,lb,ub,opts);
    
    
    % How many subtours this time?
    tours = detectSubtours(x_tsp,idxs);
    numtours = length(tours); % number of subtours
    fprintf('# of subtours: %d\n',numtours);
end


%app.printToGui('test');

fprintf('Tour:')

tour =  idxs_clean(find(x_tsp),:);


% % return the tour in output matrix tour
% tour = []; %spalloc(size(matrix, 1), 2, 2*size(matrix, 1));
% row = 1;
% for i = 1:size(x_tsp, 1)
%     if x_tsp(i) == 1
%         tour(row,:) = [idxs_clean(i, 1), idxs_clean(i, 2)];
%         row = row+1;
%         %fprintf(' %i -> %i \n', idxs_clean(i, 1), idxs_clean(i,2));
%     end
% end

tourlenght = dist'*x_tsp;
solutiongab = output.absolutegap;
processtime = toc; %fprintf('%f sec.\n', toc);

display('Lösungsqüte:');
if (output.absolutegap == 0)
    fprintf('\t Lösung ist optimal \n');
end

%fprintf('%f sec.\n', toc)
%app.labelExecutionTime.Text = sprintf('%fms', toc);

end
