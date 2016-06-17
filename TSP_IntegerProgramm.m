function [ out ] = tspOptLin %(app)

fprintf('############################################\n\n');

tic;

%          A  B  C  D  E  F  G  H  I
%          1  2  3  4  5  6  7  8  9
matrix = [ 0  7  6  0  0  0  6  4  0; % A 1
           7  0  4  7  0  0  0  0  0; % B 2
           6  4  0  3  5  0  0  0 10; % C 3
           0  7  3  0  5 10  0  0  0; % D 4
           0  0  5  5  0  5  8  0  7; % E 5
           0  0  0 10  5  0  4  0  0; % F 6
           6  0  0  0  8  4  0  3  2; % G 7
           4  0  0  0  0  0  3  0  0; % H 8 
           0  0 10  0  7  0  2  0  0  % I 9
         ];
     
matrix = 
     
% fprintf('{');
% for i=1:size(matrix, 1)
%     fprintf('{');
%     for j=1:size(matrix, 2)
%         if matrix(i,j) ==  0
%             fprintf('%i,', 0);
%         else
%             fprintf('%i,', matrix(i,j));
%         end
%     end
%     fprintf('},');
% end
% fprintf('}');

     
NO_EDGE_MARKER =  0;

nStops = length(matrix);


% x = linspace(-pi,pi,50);
% y = 5*sin(x);
% plot(ax,x,y)
% 
G = graph(matrix, 'upper', 'OmitSelfLoops');
P = plot(G);

idxs = nchoosek(1:length(matrix),2);

idxs_clean = [];
dist = [];

for i=1:length(idxs)
    if matrix(idxs(i, 1), idxs(i,2)) ~= NO_EDGE_MARKER
        idxs_clean = [idxs_clean;idxs(i,:)];
        dist = [dist;matrix(idxs(i, 1), idxs(i,2))];
    end
    fprintf('Kante von %i nach %i mit Länge: %i \n', idxs(i, 1), idxs(i,2), matrix(idxs(i, 1), idxs(i,2))); 
end

fprintf('\n\n');
for i=1:length(idxs_clean)
    fprintf('Kante von %i nach %i mit Länge: %i \n', idxs_clean(i, 1), idxs_clean(i,2), dist(i));
end

lendist = length(dist);

Aeq = spones(1:length(idxs_clean)); % Adds up the number of trips
beq = nStops;

Aeq = [Aeq;spalloc(nStops,length(idxs_clean),nStops*(nStops-1))]; % allocate a sparse matrix

for ii = 1:nStops
    
    whichIdxs = (idxs_clean == ii); % find the trips that include stop ii
    whichIdxs = sparse(sum(whichIdxs,2)); % include trips where ii is at either end
    Aeq(ii+1,:) = whichIdxs'; % include in the constraint matrix
end

beq = [beq; 2*ones(nStops,1)];

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


A = spalloc(0,lendist,0); % Allocate a sparse linear inequality constraint matrix
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

dist'*x_tsp

display('Lösungsqüte:');
if (output.absolutegap == 0)
    fprintf('\t Lösung ist optimal \n');
end

fprintf('%f sec.\n', toc)
%app.labelExecutionTime.Text = sprintf('%fms', toc);

end

